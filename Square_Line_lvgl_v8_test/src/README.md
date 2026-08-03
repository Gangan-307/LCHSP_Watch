# Source Layout

- `app/`: application startup and top-level initialization.
- `drivers/`: hardware-facing modules for ADC, display power, RGB, and vibration.
- `services/`: device behavior such as time, battery presentation, wake control, and time synchronization.
- `bluetooth/`: PAN connectivity and Bluetooth music control.
- `ui/generated/`: SquareLine-generated UI sources. Regenerate these files only through SquareLine Studio.
- `ui/music/`: hand-written music screen and its presentation behavior.

The SCons build script owns the source and include directory lists. Add new modules to `src/SConscript` when creating a new top-level source directory.
