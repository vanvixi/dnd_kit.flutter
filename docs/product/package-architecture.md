# Package Architecture

## Monorepo Shape

```text
packages/
  dnd_kit_core/
  dnd_kit_flutter/
  dnd_kit_sortable/
  dnd_kit/
examples/
  basic_drag_drop/
docs/
```

## Package Boundaries

### `dnd_kit_core`

Pure Dart package with no Flutter dependency.

Owns:

- `DndId`
- `DndPoint`, `DndSize`, `DndRect`, `DndTransform`
- drag state and session models
- collision detector contracts and built-in algorithms
- modifier contracts and pure Dart modifiers
- sensor contracts
- registry contracts
- base sortable math

Must not import:

- `package:flutter/*`
- `dart:ui`
- `BuildContext`
- `RenderBox`
- `Offset`, `Rect`, or `Size` from Flutter
- animation or overlay APIs

### `dnd_kit_flutter`

Flutter adapter package depending on `dnd_kit_core` and Flutter.

Owns:

- `DndScope`
- `DndController`
- `DndDraggable`
- `DndDroppable`
- `DndDragHandle`
- `DndDragOverlay`
- pointer, mouse, touch, long-press, and keyboard sensors
- Flutter measuring and geometry adapters
- overlay rendering
- auto-scroll
- semantics and accessibility hooks

### `dnd_kit_sortable`

Sortable preset package depending on `dnd_kit_core` and `dnd_kit_flutter`.

Owns:

- `SortableScope`
- `SortableItem`
- `SortableContainer`
- `SortableStrategy`
- `SortableStrategies`
- `SortableMoveDetails`
- sortable keyboard coordinates

Stable V1 strategies are vertical list, horizontal list, and grid.
Multi-container, nested sortable, and virtualized adapters remain experimental.

### `dnd_kit`

Umbrella package exporting public APIs from:

- `dnd_kit_core`
- `dnd_kit_flutter`
- `dnd_kit_sortable`

## Dependency Policy

Core runtime dependencies stay minimal:

- `collection`
- `meta`

Core must not use:

- `vector_math`
- `provider`
- `riverpod`
- `bloc`
- `freezed`
- `equatable`

Flutter packages may depend on Flutter SDK packages, but should avoid locking
users into an app state management approach.

## SDK Policy

The package family targets:

```yaml
environment:
  sdk: ">=3.5.0 <4.0.0"
  flutter: ">=3.24.0"
```
