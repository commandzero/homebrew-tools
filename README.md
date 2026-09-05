# commandzero Homebrew tap

Homebrew formulae for commandzero tools.

## Install

Install the public tap:

```bash
brew tap commandzero/tools
brew install tq
brew install skillator
```

## Formulae

- [`tq`](https://github.com/commandzero/tq) runs jq-style queries over TOON,
  YAML, JSON, and JSON Lines.
- [`skillator`](https://github.com/commandzero/skillator) manages agent skills
  across Git repositories with a terminal UI and CLI. Version 0.1.0 installs
  prebuilt binaries for Linux amd64, Linux arm64, and macOS arm64 only.

## Bottles

The bottle workflow produces these native packages:

- macOS arm64, built locally on Apple Silicon
- Linux x86_64, built on a native remote host
- Linux arm64, built on a native remote host

For `tq`, Intel macOS has no bottle and builds from source. Its formula keeps Rust as a
build dependency for that path.

The formula tracks the tagged `tq` source release and includes native bottle
checksums after each bottle build.

Copy `.env.example` to `.env`, configure both Linux SSH hosts, then run:

```bash
scripts/build-bottles.sh
```

The script writes bottle archives and metadata to `dist/bottles`, then merges
the bottle checksums into the formula. Upload the `*.bottle*.tar.gz` files to
the GitHub release named `bottles`.

Set `BOTTLE_FORMULAE=tq` to select a formula explicitly.

Skillator installs archives from its GitHub release directly and does not use
the bottle workflow. Intel macOS is not supported by its formula.
