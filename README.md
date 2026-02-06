# MiASMa Engine

A SEGA Genesis/Mega Drive game engine written in assembly on Windows.

---

## Installation

3 programs must be [included in your system's PATH environment variable](https://stackoverflow.com/questions/4822400/register-an-exe-so-you-can-run-it-from-any-command-line-in-windows).

- [SN ASM68K Version 2.53](https://ia803204.us.archive.org/view_archive.php?archive=/19/items/sega-saturn-sdks/Sega%20Saturn%20SDKs.zip&file=SDKs%2FThirdParty%2FPsyQ%2FPsy-Q%20Saturn%2Fwin%2FASM68K.ZIP)
- [Psylink Version 2.74](https://ia803204.us.archive.org/view_archive.php?archive=/19/items/sega-saturn-sdks/Sega%20Saturn%20SDKs.zip&file=SDKs%2FThirdParty%2FPsyQ%2FPsy-Q%20Saturn%2Fwin%2FPSYLINK.ZIP)
- [MD ROM Fix](https://github.com/devon-artmeier/mdromfix/releases)
- [clownmdemu (Optional for debugging)](https://github.com/Clownacy/clownmdemu-frontend/releases)
- [Mega Everdrive X7 Devkit (Optional for hardware testing)](https://github.com/IsoKilo/devkit-mega-everdrive-x7-win/releases/tag/v1.0) 

## Building

MiASMa can be built simply with make by either running ``make`` or ``make all``.
You can quickly test your ROMs with clownmdemu by running ``make run``.
If you own a Mega EverDrive X7 and a mini-USB cable the ROM can also be flashed onto the cartridge temporarily by running ``make flash``.