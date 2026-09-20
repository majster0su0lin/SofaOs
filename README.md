# SofaOS

A custom operating system with experimental on-device AI command support.

WORK IN PROGRESS. THE SYSTEM ISN'T PERFECT — YOU WILL ENCOUNTER BUGS (GPFS, ETC.) IF USED INCORRECTLY. AI COMMANDS ARE PARTIALLY FUNCTIONAL: SOME PRODUCE OUTPUT, BUT IT'S NOT RELIABLY CORRECT YET, SO DON'T RELY ON THEM FOR ANYTHING IMPORTANT.

Requirements:
if full:
SofaOs.iso (full build, includes AI support, needs to be built)
SmolLM2-135M-Instruct-f16.gguf — required model for AI commands
QEMU (for emulated testing) or a spare USB/disk + Rufus (for real hardware)
Booting
if base:
stocSofaOs.iso (prebuilt)
QEMU (for emulated testing) or a spare USB/disk + Rufus (for real hardware)
Booting

There are two ways to boot SofaOS, depending on whether you need the AI features to read from a specific disk.

Option A — Quick boot (no dedicated disk)

stockSofaOs.iso boots fully on its own, without the GGUF model attached. This is fine if you don't care about the AI commands reading from a specific disk.

Burn stockSofaOs.iso to a USB using Rufus.
Boot from the USB. It will read from whatever disk happens to be available on the PC.
Option B — Dedicated sofadisk boot (for AI/secr reading)

If you want the AI commands to read specifically from a dedicated disk:

Burn SofaOs.iso onto a disk (this becomes your sofadisk).
Remove all other disks from the PC.
Insert the sofadisk.
Enable Legacy Boot in your BIOS/UEFI settings.
Boot.


Running in QEMU

To run the full version of SofaOS (with AI support) in QEMU, make sure SmolLM2-135M-Instruct-f16.gguf is present, then run:


qemu-system-x86_64 \
  -m 2G \
  -M q35 \
  -drive id=disk0,file=SofaOs.iso,format=raw,if=none \
  -device ahci,id=ahci0 \
  -device ide-hd,drive=disk0,bus=ahci0.0,bootindex=0 \
  -display curses \
  -d int,guest_errors \
  -D crash.log


Building from Source

The build assembles the ISO from several NASM-compiled components plus the GGUF model, padding each stage to a 512-byte sector boundary before concatenating the next piece.


## Round a byte count up to the next 512-byte boundary
roundup() { echo $(( ($1 + 511) / 512 * 512 )); }

## 1. Assemble bootloader + kernel components
nasm -f bin btldr1        -o btldr1.o
nasm -f bin btldr2        -o btldr2.o
nasm -f bin kernel        -o kernel.o
nasm -f bin endingsrting  -o e.o

## 2. Combine bootloader + kernel, pad to sector size
cat btldr1.o btldr2.o kernel.o > prefix.bin
truncate -s "$(roundup "$(wc -c < prefix.bin)")" prefix.bin

## 3. Append the GGUF model, pad again
cat prefix.bin "$MODEL" > stage2.bin
truncate -s "$(roundup "$(wc -c < stage2.bin)")" stage2.bin

## 4. Pad the ending/trailer section
truncate -s "$(roundup "$(wc -c < e.o)")" e.o

## 5. Final image
cat stage2.bin e.o > SofaOs.iso

Output: SofaOs.iso — the full, AI-capable build.

***after you succesfully booted you can type*** <ins>help</ins> ***to see avalible commands***



Known Issues
AI commands produce output but are not reliable — treat results as experimental, not correct.
Improper use (wrong boot mode, missing disks, etc.) can trigger general protection faults (GPFs).
