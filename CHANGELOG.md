# Changelog

All notable changes to Resume Buddy are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

The version that ships to users is the `"version"` field in
[`.claude-plugin/plugin.json`](.claude-plugin/plugin.json). Installed plugins only
update when that string changes (see [Releasing](README.md#releasing)).

## [Unreleased]

## [0.2.0] - 2026-06-22

### Added
- `references/resume-principles.md`: a shared knowledge base of transferable
  resume-writing standards (ATOP bullet formula, action-verb bank, Do's & Don'ts,
  formatting, ATS-friendliness, targeting, industry notes) distilled from the Dartmouth
  College CPD Resume Guide.

### Changed
- Skills now cite the shared principles instead of re-deriving guidance: `resume-tailor`,
  `resume-summarize`, `resume-analyze`, `resume-import` (flag-only), `cover-letter-write`,
  and `resume-init` (judgment calls).
- `templates/resume.tex`: reworked the starter into a cleaner, principles-aligned layout.

## [0.1.1] - 2026-06-21

### Changed
- `resume-import`: tightened instructions to stick to the user's source material and
  name `.tex` files with timestamps.
- `resume-build`: compile the resolved master and save outputs to a `build/` folder
  alongside it.

### Added
- Version-bump-driven release automation: a GitHub Actions workflow tags and cuts a
  GitHub Release whenever `version` changes on `main`.

### Removed
- Redundant setup scripts.

## [0.1.0] - 2026-06-20

### Added
- Initial release: Claude Code plugin bundling the vendored MCP LaTeX server plus
  resume skills.
- Skills: `resume-init`, `resume-import`, `resume-build`, `resume-tailor`,
  `resume-summarize`, `resume-analyze`, `cover-letter-write`.
- Self-hosted plugin marketplace (`.claude-plugin/marketplace.json`).

[Unreleased]: https://github.com/SiamRahman29/resume-buddy/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/SiamRahman29/resume-buddy/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/SiamRahman29/resume-buddy/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/SiamRahman29/resume-buddy/releases/tag/v0.1.0
