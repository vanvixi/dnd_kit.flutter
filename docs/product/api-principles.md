# API Principles

## Flutter-Style Naming

Use Flutter-native names:

- `DndScope`
- `DndController`
- `DndDraggable`
- `DndDroppable`
- `DndDragHandle`
- `DndDragOverlay`
- `SortableScope`
- `SortableItem`

Avoid React-specific API shapes such as `DndContext`, `useDraggable`,
`useDroppable`, or hook-style naming.

## Controlled And Uncontrolled Scope

`DndScope` must support both lifecycle modes.

Uncontrolled:

```dart
DndScope(
  child: App(),
)
```

Controlled:

```dart
final controller = DndController();

DndScope(
  controller: controller,
  child: App(),
)
```

Rules:

- If the user provides a controller, the user owns its lifecycle.
- If no controller is provided, `DndScope` creates and disposes an internal
  controller.
- `DndScope` must never dispose an external controller.

## Users Own Data

The library reports drag/drop intent. It must not mutate user collections,
tasks, boards, or app state.

Sortable callbacks provide enough information for the user to mutate their own
data with `setState`, Riverpod, BLoC, Provider, Redux, or any other approach.

## Stable IDs

`DndId` values must be stable during the widget lifecycle.

Prefer:

```dart
DndId(task.id)
DndId('column-todo')
DndId(user.id)
```

Avoid:

```dart
DndId(UniqueKey())
DndId(DateTime.now())
DndId(Object())
```

Duplicate IDs inside a registry should be caught by debug diagnostics.

## Performance Principles

- Do not rebuild the whole app on every pointer move.
- Update overlays independently from source layout.
- Cache measuring data during drag where possible.
- Run collision detection at most once per frame.
- Keep core algorithms testable without Flutter.
