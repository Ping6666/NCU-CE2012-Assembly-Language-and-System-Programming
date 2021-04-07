INCLUDE Irvine32.inc

main EQU start@0
BoxWidth = 5
BoxHeight = 5

.data
boxTop BYTE 0DAh, (BoxWidth - 2) DUP(0C4h), 0BFh
boxBody BYTE 0B3h, (BoxWidth - 2) DUP(' '), 0B3h
boxBottom BYTE 0C0h, (BoxWidth - 2) DUP(0C4h), 0D9h

outputHandle DWORD 0
bytesWritten DWORD 0
count DWORD 0
xyPosition COORD <10,5>

cellsWritten DWORD ?
attributes0 WORD BoxWidth DUP(0Ah)
attributes1 WORD (BoxWidth-1) DUP(0Ch), 0Bh
attributes2 WORD BoxWidth DUP(0Eh)

.code
main PROC

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE	; Get the console ouput handle
	mov outputHandle, eax			; save console handle
	call Clrscr

	; 畫出box的第一行
	INVOKE WriteConsoleOutputAttribute,
		outputHandle,	; output handle
		ADDR attributes0,	; write attributes
		BoxWidth,	; number of cells
		xyPosition,	; first cell coordinates
		ADDR cellsWritten	; number of cells written

	INVOKE WriteConsoleOutputCharacter,
		outputHandle,	; console output handle
		ADDR boxTop,	; pointer to the top box line
		BoxWidth,	; size of box line
		xyPosition,	; coordinates of first char
		ADDR count	; output count

	inc xyPosition.Y		; 座標換到下一行位置
	mov ecx, (BoxHeight-2)	; number of lines in body
L1:	push ecx			; save counter 避免invoke 有使用到這個暫存器

	INVOKE WriteConsoleOutputAttribute,
		outputHandle,	; output handle
		ADDR attributes1,	; write attributes
		BoxWidth,	; number of cells
		xyPosition,	; first cell coordinates
		ADDR cellsWritten	; number of cells written

	INVOKE WriteConsoleOutputCharacter,
		outputHandle,	; console output handle
		ADDR boxBody,	; pointer to the box body
		BoxWidth,	; size of box line
		xyPosition,	; coordinates of first char
		ADDR count	; output count

	inc xyPosition.Y	; next line
	pop ecx		; restore counter
	loop L1


	INVOKE WriteConsoleOutputAttribute,
		outputHandle,	; output handle
		ADDR attributes2,	; write attributes
		BoxWidth,	; number of cells
		xyPosition,	; first cell coordinates
		ADDR cellsWritten	; number of cells written

	INVOKE WriteConsoleOutputCharacter,
		outputHandle,	; console output handle
		ADDR boxBottom,	; pointer to the bottom of the box
		BoxWidth,	; size of box line
		xyPosition,	; coordinates of first char
		ADDR count	; output count

	call WaitMsg
	call Clrscr
	exit

main ENDP

END main
