ok so u want to know about sofaos 
so first things first the ai commands kind of work 
they arent realy outputting right things but arend doing nothing
so dont realy use them
second booting
stockSofaos.iso is fully working without the gguf attached to it
if you dont care about secr reading from tge usb and instead from random disk on ur pc you can get rufus and burn it onto a usb
but if you want secr to read from sofadisk burn sofaos onto a disk remove all discs from pc insert sofadisk andmd boot
also make sure to enable legacy boot
note rhe system isnt perfect so you will encounter some gp if used wrong
biw for qemu 

{
qemu-system-x86_64 -m 2G -M q35 -drive id=disk0,file=SofaOs.iso,format=raw,if=none -device ahci,id=ahci0 -device ide-hd,drive=disk0,bus=ahci0.0,bootindex=0 -display curses -d int,guest_errors -D crash.log
}

just this command
for full sofaos make sure you hsve the right model : SmolLM2-135M-Instruct-f16.gguf


((
roundup() { echo $(( ($1 + 511) / 512 * 512 )); }
nasm -f bin btldr1 -o btldr1.o
nasm -f bin btldr2 -o btldr2.o
nasm -f bin kernel -o kernel.o
nasm -f bin endingsrting -o e.o
cat btldr1.o btldr2.o kernel.o > prefix.bin
truncate -s $(roundup $(wc -c < prefix.bin)) prefix.bin
cat prefix.bin /storage/emulated/0/Download/SmolLM2-135M-Instruct-f16.gguf > stage2.bin
truncate -s $(roundup $(wc -c < stage2.bin)) stage2.bin
truncate -s $(roundup $(wc -c < e.o)) e.o
cat stage2.bin e.o > SofaOs.iso
))
