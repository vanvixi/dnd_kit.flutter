# US-015 DndDragHandle Foundation

## Status

implemented

## Lane

normal

## Product Contract

`dnd_kit_flutter` must provide a `DndDragHandle` widget that lets applications
limit pointer drag activation to an explicit child region while preserving the
existing whole-draggable behavior when no handle is present.

## Relevant Product Docs

- `docs/product/overview.md`
- `docs/product/package-architecture.md`
- `docs/product/api-principles.md`
- `docs/product/release-roadmap.md`

## Acceptance Criteria

- `dnd_kit_flutter` exposes a public `DndDragHandle` widget.
- `DndDraggable` keeps starting pointer drags from the whole child when no
  handle is registered.
- When a draggable contains one or more handles, pointer drag activation starts
  only from a handle.
- Drag handles delegate to the same `DndPointerSensor` runtime as direct
  draggable pointer gestures.
- Existing pointer activation constraints still apply when activation begins
  from a handle.
- Disabling a draggable prevents handle activation and cancels active handle
  drags consistently with existing draggable gestures.
- Widget tests cover handle-only activation, non-handle suppression, fallback
  whole-child activation, and activation constraints through a handle.

## Design Notes

- Commands: `fvm dart format .`, `fvm flutter test packages/dnd_kit_flutter`,
  `fvm dart analyze`, and `scripts/bin/harness-cli story verify US-015`.
- Queries: `scripts/bin/harness-cli query matrix`.
- API: `DndDragHandle` and internal `DndDraggable` handle coordination.
- Tables: none.
- Domain rules: applications still own user data and collection mutation.
- UI surfaces: drag handle activation only; mouse/touch specialization, long
  press, keyboard sensors, overlays, auto-scroll, and sortable presets remain
  out of scope.

## Validation

When updating durable proof status, use numeric booleans:
`scripts/bin/harness-cli story update --id US-015 --unit 1 --integration 1 --e2e 0 --platform 0`.

| Layer | Expected proof |
| --- | --- |
| Unit | `fvm flutter test packages/dnd_kit_flutter` passes. |
| Integration | Widget tests prove handle activation through `DndScope`, `DndController`, `DndDraggable`, and `DndDragHandle`. |
| E2E | Not required; no full example app flow changes in this story. |
| Platform | Not required; drag handles use Flutter widget tests only. |
| Release | `fvm dart analyze` passes from the repository root. |

## Harness Delta

- Adds the second Phase 3 story packet and durable matrix row.

## Evidence

- `fvm dart format .` passed.
- `fvm flutter test packages/dnd_kit_flutter` passed with 32 tests, including
  drag handle widget coverage.
- `fvm dart analyze` passed with no issues.
- `scripts/bin/harness-cli story verify US-015` passed.
