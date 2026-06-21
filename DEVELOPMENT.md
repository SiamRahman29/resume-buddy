# Development

## Local development

To hack on the plugin from a clone:

```
git clone https://github.com/SiamRahman29/resume-buddy
/plugin marketplace add ./resume-buddy
/plugin install resume-buddy@resume-buddy
```

As long as `uv` is on your `PATH` (see [Prerequisites](README.md#prerequisites) in the README), nothing else is needed — the
`latex-server` MCP launches via `uv run`, which installs the server's Python deps
automatically on first launch.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Skills/MCP not available | Confirm the plugin is installed: `/plugin` |
| MCP server won't start | Ensure `uv` is installed and on `PATH` |
| Compile fails with LaTeX errors | Ask the AI to `validate_latex` first; it shows the error |
| `pdflatex` not found | Install MiKTeX / MacTeX / TeX Live and ensure it's on `PATH` |
| Server rejected earlier | `claude mcp reset-project-choices` |

## Releasing

> For maintainers. Users get updates by running `/plugin marketplace update`.

Installed plugins are **pinned to the `version` string** in
[`.claude-plugin/plugin.json`](.claude-plugin/plugin.json). A user's `/plugin
marketplace update` only pulls new code when that string changes — so **bumping the
version is the release.** Commits that don't bump it (docs, WIP, refactors) never reach
users, even after a refresh.

Because the marketplace `source` is `./` (this repo's default branch), a release ships
whatever is at `main` HEAD when you bump the version. So: **keep `main` shippable, and
only bump the version when it is.**

To cut a release:

1. Pick the new version per [SemVer](https://semver.org/) (`MAJOR.MINOR.PATCH`).
2. Move `## [Unreleased]` notes into a new dated section in
   [`CHANGELOG.md`](CHANGELOG.md), and update the compare links at the bottom.
3. Bump `"version"` in `.claude-plugin/plugin.json`.
4. Commit (e.g. `release: v0.2.0`) and push to `main`.

That's it — pushing a changed `version` to `main` triggers the
[release workflow](.github/workflows/release.yml), which tags `v0.2.0` and cuts a
GitHub Release using the matching `CHANGELOG.md` section as the notes. Commits that
don't change `version` are ignored, and re-running with an already-released version is
a safe no-op.

For the release notes to look right, **bump the `version` and update the CHANGELOG in
the same push** — the workflow reads the `## [X.Y.Z]` section that matches the new
version.

Never remove the `version` field — without it, *every* commit to `main` becomes an
automatic update for users.
