INCLUDE Irvine32.inc

Str_nextWord PROTO,
	pString:PTR BYTE,	; pointer to string
	delimiter:BYTE,	; delimiter to find

main EQU start@0

.data
testStr BYTE "ABC\DE\FGHIJK\LM", 0

.code
main PROC
	call Clrscr
	mov edx, OFFSET testStr 	; display string
	call WriteString
	call Crlf

; Loop through the string, replace each delimiter, and
; display the remaining string.

	mov esi, OFFSET testStr	; esi point to testStr
	mov ecx, LENGTHOF testStr	; set the total loop times

L1:	INVOKE Str_nextWord,
		esi, "\"	; look for delimiter
	jnz Exit_prog	; quit if not found
	mov esi, edi	; point to next substring
	mov edx, esi	; set the string which need to print
	call WriteString	; display remainder of string
	call Crlf
	jmp L1
Exit_prog:
	call WaitMsg
	exit
main ENDP

Str_nextWord PROC,
	pString:PTR BYTE,	; pointer to string
	delimiter:BYTE,	; delimiter to find

	mov al, delimiter
	mov edi, pString

	cld
	repne scasb
	ret
Str_nextWord ENDP

END main