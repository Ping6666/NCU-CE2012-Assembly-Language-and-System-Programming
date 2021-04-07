TITLE Homework02              (Student ID:)
INCLUDE Irvine32.inc

.data
ChStrs BYTE "        "
	BYTE "  ****  "
	BYTE "  *     "
	BYTE "  *     "
	BYTE "  ****  "
	BYTE "     *  "
	BYTE "     *  "
	BYTE "  ****  "
BitStrs BYTE 8 dup(?)

.code
change PROC USES ecx	; store ecx in stack
	mov ecx, 8h	; ecx = 8 (times to loop)
	mov edx, 0h	; edx = 0
L2:
	shl edx, 1		; edx = edx * 2
	mov bl, [esi]	; bl = [esi]
	cmp bl, 2Ah	; compare bl and "*"
	je L3		; jump to L3 if equal
	add edx, 0h	; edx = edx + 0
	jmp L4		; jump to L4
L3:
	add edx, 1h	; edx = edx + 1
L4:
	inc esi		; esi = esi + 1
	loop L2		; loop L2 until ecx = 0
	mov [edi], edx	; [edi] = edx
	ret		; return
change ENDP

start@0 PROC
	mov esi, OFFSET ChStrs	; esi = address of ChStrs
	mov edi, OFFSET BitStrs	; edi = address of BitStrs
	mov ecx, 8h		; ecx = 8 (times to loop)
L1:
	call change		; call change
	mov al, [edi]		; al = [edi]
	mov ebx, TYPE BYTE		; make sure print type byte
	call WriteBinB		; print
	call Crlf			; change line
	inc edi			; edi = edi + 1
	loop L1			; loop L1 until ecx = 0
	call  WaitMsg		; make the cmd wait
	exit
start@0 ENDP
END start@0