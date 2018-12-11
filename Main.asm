; Main.asm
; Name: Kelly Wang & Gwyneth Douglas
; UTEid: kaw4256
; Continuously reads from x4600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
               .ORIG x4000

LD R6, stack 	;initialize the stack pointer, x4000 -> R6 

LD R3, ISR 	;set up the keyboard interrupt vector table entry
STI R3, IVT     ;M[X0180] <- x2600 ==== place interrupt service routine addr into IVT

STI R6, kbesr ;stores 14th enable bit into kbsr
;*****start************************************************************************************
getll   JSR GET_LETTER
checkA  LD R4, A
	ADD R4, R0, R4
	BRnp getll

	JSR GET_LETTER

	LD R4, U
	ADD R4, R0, R4 
	BRnp checkA


	JSR GET_LETTER
	LD R4, G
	ADD R4, R0, R4 
	BRnp checkA
	BRz pip
pip	LD R0, pipe
	TRAP x21

;*****************************************************************************************

endcodon
	JSR GET_LETTER

TRYAGAIN
	LD R4, U		
	ADD R3, R0, R4
	BRnp endcodon
	BRz checkUA
checkUA
	JSR GET_LETTER
	LD R4, A		
	ADD R3, R0, R4 
	BRnp checkUG
	BRz checkUAG
checkUAG
	JSR GET_LETTER
	LD R4, G
	ADD R3,R0, R4
	BRnp checkUAA
	BRz done
checkUG	
	LD R4, G
	ADD R3, R0, R4 
	BRnp TRYAGAIN
	BRz checkUGA
checkUGA
	JSR GET_LETTER
	LD R4, A
	ADD R3, R0, R4
	BRnp checkUAA
	BRz done
checkUAA
	LD R4, A
	ADD R3, R0, R4
	BRnp TRYAGAIN
	BRz done
	


done
TRAP x25

pipe .FILL x7C
A .FILL -65
U .FILL -85
G .FILL -71
C .FILL -67
IVT .FILL x0180
ISR .FILL x2600
stack .FILL X4000
kbesr .FILL xFE00
JR7 .BLKW 1
;*************************************************************************
GET_LETTER
ST R7, JR7
LDI R0, flag ;loads number stored to x4600
BRz -2

write LDI R1, DSR
BRzp write
STI R0, DDR

AND R4, R4, #0
STI R4, flag

LD R7, JR7
RET
flag .FILL x4600
kbsr .FILL xFE00
DSR .FILL xFE04
DDR .FILL xFE06
;*************************************************************************







		.END