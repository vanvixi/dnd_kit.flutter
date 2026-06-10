# 0009 MIT Package License

Date: 2026-06-10

## Status

Accepted

## Context

The publishable `dnd_kit_core` and `dnd_kit` packages need a license file in
each package root before `dart pub publish --dry-run` can pass pub validation.
The project owner selected MIT for the package license.

## Decision

License the repository and publishable packages under the MIT License.

Add `LICENSE` files to:

- `LICENSE`
- `packages/dnd_kit_core/LICENSE`
- `packages/dnd_kit/LICENSE`

Use `vanvixi` as the copyright holder based on the repository owner at
`github.com/vanvixi/dnd_kit.flutter`.

## Alternatives Considered

1. Apache-2.0. This is common for Dart and Flutter packages, but the project
   owner selected MIT.
2. BSD-style license. Also compatible with open-source package distribution,
   but not selected.
3. Leave license unresolved. This keeps legal ambiguity and blocks pub
   validation.

## Consequences

Positive:

- Pub validation can include the required package license files.
- Repository hosting can detect and display the project license.
- Users get clear permission to use, copy, modify, distribute, and sublicense
  the packages under MIT terms.
- Both publishable packages use the same license.

Tradeoffs:

- MIT provides broad permission with limited warranty/liability language and no
  patent grant.

## Follow-Up

- Re-run publish dry-runs for `dnd_kit_core` and `dnd_kit`.
