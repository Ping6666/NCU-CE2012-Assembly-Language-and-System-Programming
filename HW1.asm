TITLE Homework01              (Student ID:)
INCLUDE Irvine32.inc

.data
MyID   	DWORD 	?
Digit0 	BYTE 	1
Digit1 	BYTE 	5
Digit2 	BYTE 	4
Digit3 	BYTE 	5

.code
main EQU start@0
main PROC
	movsx eax, Digit0	;eax = Digit0
	shl eax, 8		;shift left eax
	movsx ebx, Digit1	;ebx = Digit1
	add eax, ebx	;eax = eax+ebx
	shl eax, 8		;shift left eax
	movsx ebx, Digit2	;ebx = Digit2
	add eax, ebx	;eax = eax+ebx
	shl eax, 8		;shift left eax
	movsx ebx, Digit3	;ebx = Digit3
	add eax, ebx	;eax = eax+ebx
	mov MyID, eax	;MyID = eax
	exit
main ENDP
END main