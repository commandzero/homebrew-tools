# commandzero Homebrew tap

Homebrew formulae for commandzero tools.

## Install

The tap is private until the first `tq` release. Once it is public:

```bash
brew tap commandzero/tools
brew install tq
```

Before the first tagged release, maintainers can install `tq` from the private
repository with GitHub access:

```bash
brew install --HEAD commandzero/tools/tq
```

## Formulae

- [`tq`](https://github.com/commandzero/tq) runs jq-style queries over TOON,
  YAML, JSON, and JSON Lines.

## Bottles

The bottle workflow produces these native packages:

- macOS arm64, built locally on Apple Silicon
- Linux x86_64, built on a native remote host
- Linux arm64, built on a native remote host

Intel macOS has no bottle and builds from source. The formula keeps Rust as a
build dependency for that path.

The checked-in formula is HEAD-only while `tq` is private. Add the tagged
source URL, version, and SHA-256 before building the first bottles.

Copy `.env.example` to `.env`, configure both Linux SSH hosts, then run:

```bash
scripts/build-bottles.sh
```

The script writes bottle archives and metadata to `dist/bottles`, then merges
the bottle checksums into the formula. Upload the `*.bottle*.tar.gz` files to
the GitHub release named `bottles`.

Set `BOTTLE_FORMULAE=tq` to select a formula explicitly.
