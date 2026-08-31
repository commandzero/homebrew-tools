#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${ROOT_DIR}/dist/bottles"
REMOTE_BASE_DIR="${REMOTE_BASE_DIR:-/tmp/homebrew-tools-bottles-$(date +%s)-$$}"
read -r -a FORMULAE <<<"${BOTTLE_FORMULAE:-tq}"

if [[ -f "${ROOT_DIR}/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${ROOT_DIR}/.env"
  set +a
fi

: "${LINUX_X86_64_SSH_HOST:?Set LINUX_X86_64_SSH_HOST in .env}"
: "${LINUX_ARM64_SSH_HOST:?Set LINUX_ARM64_SSH_HOST in .env}"
: "${BOTTLE_ROOT_URL:?Set BOTTLE_ROOT_URL in .env}"
: "${LINUX_PODMAN_IMAGE:=ghcr.io/homebrew/brew:main}"

TAP="${HOMEBREW_TAP:-commandzero/tools}"
if [[ ! "${TAP}" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
  echo "HOMEBREW_TAP must look like owner/name, got: ${TAP}" >&2
  exit 1
fi
if [[ ! "${REMOTE_BASE_DIR}" =~ ^/tmp/homebrew-tools-bottles-[A-Za-z0-9._-]+$ ]]; then
  echo "REMOTE_BASE_DIR must be a dedicated path under /tmp, got: ${REMOTE_BASE_DIR}" >&2
  exit 1
fi
if [[ ! "${LINUX_PODMAN_IMAGE}" =~ ^[A-Za-z0-9._/@:-]+$ ]]; then
  echo "LINUX_PODMAN_IMAGE contains unsupported characters." >&2
  exit 1
fi
if [[ ! "${BOTTLE_ROOT_URL}" =~ ^https://[A-Za-z0-9._/-]+$ ]]; then
  echo "BOTTLE_ROOT_URL must be an HTTPS URL without query parameters." >&2
  exit 1
fi
for host in "${LINUX_X86_64_SSH_HOST}" "${LINUX_ARM64_SSH_HOST}"; do
  if [[ ! "${host}" =~ ^[A-Za-z0-9_.@:-]+$ || "${host}" == -* ]]; then
    echo "Linux SSH host contains unsupported characters: ${host}" >&2
    exit 1
  fi
done
for formula in "${FORMULAE[@]}"; do
  if [[ ! "${formula}" =~ ^[a-z0-9@+_.-]+$ ]]; then
    echo "Formula name contains unsupported characters: ${formula}" >&2
    exit 1
  fi
done

TAP_USER="${TAP%%/*}"
TAP_REPO="${TAP#*/}"
TAP_FORMULA_PREFIX="${TAP_USER}/${TAP_REPO}"
LOCAL_TAP_DIR="${LOCAL_TAP_DIR:-$(brew --repository)/Library/Taps/${TAP_USER}/homebrew-${TAP_REPO}}"

remote_dir_for() {
  printf '%s-%s' "${REMOTE_BASE_DIR}" "$1"
}

cleanup_remote() {
  local host platform remote_dir
  while IFS='|' read -r host platform; do
    remote_dir="$(remote_dir_for "${platform//\//-}")"
    # Variables expand locally by design after validation above.
    # shellcheck disable=SC2029
    ssh "${host}" \
      "if command -v podman >/dev/null 2>&1; then podman unshare rm -rf '${remote_dir}'; else rm -rf '${remote_dir}'; fi" \
      >/dev/null 2>&1 || true
  done <<EOF
${LINUX_X86_64_SSH_HOST}|linux/amd64
${LINUX_ARM64_SSH_HOST}|linux/arm64
EOF
}
trap cleanup_remote EXIT

mkdir -p "${OUT_DIR}"
for formula in "${FORMULAE[@]}"; do
  rm -f \
    "${OUT_DIR}/${formula}"-*.bottle*.tar.gz \
    "${OUT_DIR}/${formula}"--*.bottle*.tar.gz \
    "${OUT_DIR}/${formula}"--*.bottle.json
done

sync_local_tap() {
  mkdir -p "${LOCAL_TAP_DIR}"
  rsync -a --delete \
    --exclude .git \
    --exclude .env \
    --exclude dist \
    "${ROOT_DIR}/" "${LOCAL_TAP_DIR}/"
}

build_macos_arm64_bottles() {
  if [[ "$(uname -m)" != "arm64" ]]; then
    echo "macOS bottles must be built on Apple Silicon; Intel macOS uses source builds." >&2
    exit 1
  fi

  sync_local_tap

  (
    cd "${LOCAL_TAP_DIR}"
    for formula in "${FORMULAE[@]}"; do
      formula_name="${TAP_FORMULA_PREFIX}/${formula}"
      if brew list --formula "${formula_name}" >/dev/null 2>&1; then
        brew uninstall --force "${formula_name}"
      fi
      brew install --build-bottle "${formula_name}"
      brew bottle --json --no-rebuild --root-url "${BOTTLE_ROOT_URL}" "${formula_name}"
    done
    mv ./*.bottle*.tar.gz ./*.json "${OUT_DIR}/"
  )
}

stage_remote_repo() {
  local host="$1"
  local platform="$2"
  local remote_dir archive
  remote_dir="$(remote_dir_for "${platform//\//-}")"
  archive="$(mktemp -t homebrew-tools.XXXXXX.tar.gz)"

  (
    cd "${ROOT_DIR}"
    tar \
      --exclude .git \
      --exclude .env \
      --exclude dist \
      -czf "${archive}" .
  )

  # Variables expand locally by design after validation above.
  # shellcheck disable=SC2029
  ssh "${host}" \
    "if command -v podman >/dev/null 2>&1; then podman unshare rm -rf '${remote_dir}'; else rm -rf '${remote_dir}'; fi && mkdir -p '${remote_dir}' && chmod 777 '${remote_dir}'"
  scp "${archive}" "${host}:${remote_dir}/repo.tar.gz"
  # shellcheck disable=SC2029
  ssh "${host}" \
    "cd '${remote_dir}' && tar -xzf repo.tar.gz && rm repo.tar.gz && chmod -R a+rwX '${remote_dir}'"
  rm -f "${archive}"
}

build_linux_bottles() {
  local host="$1"
  local platform="$2"
  local expected_machine="$3"
  local remote_dir formula_list
  remote_dir="$(remote_dir_for "${platform//\//-}")"
  formula_list="${FORMULAE[*]}"

  stage_remote_repo "${host}" "${platform}"

  # Variables expand locally by design after validation above.
  # shellcheck disable=SC2029
  ssh "${host}" "cd '${remote_dir}' && podman run --rm --pull=missing --platform '${platform}' -v '${remote_dir}:/work:Z' -w /work '${LINUX_PODMAN_IMAGE}' bash -lc '
    set -euo pipefail
    actual_machine=\"\$(uname -m)\"
    if [[ \"\${actual_machine}\" != \"${expected_machine}\" ]]; then
      echo \"Expected ${expected_machine}, got \${actual_machine}\" >&2
      exit 1
    fi
    git config --global init.defaultBranch main
    git -C /work init
    git config --global --add safe.directory /work
    git config --global user.name bottle-builder
    git config --global user.email bottle-builder@example.invalid
    git -C /work add .
    git -C /work commit -m bottle-build-tap
    brew tap --custom-remote ${TAP_FORMULA_PREFIX} file:///work
    tap_dir=\"\$(brew --repo ${TAP_FORMULA_PREFIX})\"
    cd \"\${tap_dir}\"
    for formula in ${formula_list}; do
      formula_name=\"${TAP_FORMULA_PREFIX}/\${formula}\"
      if brew list --formula \"\${formula_name}\" >/dev/null 2>&1; then
        brew uninstall --force \"\${formula_name}\"
      fi
      brew install --build-bottle \"\${formula_name}\"
      brew bottle --json --no-rebuild --root-url \"${BOTTLE_ROOT_URL}\" \"\${formula_name}\"
    done
    cp ./*.bottle*.tar.gz ./*.json /work/
  '"

  scp "${host}:${remote_dir}/*.bottle*.tar.gz" "${OUT_DIR}/"
  scp "${host}:${remote_dir}/*.json" "${OUT_DIR}/"
}

merge_bottle_blocks() {
  local json_files=()
  local formula
  shopt -s nullglob
  for formula in "${FORMULAE[@]}"; do
    json_files+=("${OUT_DIR}/${formula}"--*.bottle.json)
  done
  shopt -u nullglob

  if (( ${#json_files[@]} != ${#FORMULAE[@]} * 3 )); then
    echo "Expected three bottle metadata files per formula, found ${#json_files[@]}." >&2
    exit 1
  fi

  (
    cd "${ROOT_DIR}"
    brew bottle --merge --write --no-commit "${json_files[@]}"
  )

  local merged_tap_dir
  merged_tap_dir="$(brew --repo "${TAP_FORMULA_PREFIX}")"
  for formula in "${FORMULAE[@]}"; do
    cp "${merged_tap_dir}/Formula/${formula}.rb" "${ROOT_DIR}/Formula/${formula}.rb"
  done
}

normalize_bottle_filenames() {
  local json_files=()
  local formula
  shopt -s nullglob
  for formula in "${FORMULAE[@]}"; do
    json_files+=("${OUT_DIR}/${formula}"--*.bottle.json)
  done
  shopt -u nullglob

  ruby -rjson -rfileutils -e '
    ARGV.each do |json_path|
      JSON.parse(File.read(json_path)).each_value do |metadata|
        metadata.fetch("bottle").fetch("tags").each_value do |tag|
          source = File.join(File.dirname(json_path), tag.fetch("local_filename"))
          target = File.join(File.dirname(json_path), tag.fetch("filename"))
          FileUtils.mv(source, target) unless source == target
        end
      end
    end
  ' "${json_files[@]}"
}

build_macos_arm64_bottles
build_linux_bottles "${LINUX_X86_64_SSH_HOST}" "linux/amd64" "x86_64"
build_linux_bottles "${LINUX_ARM64_SSH_HOST}" "linux/arm64" "aarch64"
merge_bottle_blocks
normalize_bottle_filenames

cat <<EOF
Bottles are in:
  ${OUT_DIR}

Formula bottle blocks were merged locally. Upload the bottle tarballs in
${OUT_DIR} to:
  ${BOTTLE_ROOT_URL}
EOF
