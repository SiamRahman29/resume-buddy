# vendor/browse

Source-only vendor of the **browse** subsystem from
[gstack](https://github.com/garryod/gstack) (Garry Tan, MIT — see `LICENSE`). It's the
headless/headed browser engine behind Resume Buddy's `resume-scrape` skill.

## What's here (and what isn't)

- `src/` — the browse CLI + server (TypeScript), copied verbatim from gstack.
- `dist/server-node.mjs`, `dist/bun-polyfill.cjs` — the prebuilt portable Node server
  bundle (needed on Windows). Not platform-specific.
- `scripts/build-node-server.sh` — regenerates `dist/server-node.mjs` from `src/`.
- `bin/browse` — Resume Buddy's launcher (not from upstream).
- **Excluded on purpose:** the upstream `dist/browse(.exe)` / `find-browse(.exe)`
  compiled binaries (111 MB each, platform-specific) and the gstack skill/extension
  plumbing. We run the CLI from source via `bun` instead.

## Running it

```bash
vendor/browse/bin/browse <command> [args...]
```

Requires `bun` and `node` on `PATH`. The first run does `bun install` +
`playwright install chromium` (~150 MB, one-time), then runs `src/cli.ts` via `bun` —
the same build-on-first-launch model the LaTeX server uses with `uv run`.

## Updating from upstream

Re-copy `src/`, refresh `dist/server-node.mjs` (run `scripts/build-node-server.sh` or
copy the prebuilt file), keep `bin/browse`, `package.json`, this README, and `LICENSE`.
Verify deps in `package.json` still match (`playwright`, `diff`).
