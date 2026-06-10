# US-036 Docs/API Polish Before Release

## Status

implemented

## Lane

normal

## Product Contract

The publishable `dnd_kit` and `dnd_kit_core` packages should be understandable
from their public imports, package READMEs, changelogs, and example
documentation before a release dry-run. The docs must present
`package:dnd_kit/dnd_kit.dart` as the canonical Flutter import, explain
`package:dnd_kit_core/dnd_kit_core.dart` as the pure Dart core import, explain
that applications own data mutation, and distinguish stable sortable APIs from
experimental multi-container exploration.

## Relevant Product Docs

- `docs/product/overview.md`
- `docs/product/api-principles.md`
- `docs/product/package-architecture.md`
- `docs/product/release-roadmap.md`
- `docs/decisions/0008-main-dnd-kit-package.md`

## Acceptance Criteria

- `packages/dnd_kit/README.md` introduces the package, its stable public
  surfaces, and a minimal drag/drop plus sortable usage path.
- `packages/dnd_kit/CHANGELOG.md` exists for the current pre-release package
  version.
- `packages/dnd_kit_core/README.md` introduces the pure Dart package, its
  public surfaces, dependency boundary, and a minimal collision usage path.
- `packages/dnd_kit_core/CHANGELOG.md` exists for the current pre-release
  package version.
- Both publishable package pubspecs include minimal source metadata such as
  repository, issue tracker, and topics.
- The repository and both publishable packages include the project-selected MIT
  `LICENSE` file required by pub validation and repository license display.
- Public library docs for `dnd_kit` and `dnd_kit_core` describe their intended
  import surfaces.
- Example documentation no longer contains stale placeholder text for already
  implemented APIs.
- Documentation keeps user data ownership outside the library and does not
  imply that sortable callbacks mutate collections automatically.
- Validation confirms formatting and static analysis still pass.

## Design Notes

- Commands: `fvm dart format --set-exit-if-changed .`, `fvm dart analyze`.
- Queries: `scripts/bin/harness-cli query matrix`.
- API: no runtime API behavior changes are expected.
- Tables: story row `US-036`.
- Domain rules: release-facing docs should match the current package collapse
  from `US-035`.
- UI surfaces: no app UI behavior changes.

## Validation

When updating durable proof status, use numeric booleans:
`scripts/bin/harness-cli story update --id US-036 --unit 1 --integration 1 --e2e 0 --platform 0`.

| Layer | Expected proof |
| --- | --- |
| Unit | Static analysis passes after public doc changes. |
| Integration | Package docs and examples continue to reference valid public imports. |
| E2E | Not required; no app journey changes. |
| Platform | Not required; no native shell behavior changes. |
| Release | Format check and analyzer pass before publish dry-run work begins. |

## Harness Delta

No Harness tool changes are expected.

## Evidence

- Added `packages/dnd_kit/README.md` with canonical
  `package:dnd_kit/dnd_kit.dart` import guidance, basic drag/drop usage,
  sortable usage, customization notes, and stable versus experimental API
  boundaries.
- Added `packages/dnd_kit/CHANGELOG.md` for `0.1.0-dev.0`.
- Added `packages/dnd_kit_core/README.md` with canonical
  `package:dnd_kit_core/dnd_kit_core.dart` import guidance, public core
  surfaces, a collision detector usage example, and the no-Flutter dependency
  boundary.
- Added `packages/dnd_kit_core/CHANGELOG.md` for `0.1.0-dev.0`.
- Added repository, issue tracker, and topics metadata to both publishable
  package pubspecs.
- Updated public library docs in `packages/dnd_kit/lib/dnd_kit.dart` and
  `packages/dnd_kit_core/lib/dnd_kit_core.dart`.
- Updated `examples/basic_drag_drop/README.md` so it no longer claims
  `DndScope`, `DndDraggable`, and `DndDroppable` are future APIs.
- Fixed a stale dartdoc reference in
  `packages/dnd_kit/lib/src/sortable/sortable_container.dart`.
- `fvm dart format --set-exit-if-changed .` passed.
- `fvm dart analyze` passed with no issues.
- `fvm dart doc --dry-run packages/dnd_kit_core` and
  `fvm dart doc --dry-run packages/dnd_kit` passed with 0 warnings and 0
  errors.
- `fvm dart test packages/dnd_kit_core` passed with 71 tests.
- `fvm flutter test packages/dnd_kit` passed with 104 tests.
- Added MIT `LICENSE` files to the repository root and both publishable package
  roots after the project owner selected MIT.
- `fvm dart pub publish --dry-run` from both package directories now includes
  README, CHANGELOG, license, and pubspec metadata.
- Package publish dry-runs now report only dirty git tree warnings, which are
  expected until the release-readiness changes are committed.
- `rg` found old `dnd_kit_flutter` and `dnd_kit_sortable` names only in
  historical story/decision records, not in current package-facing guidance.

## Release Blocker

Publishing still expects a clean git tree. Pub dry-runs report dirty tree
warnings until the release docs, package metadata, and license files are
committed.
