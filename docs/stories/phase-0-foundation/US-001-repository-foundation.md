# US-001 Repository Foundation

## Status

implemented

## Lane

normal

## Product Contract

The repository must establish the initial `dnd_kit` package family without
claiming behavior that has not been implemented yet. Phase 0 creates the
monorepo layout, package boundaries, product docs, validation expectations, and
the first executable package surfaces that future stories can fill in.

## Relevant Product Docs

- `docs/product/overview.md`
- `docs/product/package-architecture.md`
- `docs/product/api-principles.md`
- `docs/product/release-roadmap.md`

## Acceptance Criteria

- Repo has `packages/dnd_kit_core`, `packages/dnd_kit_flutter`,
  `packages/dnd_kit_sortable`, `packages/dnd_kit`, `examples/`, and `docs/`.
- Each package has its own `pubspec.yaml`.
- The umbrella `dnd_kit` package exports the three sub-packages.
- Root package configuration supports monorepo bootstrap and validation.
- Static analysis can run from the repository root.
- Root `README.md` explains the library goal and current status.
- Product docs capture the stable product direction from `SPEC.md`.
- No package pretends that unimplemented drag/drop behavior exists.

## Design Notes

- Commands: root validation should begin with `fvm dart analyze`.
- Queries: none.
- API: only library entrypoints and placeholder exports are created in this
  story.
- Tables: none.
- Domain rules: core remains pure Dart and must not import Flutter.
- UI surfaces: no user-facing examples are implemented in this story.

## Validation

When updating durable proof status, use numeric booleans:
`scripts/bin/harness-cli story update --id US-001 --unit 1 --integration 0 --e2e 0 --platform 0`.

| Layer | Expected proof |
| --- | --- |
| Unit | `fvm dart analyze` passes for the scaffolded package family. |
| Integration | Not required until packages contain behavior crossing package boundaries. |
| E2E | Not required until examples contain runnable UI behavior. |
| Platform | Not required until Flutter examples target mobile, web, or desktop builds. |
| Release | `melos bootstrap` is expected for full Phase 0 release readiness once dependency resolution is available. |

## Harness Delta

- SPEC content starts moving into smaller product docs.
- Harness story `US-001` tracks Phase 0 foundation work in the durable matrix.

## Evidence

- `fvm flutter pub get` completed.
- `fvm flutter pub run melos bootstrap` completed and bootstrapped 4 packages.
- `fvm dart format .` completed with no changes needed.
- `fvm dart analyze` passed with no issues.
- `fvm flutter pub run melos run analyze` passed for all 4 packages.
- `fvm flutter pub run melos run test` passed with 0 test packages.
- `scripts/bin/harness-cli story verify US-001` passed with `fvm dart analyze`.
