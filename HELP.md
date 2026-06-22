# bootDOS Help - 0.4.1

Commands can be up to 48 characters long.

## Commands
- cls / clear: Clear Screen
- col: Set Colour (MUST BE 3 LETTERS!)
- help: Help
- prt / print: Print
- ver: Version
- shutdown: Shutdown / Halt
- reboot: Soft Reboot the machine

## Usage

- **cls**: Clear the screen of all text. No arguments.
- **col**: Change the clour of the screen. Argument 1: Hexadecimal character (0-9, A-F) corrosponding to colour:
  - 0: Black (unreadable)
  - 1: Dark Blue
  - 2: Dark Green
  - 3: Dark Cyan
  - 4: Dark Red
  - 5: Dark Magenta
  - 6: Dark Yellow / Orange
  - 7: Grey (default)
  - 8: Dark Grey
  - 9: Blue
  - A: Green
  - B: Cyan
  - C: Red
  - D: Magenta
  - E: Yellow
  - F: White
- help: Display a link to the help text (this page!). No arguments.
- prt/print: Print a string. Argument 1: Text to print.
- ver: Display version information. No arguments.
- shutdown: Halt the computer. No arguments.
- reboot: Reboots the computer via `int 0x19`. No arguments.
