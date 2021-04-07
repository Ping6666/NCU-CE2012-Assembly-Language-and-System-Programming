INCLUDE Irvine32.inc

.data
ninenine BYTE 9 DUP(?)

.code
main EQU start@0
main PROC
	mov ecx, LENGTHOF ninenine	;the times to loop
	mov esi, OFFSET ninenine	;move the ninenine ptr into esi
	mov al, 0h		;the multiplication result

L:
	add al, 9h			;al = al + 9
	mov [esi], al		;[esi] = al
	inc esi			;esi = esi + 1
	loop L			;loop L
	exit
main ENDP
END main