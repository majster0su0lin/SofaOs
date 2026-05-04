.section .rodata
add: .asciz "add"
exitcmd: .asciz "/exit"
sub: .asciz "sub"
mul: .asciz "mul"
div: .asciz "div"
frmemch: .asciz "freemem"
nwln: .asciz "\n"
ech: .asciz "echo"
nfchstr: .asciz "sgrb"
calcomand: .asciz "calc"
nfdt: .asciz "       SofaOs 0.67\n       ===========\nSofaOs 0.67 Premium Build\nCPU: ARM64\nMemory (bytes): "
mmrysc: .asciz "memmory good"
mmryer: .asciz "memmory fucked"
memmorytest: .asciz "mmrytst"
credits: .asciz "credits"
creditsop: .asciz "kod: Majster Šú Lin\n"
usertxt: .asciz "\n\033[31m~\033[32muser\033[0m"
arrowchar: .asciz "> "
bootxt: .asciz "SofaOS 0.67 booting....\n"
prompt:    .asciz "-user>"
help:  .asciz "help"
haltop: .asciz "halting...\n"
ver:   .asciz "ver"
cls: .asciz "cls"
cmdhalt:  .asciz "halt"
verzion: .asciz "SofaOS 0.67 premium\n"
errtxt:    .asciz "Unknown command\n"
helptxt:   .asciz "Commands: help\n          ver\n          cls\n          halt\n          credits\n          mmrytst\n          sgrb\n          freemem\n          echo\n"
.section .data
.align 3
volnoprest: .quad 0
.section .bss
.align 4
hep:
    .space 0x100000
hepend:
bsss:
sb:
   .space 0x40000
st:
bsse:
inbuf: .space 1024
tranbuf: .space 64
.section .text
.balign 0x800
vektorovytabel:
    .balign 0x80
    b sync_handler
    .balign 0x80
    b irq_handler
    .balign 0x80
    b fiq_handler
    .balign 0x80
    b err_handler
    .balign 0x80
    b sync_handler
    .balign 0x80
    b irq_handler
    .balign 0x80
    b fiq_handler
    .balign 0x80
    b err_handler
    .balign 0x80
    b sync_handler
    .balign 0x80
    b irq_handler
    .balign 0x80
    b fiq_handler
    .balign 0x80
    b err_handler
    .balign 0x80
    b err_handler
    .balign 0x80
    b err_handler
    .balign 0x80
    b err_handler
    .balign 0x80
    b err_handler
sisicalovitabl:
    cmp x8, #0
    beq putc
    cmp x8, #1
    beq puts
    cmp x8, #2
    beq clear
    cmp x8, #3
    beq getc
    cmp x8, #4
    beq gets
    cmp x8, #5
    beq open
    cmp x8, #6
    beq close
    cmp x8, #7
    beq read
    cmp x8, #8
    beq write
    cmp x8, #9
    beq delete
    cmp x8, #10
    beq ls
    cmp x8, #11
    beq cd
    cmp x8, #12
    beq mkdir
    cmp x8, #13
    beq stat
    cmp x8, #14
    beq alloc
    cmp x8, #15
    beq free
    cmp x8, #16
    beq exec
    cmp x8, #17
    beq kill
    cmp x8, #18
    beq yield
    cmp x8, #19
    beq getpid
    cmp x8, #20
    beq wait
    cmp x8, #21
    beq time
    cmp x8, #22
    beq sleep
    cmp x8, #23
    beq putsrev
    b halt
strcmp:
   ldrb w3,[x0]
   ldrb w4,[x1]
   cmp  w3, w4
   bne ere
mivi:
   cbz w3, erex
   add x1, x1, #1
   add x0, x0, #1
   b strcmp
erex:
   mov x0, #0
   ret
ere:
   mov x0, #1
   ret
strfx:
   mov x3, #0
numloop:
   cmp x2, x3
   beq endnum
   ldrb w4,[x0]
   ldrb w5,[x1]
   cmp w4, w5
   bne badnum
   add x1, x1, #1
   add x0, x0, #1
   add x3, x3, #1
   b numloop
endnum:
   mov x0, #0
   ret
badnum:
   mov x0, #1
   ret
numex:
    mov x2, #0
    mov x3, #10
mexlp:
    ldrb w9, [x0]
    sub w9, w9, #48
    cmp w9, #9
    bhi zero
    mul x2, x2, x3
    add x2, x2, x9
    add x0, x0, #1
    b mexlp
zero:
    add x4, x0, #1
    mov x0, x2
    ret
strcpy:
   ldrb w3,[x1], #1
   strb w3,[x0], #1
   cbz w3, ree
   b strcpy
ree:
   ret
turboalloc:
   ldr x4,=volnoprest
   ldr x0,[x4]
   cbnz x0, skipr
   ldr x0,=hep
skipr:
   ldr x5,=hepend
   sub x2, x5, x0
   cmp x1, x2
   bgt nospc
   add x2, x0, x1
   str x2,[x4]
   ret
nospc:
   mov x0, #0
   ret
bintrn:
   ldr x6,=tranbuf
   mov x1, #10
   mov x4, x0
   mov x5, #0
calcloop:
   add x5, x5, #1
   udiv x4, x4, x1
   cbnz x4, calcloop
   add x6, x6, x5
   strb w4,[x6]
trnlp:
   sub x6, x6, #1
   udiv x2, x0, x1
   msub x3, x2, x1, x0
   add x3, x3, #48
   strb w3,[x6]
   mov x0, x2
   cbnz x0, trnlp
   ret
.global _start
_start:
   msr daifset, #0xf
   ldr x0,=st
   mov sp, x0
   ldr x0,=bsss
   ldr x1,=bsse
bsnull:
   cmp x0, x1
   beq bsnullfin
   str xzr,[x0], #8
   b bsnull
bsnullfin:
   ldr x0, =vektorovytabel
   msr vbar_el1, x0
   msr daifclr, #0xf
   ldr x0,=hep
   ldr x3,=volnoprest
   str x0,[x3]
   b mainos
halt:
   wfe
   b halt
sync_handler:
   mrs x9, esr_el1
   lsr x9, x9, #26
   cmp x9, #0x15
   beq sisicalovitabl
   b halt
irq_handler:    eret
fiq_handler:    eret
err_handler:
   b halt
puts:
   ldr x9,=0x09000000
pss:
   ldrb w10,[x1]
   cmp w10, #0
   beq ert
    strb w10,[x9]
   add x1, x1, #1
   b pss
ert:
   eret
putc:
    ldr x9, =0x09000000
    strb w0, [x9]
    eret
clear:  eret
getc:
    ldr x9,=0x09000000
cakacka:
    ldrb w10, [x9, #0x18]
    tst w10, #0x10
    bne cakacka
    ldrb w0, [x9]
    eret
gets:
    ldr x9,=0x09000000
    ldr x0,=inbuf
    mov x13, x0
ckcka:
    ldrb w10, [x9, #0x18]
    tst w10, #0x10
    bne ckcka
    ldrb w10, [x9]
    cmp w10, #13
    beq entr
    cmp w10, #127
    beq del
    strb w10,[x9]
    strb w10,[x0]
    add x0, x0, #1
    b ckcka
entr:
    mov w10, #0
    strb w10, [x0]
    mov w10, #13
    strb w10, [x9]
    mov w10, #10
    strb w10, [x9]
    eret
del:
    cmp x13, x0
    beq ckcka
    mov w10, #8
    strb w10,[x9]
    mov w10, #32
    strb w10,[x9]
    mov w10, #8
    strb w10,[x9]
    sub x0, x0, #1
    b ckcka
open:   eret
close:  eret
read:   eret
write:  eret
delete: eret
ls:     eret
cd:     eret
mkdir:  eret
stat:   eret
alloc:  eret
free:   eret
exec:   eret
kill:   eret
yield:  eret
getpid: eret
wait:   eret
time:   eret
sleep:  eret
putsrev:
   ldr x9,=0x09000000
pssrev:
   ldrb w10,[x1]
   cmp w10, #0
   beq ertrev
   strb w10,[x9]
   sub x1, x1, #1
   b pssrev
ertrev:
   eret
mainos:
   ldr x1,=bootxt
   mov x8, #1
   svc 0
halter:
   mov x8, #1
   ldr x1,=usertxt
   svc 0
   ldr x1,=arrowchar
   svc 0
   mov x8, #4
   svc 0
   ldr x0,=inbuf
   ldr x1,=calcomand
   bl strcmp
   cbz x0, calculator
   ldr x0,=inbuf
   ldr x1,=help
   bl strcmp
   cbz x0, spravhlp
   ldr x0,=inbuf
   ldr x1,=ver
   bl strcmp
   cbz x0, spraver
   ldr x0,=inbuf
   ldr x1,=cls
   bl strcmp
   cbz x0, spravcls
   ldr x0,=inbuf
   ldr x1,=cmdhalt
   bl strcmp
   cbz x0, spravhalt
   ldr x0,=inbuf
   ldr x1,=credits
   bl strcmp
   cbz x0, spravcredits
   ldr x0,=inbuf
   ldr x1,=memmorytest
   bl strcmp
   cbz x0, spravmmrytst
   ldr x0,=inbuf
   ldr x1,=nfchstr
   bl strcmp
   cbz x0, spravneo
   ldr x1,=ech
   mov x2, #4
   ldr x0,=inbuf
   bl strfx
   cbz x0, spravecho
   ldr x0,=inbuf
   ldr x1,=frmemch
   bl strcmp
   cbz x0, usmem
   ldr x1,=errtxt
   mov x8, #1
   svc 0
   b halter
secerror:
   ldr x1,=errtxt
   mov x8, #1
   svc 0
   b halter
spravhlp:
   ldr x1,=helptxt
   mov x8, #1
   svc 0
   b halter
spraver:
   ldr x1,=verzion
   mov x8, #1
   svc 0
   b halter
spravcls:
    mov x8, #2
    svc 0
    b halter
spravhalt:
   ldr x1,=haltop
   mov x8, #1
   svc 0
   b halt
spravcredits:
   ldr x1,=creditsop
   mov x8, #1
   svc 0
   ldr x0,=123456
   bl bintrn
   mov x1, x6
   mov x8, #1
   svc 0
   b halter
spravmmrytst:
    mov x1, #64
    bl turboalloc
    cbnz x0, suc
    ldr x1, =mmryer
    mov x8, #1
    svc 0
    b halter
suc:
    ldr x1, =mmrysc
    mov x8, #1
    svc 0
    b halter
spravneo:
    ldr x1,=nfdt
    mov x8, #1
    svc 0
    ldr x0,=hepend
    ldr x1,=hep
    sub x0, x0, x1
    bl bintrn
    mov x1, x6
    mov x8, #1
    svc 0
    ldr x1,=nwln
    mov x8, #1
    svc 0
    b halter
usmem:
    ldr x1,=volnoprest
    ldr x0,=hepend
    ldr x1,[x1]
    sub x0, x0, x1
    bl bintrn
    mov x1, x6
    mov x8, #1
    svc 0
    ldr x1,=nwln
    mov x8, #1
    svc 0
    b halter
spravecho:
    ldr x1,=inbuf
    add x1, x1, #5
    mov x8, #1
    svc 0
    b halter
calculator:
    ldr x1,=nwln
    mov x8, #4
    svc 0
    ldr x0,=inbuf
    ldrb w2,[x0]
    cmp w2, '/'
    beq secomands
    mov x2, #3
    ldr x1,=add
    bl strfx
    cbz x0, spravadd
    ldr x0,=inbuf
    ldr x1,=sub
    bl strfx
    cbz x0, spravsub
    ldr x0,=inbuf
    ldr x1,=mul
    bl strfx
    cbz x0, spravmul
    ldr x0,=inbuf
    ldr x1,=div
    bl strfx
    cbz x0, spravdiv
secomands:
    ldr x0,=inbuf
    ldr x1,=exitcmd
    bl strcmp
    beq halter
    b calculator //----------------------------------------------------
spravadd:
    add x0, x0, #4
    bl numex
    mov x10, x0
    mov x0, x4
    bl numex
    mov x13, x0
    add x0, x10, x13
    bl bintrn
    ldr x1,=tranbuf
    mov x8, #1
    svc 0
    ldr x1,=nwln
    mov x8, #1
    svc 0
    b calculator
spravsub:
spravmul:
spravdiv:
aimode:
    b halter //---------------------------------------------------

