# package-builders

## Why (generally)

In principle, when I'm responsible for outcomes, I want to encounter problems myself as early as possible, so as to:

1. Narrow them down with minimal time and brain, and
2. Consider mitigation options with maximal time and brain.

## Why (this repo specifically)

In practice, this repo helps me:

- As a pkgsrc developer, to make sure all my packages work on a wide variety of platforms.
- As a server administrator, to update every week to a fresh-built set of the latest packages I rely on (not only mine).

## What's here

- `pkgvm`: control virtual machines for a variety of platforms
- `pkgbuild`: portably handle various build-related tasks, including bringing up my preferred pkgsrc dev environment and rebuilding and updating my server's packages
- a few miscellaneous little scripts
