INCLUDE Irvine32.inc

main EQU start@0

.data
myID BYTE ""	; group leader's student ID
myID2 BYTE ""	; group member's student ID
size_ID = LENGTHOF myID	; length of myID
result BYTE 9 DUP(?)	; declare variable ''result'' for saving your cmp result

.code
main PROC
	mov esi, OFFSET myID	; esi = address of myID
	mov edi, OFFSET myID2	; edi = address of myID2
	mov esp, OFFSET result	; esp = address of result
	mov ecx, size_ID		; ecx = length of myID
	mov edx, 0h		; edx = 0
L1:
	mov al, [esi]	; al = number in myID
	mov bl, [edi]	; bl = number in myID2
	cmp al, bl		; compare al and bl
	ja L2		; if al > bl jump to L2
	jb L3		; if al < bl jump to L3
	mov edx, 41h	; if al == bl, edx = "A"
	jmp L4
L2:
	mov edx, 42h	; if al > bl, edx = "B"
	jmp L4
L3:
	mov edx, 43h	; if al < bl, edx = "C"
L4:
	mov [esp], edx	; [esp] = edx
	inc esi		; esi = esi + 1
	inc edi		; edi = edi + 1
	inc esp		; esp = esp + 1
	loop L1		; loop L1 until ecx == 0
	exit
main ENDP
END main