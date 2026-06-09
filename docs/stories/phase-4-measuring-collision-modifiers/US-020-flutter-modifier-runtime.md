# US-020 Flutter Modifier Runtime

## Status

implemented

## Lane

normal

## Product Contract

`dnd_kit_flutter` must apply core `DndModifier` functions during active drag
movement so Flutter pointer and keyboard drags can constrain, snap, or otherwise
adjust the drag transform before collision detection and callbacks observe it.

## Relevant Product Docs

- `docs/product/overview.md`
- `docs/product/package-architecture.md`
- `docs/product/api-principles.md`
- `docs/product/release-roadmap.md`

## Acceptance Criteria

- `DndController` accepts a list of `DndModifier` functions.
- Active drag movement applies modifiers in order using `DndModifiers.compose`.
- Modifier input includes the active draggable rectangle, measured droppable
  rectangles, and current pointer.
- Collision detection uses the modified transform, not the raw pointer delta.
- Drag move/end/cancel callbacks observe the modified session position.
- Pointer and keyboard drags both share the same modifier runtime.
- Existing unmodified drag behavior remains unchanged when no modifiers are
  supplied.
- Flutter adapter tests cover modifier application, collision behavior, and
  keyboard movement through the controller/widget runtime.

## Design Notes

- Commands: `fvm dart format .`, `fvm flutter test packages/dnd_kit_flutter`,
  `fvm dart analyze`, and `scripts/bin/harness-cli story verify US-020`.
- Queries: `scripts/bin/harness-cli query matrix`.
- API: add an optional `modifiers` parameter to `DndController`.
- Tables: none.
- Domain rules: applications still own user data and collection mutation.
- UI surfaces: no new widgets or visual overlay in this story.

## Validation

When updating durable proof status, use numeric booleans:
`scripts/bin/harness-cli story update --id US-020 --unit 1 --integration 1 --e2e 0 --platform 0`.

| Layer | Expected proof |
| --- | --- |
| Unit | `fvm flutter test packages/dnd_kit_flutter` covers controller modifier output. |
| Integration | Widget tests prove pointer and keyboard drags use modified movement through `DndScope`, `DndController`, and `DndDraggable`. |
| E2E | Not required; no example app flow changes in this story. |
| Platform | Not required; modifier runtime uses Flutter widget tests only. |
| Release | `fvm dart analyze` passes from the repository root. |

## Harness Delta

- Adds the first Phase 4 story packet for measuring, collision runtime, and
  modifiers.

## Evidence

- `fvm dart format .` passed; 33 files checked with no formatting changes after
  the modifier runtime patch.
- `fvm flutter test packages/dnd_kit_flutter` passed with 46 tests, including
  controller, pointer drag, and keyboard drag modifier coverage.
- `fvm dart analyze` passed with no issues.
- `scripts/bin/harness-cli story verify US-020` passed.
