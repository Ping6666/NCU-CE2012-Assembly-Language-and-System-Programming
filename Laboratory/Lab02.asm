TITLE Homework02              (HW02.ASM)
INCLUDE Irvine32.inc

.data
Val1	SBYTE	03h
Val2	SBYTE	02h
Val3	SBYTE	8fh
Rval	SDWORD	?

.code
main EQU start@0
main PROC
	movsx eax, Val1	;eax = Val1
	movsx ebx, Val2	;ebx = Val2
	movsx ecx, Val3	;ecx = Val3

	add eax, ebx	;eax = Val1 + Val2
	mov ebx, eax	;ebx = Val1 + Val2
	shl eax, 3		;eax = 8*eax
	shl ebx, 1		;eax = 2*eax
	add eax, ebx	;eax = eax + ebx = 10*(Val1 + Val2)
	shl ebx, 1		;eax = 2*eax
	add eax, ebx	;eax = eax + ebx = 14*(Val1 + Val2)
	sub ecx, eax	;ecx = ecx - eax = Val3 – 14 * (Val1 + Val2)
	neg ecx		;ecx = -ecx = - (Val3 – 14 * (Val1 + Val2))
	mov Rval, ecx	;Rval = ecx
	exit
main ENDP
END main