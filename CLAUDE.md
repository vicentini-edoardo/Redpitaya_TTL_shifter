# CLAUDE.md — AI Assistant Guide for Redpitaya_TTL_shifter

## Project Overview

This repository contains a desktop GUI for controlling a custom Red Pitaya FPGA
frequency divider / pulse generator over SSH.

Current active components:

1. `redpitaya_pulse_gui_c_helper.py` — Python/tkinter desktop GUI that runs on
   the host PC.
2. `rp_pulse_ctl.c` — small C helper uploaded to the Red Pitaya and compiled on
   the board; it reads and writes FPGA registers through `/dev/mem`.

The legacy PLL implementation and its older GUIs have been removed from this
repository and should not be reintroduced unless the user explicitly asks for
them.

## Repository Structure

```text
Redpitaya_TTL_shifter/
├── CLAUDE.md
├── GUI.png
├── LICENSE
├── README.md
├── redpitaya_pulse_gui_c_helper.py
└── rp_pulse_ctl.c
```

## Runtime Model

- The GUI runs locally on the user's computer.
- Communication with the Red Pitaya uses `ssh` and `scp`.
- The FPGA bitfile is expected as `red_pitaya_top.bit.bin` next to the GUI
  script, but it is intentionally ignored by git.
- The helper binary is compiled remotely on the board with `gcc`.

## Main Files

### `redpitaya_pulse_gui_c_helper.py`

Key responsibilities:

- Build the tkinter GUI
- Show live frequency / duty / phase stats
- Draw the waveform preview
- Upload the FPGA bitfile
- Upload and compile `rp_pulse_ctl.c`
- Read and write hardware registers over SSH

Important sections:

- `RemoteCtl` handles SSH/SCP transport.
- `App._build_*` creates the GUI panels.
- `App._draw_waveform()` renders the preview.
- `App._update_readback()` converts hardware values into UI state.

### `rp_pulse_ctl.c`

Board-side helper used by the GUI for:

- register readback
- register writes
- soft reset

This file is intended to compile on the Red Pitaya, not on the local machine.

## Development Guidance

### Python GUI

- Keep dependencies in the Python standard library only.
- Preserve cross-platform tkinter compatibility.
- All GUI updates must happen on the tkinter main thread.
- Prefer small, localized edits; this is a single-file GUI.
- When changing the preview, keep width and delay referenced to the input
  period unless the user requests otherwise.

### Red Pitaya Integration

- Do not hardcode interactive SSH flows.
- Keep remote commands non-interactive and use full binary paths.
- Do not assume the bitfile exists in git; the README already documents that it
  comes from Releases.

## What Not To Do

- Do not re-add PLL-era files (`rp_pll.c`, old `gui/` scripts, old `deploy.sh`)
  unless explicitly requested.
- Do not add external Python packages for the GUI.
- Do not change width/delay semantics away from input-period references unless
  the user asks for that behavior.
- Do not commit generated files such as `__pycache__/`, `.DS_Store`, or logs.

## Common Tasks

| Task | File |
|------|------|
| Adjust GUI layout or styling | `redpitaya_pulse_gui_c_helper.py` |
| Change waveform preview behavior | `redpitaya_pulse_gui_c_helper.py` |
| Change SSH / upload logic | `redpitaya_pulse_gui_c_helper.py` |
| Change low-level register helper behavior | `rp_pulse_ctl.c` |
| Update user documentation | `README.md` |
