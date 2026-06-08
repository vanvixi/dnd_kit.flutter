# US-010 Flutter Scope And Controller Foundation

## Status

implemented

## Lane

normal

## Product Contract

`dnd_kit_flutter` must expose the first Flutter adapter foundation with
`DndScope` and `DndController`. Applications can place a scope in the widget
tree, retrieve the active controller from descendants, and use the controller
to model the core drag lifecycle without giving ownership of user data to the
library.

## Relevant Product Docs

- `docs/product/overview.md`
- `docs/product/package-architecture.md`
- `docs/product/api-principles.md`
- `docs/product/release-roadmap.md`

## Acceptance Criteria

- `dnd_kit_flutter` exports `DndScope` and `DndController`.
- `DndScope` supports uncontrolled usage by creating and disposing an internal
  controller.
- `DndScope` supports controlled usage with an external controller and never
  disposes the external controller.
- Descendant widgets can retrieve the nearest controller through
  `DndScope.of(context)` and `DndScope.maybeOf(context)`.
- `DndController` exposes the current core `DndState`, a core `DndRegistry`,
  and lifecycle methods for begin, start, move, end, cancel, and reset.
- Controller lifecycle methods notify listeners when state changes and use core
  state/session/event types rather than Flutter geometry types.
- Tests cover controlled and uncontrolled scope ownership, inherited lookup,
  listener notifications, and controller lifecycle transitions.

## Design Notes

- Commands: `fvm dart format .`, `fvm flutter test packages/dnd_kit_flutter`,
  `fvm dart analyze`, and `scripts/bin/harness-cli story verify US-010`.
- Queries: `scripts/bin/harness-cli query matrix`.
- API: Flutter adapter foundation only; no draggable widget, droppable widget,
  render measuring, gesture recognizer, overlay, auto-scroll, sortable preset,
  or user data mutation behavior in this story.
- Tables: none.
- Domain rules: applications own collection and domain mutation; the controller
  only reports drag lifecycle state.
- UI surfaces: inherited Flutter scope and controller APIs.

## Validation

When updating durable proof status, use numeric booleans:
`scripts/bin/harness-cli story update --id US-010 --unit 1 --integration 1 --e2e 0 --platform 0`.

| Layer | Expected proof |
| --- | --- |
| Unit | `fvm flutter test packages/dnd_kit_flutter` passes. |
| Integration | Widget tests prove scope lookup and controlled/uncontrolled controller lifecycle. |
| E2E | Not required; no complete user-facing drag/drop flow exists yet. |
| Platform | Not required; no platform-specific adapter behavior exists yet. |
| Release | `fvm dart analyze` passes from the repository root. |

## Harness Delta

- Adds the first Phase 2 story packet and durable matrix row.

## Evidence

- `fvm dart format .` completed; formatter updated
  `packages/dnd_kit_flutter/lib/src/controller.dart`.
- `fvm flutter test packages/dnd_kit_flutter` passed with 8 tests.
- `fvm dart analyze` passed with no issues.
