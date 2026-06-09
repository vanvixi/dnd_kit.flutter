# US-016 Flutter Long-Press Drag Activation

## Status

implemented

## Lane

normal

## Product Contract

`dnd_kit_flutter` must let applications require a long press before pointer
drag activation so touch-first interfaces can avoid accidental drags during
taps and scrolling.

## Relevant Product Docs

- `docs/product/overview.md`
- `docs/product/package-architecture.md`
- `docs/product/api-principles.md`
- `docs/product/release-roadmap.md`

## Acceptance Criteria

- `DndDraggable` exposes a long-press activation option for pointer drags.
- A pointer down starts a pending drag, but dragging begins only after the
  configured long-press delay.
- Pointer movement beyond the configured tolerance before the delay cancels the
  pending drag.
- Pointer up before the delay cancels the pending drag and does not emit a drag
  start event.
- Existing distance activation behavior still works for draggables that do not
  opt into long-press activation.
- Drag handles can use the same long-press activation behavior.
- Widget tests cover delay activation, tolerance cancel, early pointer up, and
  drag handle interaction.

## Design Notes

- Commands: `fvm dart format .`, `fvm flutter test packages/dnd_kit_flutter`,
  `fvm dart analyze`, and `scripts/bin/harness-cli story verify US-016`.
- Queries: `scripts/bin/harness-cli query matrix`.
- API: a small Flutter long-press activation configuration on `DndDraggable`
  backed by the existing `DndPointerSensor` runtime.
- Tables: none.
- Domain rules: applications still own user data and collection mutation.
- UI surfaces: pointer long-press activation only; keyboard sensors, overlays,
  auto-scroll, sortable presets, and dedicated examples remain out of scope.

## Validation

When updating durable proof status, use numeric booleans:
`scripts/bin/harness-cli story update --id US-016 --unit 1 --integration 1 --e2e 0 --platform 0`.

| Layer | Expected proof |
| --- | --- |
| Unit | `fvm flutter test packages/dnd_kit_flutter` passes. |
| Integration | Widget tests prove long-press behavior through `DndScope`, `DndController`, `DndDraggable`, and `DndDragHandle`. |
| E2E | Not required; no full example app flow changes in this story. |
| Platform | Not required; long-press activation uses Flutter widget tests only. |
| Release | `fvm dart analyze` passes from the repository root. |

## Harness Delta

- Adds the third Phase 3 story packet and durable matrix row.

## Evidence

- `fvm dart format .` passed.
- `fvm flutter test packages/dnd_kit_flutter` passed with 36 tests, including
  long-press delay, tolerance, early pointer-up, and drag handle coverage.
- `fvm dart analyze` passed with no issues.
- `scripts/bin/harness-cli story verify US-016` passed.
