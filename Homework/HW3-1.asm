INCLUDE Irvine32.inc

CountMatches PROTO,
	array_1:PTR SDWORD,
	array_2:PTR SDWORD,
	maxLen:DWORD

main EQU start@0

.data
array1 SDWORD 2, 4, -3, -9, 7, 1, 8
array2 SDWORD 2, -3, 6, 0, 7, 8, 5
string1 BYTE "+", 0
string2 BYTE " matches", 0

.code
main PROC

	INVOKE CountMatches,
		OFFSET array1,
		OFFSET array2,
		LENGTHOF array1

	mov edx, OFFSET string1
	call WriteString
	call WriteDec		; print out value in eax
	mov edx, OFFSET string2
	call WriteString
	call Crlf
	call WaitMsg
	exit
main ENDP

CountMatches PROC,
	array_1:PTR SDWORD,
	array_2:PTR SDWORD,
	maxLen:DWORD

	xor eax, eax	; clear eax
	mov esi, array_1	; esi point to array1
	mov edi, array_2	; edi point to array2
	mov ecx, maxLen	; set the loop times
L1:
	mov ebx, [esi]	; ebx = [esi]
	mov edx, [edi]	; edx = [edi]
	cmp ebx, edx	; compare two number
	jne L2		; jump to L2 if not equal
	inc eax		; if equal inc eax
L2:
	add esi, TYPE SDWORD	; point to next number
	add edi, TYPE SDWORD	; point to next number
	loop L1			; loop until ecx = 0
	ret
CountMatches ENDP

END main