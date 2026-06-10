# US-030 Experimental Multi-Container Sortable

## Status

implemented

## Lane

normal

## Product Contract

`dnd_kit_sortable` exposes an experimental multi-container sortable model and
move-intent helper so advanced developers can prototype Kanban-style sorting
without changing the stable same-container sortable widgets.

## Relevant Product Docs

- `docs/product/overview.md`
- `docs/product/package-architecture.md`
- `docs/product/api-principles.md`
- `docs/product/release-roadmap.md`

## Acceptance Criteria

- Experimental multi-container APIs are annotated with `@experimental`.
- A `SortableContainer` model exists.
- `SortableMoveDetails` can describe same-container and cross-container moves.
- Documentation clearly states that the multi-container API is not stable yet.
- An experimental example exists.
- Breaking changes to the experimental API do not affect stable sortable APIs.

## Design Notes

- Commands:
  - `fvm dart format .`
  - `fvm flutter test packages/dnd_kit_sortable`
  - `fvm dart analyze`
- Queries:
  - `scripts/bin/harness-cli query matrix`
- API:
  - `SortableContainer`
  - `SortableMultiContainer.moveDetailsFor`
  - extended `SortableMoveDetails`
- Tables:
  - Harness `story` proof row for `US-030`.
- Domain rules:
  - Applications still own all item and container mutation.
  - Experimental multi-container APIs must stay additive to stable APIs.
- UI surfaces:
  - `examples/multi_container_sortable/README.md`

## Validation

When updating durable proof status, use numeric booleans:
`scripts/bin/harness-cli story update --id US-030 --unit 1 --integration 1 --e2e 0 --platform 0`.

| Layer | Expected proof |
| --- | --- |
| Unit | Sortable container and multi-container move helper tests. |
| Integration | Existing sortable widget tests continue to pass. |
| E2E | Not required for this experimental API slice. |
| Platform | Deferred to Phase 8 production hardening. |
| Release | `fvm dart analyze` and `fvm dart format .` pass. |

## Harness Delta

None expected.

## Evidence

- `fvm dart format .` passed.
- `fvm flutter test packages/dnd_kit_sortable` passed with 34 tests including
  experimental multi-container sortable coverage.
- `fvm dart analyze` passed with no issues.
- `scripts/bin/harness-cli story verify US-030` passed.
