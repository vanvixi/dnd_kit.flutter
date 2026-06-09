# US-023 Flutter Visual State Builders

## Status

implemented

## Lane

normal

## Product Contract

`dnd_kit_flutter` exposes visual state builders for `DndDraggable` and
`DndDroppable` so applications can render active, over, disabled, and session
details without owning controller subscriptions directly. The builders only
report drag/drop state; applications still own their data and visual choices.

## Relevant Product Docs

- `docs/product/overview.md`
- `docs/product/package-architecture.md`
- `docs/product/api-principles.md`
- `docs/product/release-roadmap.md`

## Acceptance Criteria

- `DndDraggable` accepts an optional builder that receives the child and current
  draggable visual state.
- `DndDroppable` accepts an optional builder that receives the child and current
  droppable visual state.
- Draggable details report id, disabled state, whether the draggable is active,
  whether it is actively dragging, whether it is dropping, and the active
  session when available.
- Droppable details report id, disabled state, whether it is the current over
  target, the active id, and the active session when available.
- Existing `child`-only usage remains source-compatible.

## Design Notes

- Commands:
  - `fvm dart format .`
  - `fvm flutter test packages/dnd_kit_flutter`
  - `fvm dart analyze`
- Queries:
  - `scripts/bin/harness-cli query matrix`
- API:
  - `DndDraggableBuilder`
  - `DndDraggableDetails`
  - `DndDroppableBuilder`
  - `DndDroppableDetails`
- Tables:
  - Harness `story` proof row for `US-023`.
- Domain rules:
  - User data remains external; builders receive drag/drop state only.
  - Visual state is a Flutter adapter concern, not a core package concern.
- UI surfaces:
  - Flutter adapter widget tree for draggable and droppable visuals.

## Validation

When updating durable proof status, use numeric booleans:
`scripts/bin/harness-cli story update --id US-023 --unit 1 --integration 1 --e2e 0 --platform 0`.

| Layer | Expected proof |
| --- | --- |
| Unit | Flutter widget tests prove builder details and rebuilds for draggable and droppable state changes. |
| Integration | `fvm flutter test packages/dnd_kit_flutter` passes. |
| E2E | Not required for this adapter API slice. |
| Platform | Not required for this adapter API slice. |
| Release | `fvm dart analyze` and `fvm dart format .` pass. |

## Harness Delta

None expected.

## Evidence

- `fvm dart format .` passed.
- `fvm flutter test packages/dnd_kit_flutter` passed with 61 tests, including
  draggable and droppable visual state builder coverage.
- `fvm dart analyze` passed with no issues.
- `scripts/bin/harness-cli story verify US-023` passed.
