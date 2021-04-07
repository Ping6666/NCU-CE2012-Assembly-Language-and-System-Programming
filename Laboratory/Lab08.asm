INCLUDE Irvine32.inc

main EQU start@0

.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
FindLargest PROTO ptrArray:PTR SDWORD, szArray:DWORD
; call FindLargest procedure's prototype

.data
Ex1Array SDWORD 105522063, , 
;陣列初始為105522063, 組員學號1 ,組員學號2

Ex2Array SDWORD -105522063, -, -
;陣列初始為-105522063, 組員學號1加負號 ,組員學號2加負號

.code
main PROC
	INVOKE FindLargest, OFFSET Ex1Array, LENGTHOF Ex1Array
	INVOKE FindLargest, OFFSET Ex2Array, LENGTHOF Ex2Array
	; call FindLargest procedure
	call WaitMsg
	INVOKE ExitProcess, 0
main ENDP

FindLargest PROC,
	ptrArray:PTR SDWORD, szArray:DWORD
	push esi
	push ecx
	mov eax, 80000000h	; smallest possible 32bit signed integer
	mov esi, ptrArray		; point to the first element
	mov ecx, szArray		; set iteration times
L1:	cmp eax, [esi]	; compare the current value and current maximum
	jg L2		; if smaller than max, jump to L2
	mov eax, [esi]	; update max value
L2:	add esi, 4		; make esi point to next SDWORD number
	loop L1		; loop L1
	call WriteInt	; print out the number
	call Crlf
	pop ecx
	pop esi
	ret	; Return from subroutine
FindLargest ENDP
END main