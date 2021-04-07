INCLUDE Irvine32.inc

main EQU start@0

.data
ninenine BYTE 81 DUP(?)	; declare variable ''ninenine'' for saving the ninenine value

.code
main PROC
	mov ecx, 9h		; ecx = 9 (loop times in A)
	mov esi, OFFSET ninenine	; esi = address of ninenine
A:
	mov ebx, 0ah		; ebx = 10
	sub ebx, ecx		; ebx = 10 - ecx = multiplier
	push ecx			; store the ecx into stack
	mov ecx, 9h		; ecx = 9 (loop times in B)
	B:
		mov eax, 0ah	; eax = 10
		sub eax, ecx	; eax = 10 - ecx = multiplicand
		mul bl		; do the multiplication
		mov [esi], eax	; [esi] = eax = multiplication result
		inc esi		; esi = esi + 1
		loop B		; loop B
	pop ecx			; take out ecx from stack
	loop A			; loop A
	exit
main ENDP
END main