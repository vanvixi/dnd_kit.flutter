# Architecture

This repository now targets `dnd_kit`, a Flutter drag-and-drop toolkit with a
pure Dart core, Flutter adapter, sortable presets, and an umbrella package.

The detailed living product contract is split across:

- `docs/product/overview.md`
- `docs/product/package-architecture.md`
- `docs/product/api-principles.md`
- `docs/product/release-roadmap.md`

The seed specification remains in `SPEC.md` as historical input material.

## Product Surfaces

- Pure Dart package APIs for geometry, state, collision, modifier, sensor, and
  sortable math.
- Flutter widget APIs for drag scopes, controllers, draggables, droppables,
  handles, overlays, measuring, sensors, auto-scroll, and accessibility.
- Sortable preset APIs for vertical lists, horizontal lists, and grids.
- Example Flutter apps used as adoption guides and integration proof.

## Package Layers

```text
dnd_kit_core
  <- dnd_kit_flutter
      <- dnd_kit_sortable
          <- dnd_kit umbrella exports
```

`dnd_kit_sortable` also depends directly on `dnd_kit_core` for sortable math
and IDs.

## Dependency Rule

Inner packages must not depend on outer packages.

| Package | May depend on | Must not depend on |
| --- | --- | --- |
| `dnd_kit_core` | `collection`, `meta`, Dart SDK | Flutter, `dart:ui`, widget/render/gesture APIs, state management packages |
| `dnd_kit_flutter` | Flutter SDK, `dnd_kit_core`, small annotations/utilities | sortable presets, umbrella package, external state management |
| `dnd_kit_sortable` | `dnd_kit_core`, `dnd_kit_flutter`, Flutter SDK | umbrella package, app-specific state management |
| `dnd_kit` | public sub-packages | implementation internals |

## Boundary Rules

Core geometry must use `DndPoint`, `DndSize`, `DndRect`, and `DndTransform`
rather than Flutter geometry types.

Flutter geometry conversion belongs at adapter boundaries. Unknown Flutter
layout data should be measured and normalized before entering collision or
modifier logic.

User data remains outside the library. Drag/drop and sortable APIs report
intent; applications own mutation.

## Validation Ladder

- Core stories use `dart test` and `dart analyze`.
- Flutter adapter stories use `flutter test` for widget and gesture behavior.
- Example and showcase stories add integration or platform build checks when
  they introduce user-visible flows.
- Release hardening adds `melos run test`, `melos run analyze`, and example
  build checks.

## Decisions

- `docs/decisions/0007-dnd-kit-package-architecture.md`
