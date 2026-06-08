# Product Overview

## Summary

`dnd_kit` is a Flutter drag-and-drop toolkit for building production drag-heavy
interfaces. It takes inspiration from React dnd-kit but uses Flutter-native
concepts for widgets, render objects, gestures, overlays, controllers, and
state.

## Goals

- Provide a generic draggable and droppable engine before presets.
- Offer Flutter-style APIs such as `DndScope`, `DndDraggable`,
  `DndDroppable`, `DndDragOverlay`, `SortableScope`, and `SortableItem`.
- Keep user data ownership outside the library.
- Support mobile, web, and desktop as first-class targets.
- Keep the core package pure Dart and independently testable.
- Allow custom sensors, collision detectors, modifiers, measuring strategies,
  drag overlays, and sortable strategies.
- Stabilize core public API early enough to avoid avoidable breaking changes.

## Non-Goals For Stable V1

- Native OS-level file drag and drop.
- Cross-window or cross-app drag and drop.
- Full virtualized variable-height sortable lists.
- Complex nested sortable layouts.
- Highly opinionated animation systems.
- Dependency on Riverpod, Provider, BLoC, Redux, or another external state
  management library.

Native OS drag and drop can be explored later in a separate package named
`dnd_kit_native`.

## Target Users

- Flutter application developers building sortable, canvas, builder, board, or
  dashboard interfaces.
- Maintainers who need a reusable, testable, type-safe drag-and-drop foundation.
- Advanced developers who want the pure Dart collision, modifier, or sortable
  math without Flutter.

## Source

Derived from `SPEC.md` v0.1. After Phase 0, these product docs and story packets
are the living source of truth for implementation work.
