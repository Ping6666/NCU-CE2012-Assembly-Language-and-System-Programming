INCLUDE Irvine32.inc

.data
myID BYTE ""	;Student ID of leader
size_ID = LENGTHOF myID2	;size_ID is the length of myID
myID2 BYTE ""	;Student ID of member
size_ID2 = LENGTHOF myID2	;size_ID2 is the length of myID2

.code
Convert PROC USES eax 	;make sure eax will not be changed
L1:
	mov eax, [esi]	;move out one number
	add eax, 11h	;change it to letter
	mov [esi], eax	;move the letter back
	inc esi		;increase the address
	loop L1		;loop L1
	ret		;return
Convert ENDP

Convert2 PROC
	push eax		;push eax
L1:
	mov eax, [esi]	;move out one number
	add eax, 11h	;change it to letter
	mov [esi], eax	;move the letter back
	inc esi		;increase the address
	loop L1		;loop L1
	pop eax		;pop eax
	ret		;return
Convert2 ENDP

start@0 PROC
	mov eax, 9999h		;The value of eax cannot be changed
	mov ebx, 9999h		;The value of ebx cannot be changed
	mov edx, 9999h		;The value of edx cannot be changed
	mov esi, OFFSET myID	;esi = myID's address
	mov ecx, size_ID		;ecx = loop times
	call Convert		;call Convert
	mov esi, OFFSET myID2	;esi = myID2's address
	mov ecx, size_ID2		;ecx = loop times
	call Convert2		;call Convert2
	exit
start@0 ENDP
END start@0