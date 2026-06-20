# Changelog

All notable changes to Resume Buddy are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

The version that ships to users is the `"version"` field in
[`.claude-plugin/plugin.json`](.claude-plugin/plugin.json). Installed plugins only
update when that string changes (see [Releasing](README.md#releasing)).

## [Unreleased]

## [0.1.0] - 2026-06-20

### Added
- Initial release: Claude Code plugin bundling the vendored MCP LaTeX server plus
  resume skills.
- Skills: `resume-init`, `resume-import`, `resume-build`, `resume-tailor`,
  `resume-summarize`, `resume-analyze`, `cover-letter-write`.
- Self-hosted plugin marketplace (`.claude-plugin/marketplace.json`).

[Unreleased]: https://github.com/SiamRahman29/resume-buddy/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/SiamRahman29/resume-buddy/releases/tag/v0.1.0
