# HomePC setup (Linux part)

## System: Debian Trixie

- Installed Debian Bookworm via usb, restart.
  - Black screen with a blinking cursor due to no graphic card is working.
  - The screen is directly connected to the nvidia graphic card, so the intel integrated gpu will not be used.
- Open tty, install nvidia graphic driver: https://wiki.debian.org/NvidiaGraphicsDrivers
  (Remember: `linux-header-amd64` has to be installed first!)
- After that, the nvidia graphic card worked. Logged in gnome.
