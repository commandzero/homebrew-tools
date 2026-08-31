# commandzero Homebrew tap

Homebrew formulae for commandzero tools.

## Install

Install the public tap:

```bash
brew tap commandzero/tools
brew install tq
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
