# Changelog

All notable changes to Resume Buddy are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

The version that ships to users is the `"version"` field in
[`.claude-plugin/plugin.json`](.claude-plugin/plugin.json). Installed plugins only
update when that string changes (see [Releasing](README.md#releasing)).

## [Unreleased]

## [0.5.1] - 2026-07-28

### Fixed
- `resume-scrape`: the vendored `browse` launcher rebranded Chromium by patching
  Playwright's shared, global Chromium `.app` bundle (Info.plist + icon) in place,
  mutating a cache other Playwright-based tools may also use. Now patches a private
  copy under `~/.gstack/chromium-branded` and ad-hoc re-signs it, leaving Playwright's
  own download untouched.

### Documentation
- `resume-scrape`: note that LinkedIn's passkey/Touch ID sign-in can't complete in the
  vendored browser (it isn't a signed, entitled app) — it hands off to an empty Safari
  tab and closes the gstack window. Use email + password instead.

## [0.5.0] - 2026-07-16

### Added
- `resume-batch`: tailor across a whole `jobs/` folder in one pass. Triages postings for
  genuine fit (keyword searches drag in unrelated roles — those get filtered, not
  tailored), clusters the survivors by the shape of resume they need rather than by job
  title, so near-identical roles share one variant instead of spawning a throwaway each.
  The user picks scope (all clusters vs. top-N by fit); each selected cluster yields a
  `resume-<cluster>.tex`, each job a company-specific cover letter, and `jobs/index.md`
  records the whole search. Never edits the master.
- `resume-scrape`: collect job postings from a listing page (e.g. a LinkedIn jobs
  search) into a local `jobs/` folder for batch tailoring. Uses a human-in-the-loop
  login — it opens a *visible* browser, the user logs in themselves, then Claude drives
  the already-authenticated session to gather each posting's title, company, location,
  and description. Scraped content is treated as untrusted data, never instructions.
- Vendored the gstack `browse` subsystem (MIT) under `vendor/browse/` as the browser
  engine for `resume-scrape`. Source-only: deps and Chromium install on first run via
  `bun`, mirroring how the LaTeX server builds on first use with `uv`. Adds `bun` and
  `node` as prerequisites for the scraping workflow only.
- `skills/resume-scrape/scripts/linkedin-extract.js`: the posting extractor, anchored on
  `document.title`, the "About the job" heading, and `data-testid` hooks rather than
  LinkedIn's hashed, server-driven-UI class names. Verified against a live logged-in
  search: 25/25 postings captured with full descriptions.

## [0.4.0] - 2026-06-22

### Added
- `resume-critique`: a JD-free, read-only companion to `resume-analyze` that judges a
  resume on its own merits against the saved principles — a principles scorecard (each
  dimension scored 0–10 plus an overall grade), a senior recruiter's verdict (what the
  resume sells, strongest/weakest element, shortlist yes/no), and a ranked list of the
  highest-leverage fixes.

## [0.3.0] - 2026-06-22

### Changed
- `resume-import`: added a typography iron rule requiring imports to reproduce the
  font, size, weight, and color of every styled element verbatim (bold stays bold),
  and widened the PDF capture step to inventory those four dimensions.

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

[Unreleased]: https://github.com/SiamRahman29/resume-buddy/compare/v0.5.1...HEAD
[0.5.1]: https://github.com/SiamRahman29/resume-buddy/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/SiamRahman29/resume-buddy/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/SiamRahman29/resume-buddy/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/SiamRahman29/resume-buddy/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/SiamRahman29/resume-buddy/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/SiamRahman29/resume-buddy/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/SiamRahman29/resume-buddy/releases/tag/v0.1.0
