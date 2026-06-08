# US-007 Core Modifier Contracts

## Status

implemented

## Lane

normal

## Product Contract

`dnd_kit_core` must expose pure Dart modifier contracts and built-in transform
modifiers that later controllers, overlays, sensors, sortable presets, and
Flutter adapters can share without depending on Flutter geometry types.

## Relevant Product Docs

- `docs/product/overview.md`
- `docs/product/package-architecture.md`
- `docs/product/api-principles.md`
- `docs/product/release-roadmap.md`

## Acceptance Criteria

- `dnd_kit_core` exports a `DndModifier` typedef.
- Modifier input exposes the current transform, active rectangle, optional
  boundary rectangle, optional droppable rectangles, and optional pointer
  coordinates without Flutter geometry types.
- Built-in modifiers exist for horizontal-axis restriction, vertical-axis
  restriction, boundary restriction, snap-to-grid, and modifier composition.
- Modifier input and reusable modifier value objects compare by value.
- `compose` applies modifiers in order, passing each modifier's transform to
  the next modifier.
- Unit tests cover transform changes, boundary clamping, composition order, and
  public value behavior.

## Design Notes

- Commands: `fvm dart format .`, `fvm dart analyze`,
  `fvm dart test packages/dnd_kit_core`, and
  `scripts/bin/harness-cli story verify US-007`.
- Queries: `scripts/bin/harness-cli query matrix`.
- API: pure Dart modifier contracts and built-in transform modifiers only; no
  controller, sensor runtime, registry, Flutter widget, or overlay behavior in
  this story.
- Tables: none.
- Domain rules: applications still own user data and collection mutation.
- UI surfaces: none.

## Validation

When updating durable proof status, use numeric booleans:
`scripts/bin/harness-cli story update --id US-007 --unit 1 --integration 0 --e2e 0 --platform 0`.

| Layer | Expected proof |
| --- | --- |
| Unit | `fvm dart test packages/dnd_kit_core` passes. |
| Integration | Not required; this story introduces only one package's pure Dart modifier model. |
| E2E | Not required; no user-facing UI exists. |
| Platform | Not required; no Flutter/platform code exists. |
| Release | `fvm dart analyze` passes from the repository root. |

## Harness Delta

- Adds the fifth Phase 1 story packet and durable matrix row.

## Evidence

- `fvm dart format .` completed with no changes needed after implementation.
- `fvm dart analyze` passed with no issues.
- `fvm dart test packages/dnd_kit_core` passed with 53 tests.
- `scripts/bin/harness-cli story verify US-007` passed with
  `fvm dart test packages/dnd_kit_core`.
