# commandzero Homebrew tap

Homebrew formulae for commandzero tools.

## Install

Install the public tap:

```bash
brew tap commandzero/tools
brew install tq
brew install skillator
brew install tless
brew install tview
```

## Formulae

- [`tq`](https://github.com/commandzero/tq) runs jq-style queries over TOON,
  YAML, JSON, and JSON Lines.
- [`skillator`](https://github.com/commandzero/skillator) manages agent skills
  across Git repositories with a terminal UI and CLI. Version 0.1.0 installs
  prebuilt binaries for Linux amd64, Linux arm64, and macOS arm64 only.
- [`tless`](https://github.com/commandzero/tless) views JSON, YAML, and TOON in
  the terminal. Version 0.2.1 installs prebuilt binaries for Linux amd64,
  Linux arm64, macOS Intel, and macOS arm64.
- [`tview`](https://github.com/commandzero/tview) browses CSV, JSON, NDJSON, and
  SQLite data in the terminal. Version 0.1.1 includes saved views and clipboard
  support, with archives for macOS 14+ arm64 and Ubuntu 24.04+ Linux amd64/arm64
  (glibc 2.39+). Intel macOS and a source-build fallback are not supported.

## Bottles

Every `tq` release must publish matching native bottles before its formula is
promoted:

- macOS arm64 (`macos-15`)
- Linux x86_64 (`ubuntu-24.04`)
- Linux arm64 (`ubuntu-24.04-arm`)

For `tq`, Intel macOS has no bottle and builds from source. Its formula keeps Rust as a
build dependency for that path.

The `tq` 0.5.0 formula follows TOON 4.4. Source builds require Rust 1.95 or
newer; supported bottle targets must not fall back to compiling from source.

Run `.github/workflows/tq-bottles.yml` on the release formula branch. It builds
the tagged source on native runners, pours each resulting bottle, runs the
formula test and a TOON 4.4 escape check, and retains bottle archives and metadata.
Only use artifacts from a successful run: artifacts retained after a failure
are diagnostic evidence, not verified release packages.

Upload all three verified `*.bottle.tar.gz` files to the existing GitHub release
named `bottles`, without replacing published assets. Merge the matching JSON
metadata with `brew bottle --merge --write --no-commit`, then commit the formula
checksums in a PR. The PR's `.github/workflows/bottle-install.yml` checks must
pass on all three native targets: they install the published bottle, run
`brew test`, and require a `poured_from_bottle` receipt. Source builds, product
binary archives, missing bottle metadata, or stale checksums do not satisfy
this release gate.

For the alternative local/SSH builder, copy `.env.example` to `.env`, configure
the x86_64 Linux SSH host and either the arm64 Linux SSH host or
`LINUX_ARM64_LOCAL_DOCKER=1` on Apple Silicon with
Docker Desktop, then run:

```bash
scripts/build-bottles.sh
```

The script writes bottle archives and metadata to `dist/bottles`, then merges
the bottle checksums into the local formula. Publish and verify all bottles
before promoting that formula, using the same PR installation gate above.

Set `BOTTLE_FORMULAE=tq` to select a formula explicitly.

Skillator installs archives from its GitHub release directly and does not use
the bottle workflow. Intel macOS is not supported by its formula.

Tview also installs product release archives directly and does not use the bottle
workflow. Each archive includes the binary, license, and build provenance.
