# Malatro

A pixel-perfect inspired Balatro clone built with [LÖVE 11](https://love2d.org/). The project mirrors the core loop of playing five-card poker hands, collecting chips and multipliers, and clearing blinds while keeping crisp nearest-neighbor scaling.

## Features
- Pixel-perfect rendering using a fixed 640x360 virtual canvas scaled to the window.
- Standard 52-card deck with shuffling and reshuffling from the discard pile.
- Poker hand detection (pair, two pair, three of a kind, straight, flush, full house, four of a kind, straight flush).
- Balatro-style scoring: each hand grants chips and a multiplier; meet blind targets to advance antes.
- Play/discard limits per blind and quick keyboard controls.


## Controls
- **Left Click**: select/unselect cards.
- **Space**: play the selected five-card hand.
- **D**: discard selected cards (up to the discard limit).
- **N**: skip to the next blind.
- **R**: restart from ante 1.

## Running
Install [LÖVE](https://love2d.org/) and run from the project root:

```bash
love .
```

The game will open a resizable window while preserving a nearest-neighbor scale for crisp pixels.
