INCLUDE Irvine32.inc
main EQU start@0

; .8086
; .486

.data	; chcp 65001
windowWidth WORD ?
windowHeight WORD ?
boxBat BYTE "▬▬"
boxBall BYTE "•"
boxWall1 BYTE "■"
boxWall2 BYTE "□"
boxSpace BYTE "  "
titleStr BYTE "Brick Break",0
inputStr BYTE ?
; 0 is Space, 1 is •, 2 is ▬, 3 is ■ or □
State BYTE 1800 DUP(?)
win BYTE 0	; 0 continue 1 lose 2 win


outputHandle DWORD 0
inputHandle DWORD 0
consoleInfo CONSOLE_SCREEN_BUFFER_INFO <>
count DWORD ?
notUsed DWORD ?
lpReserved DWORD 0
ballxyPosition COORD <60, 28>
batxyPosition COORD <56, 29>
wallxyPosition COORD <?, ?>
ballxDir SWORD 2	;x : -1 is left 1 is right
ballyDir SWORD -1	;y : -1 is up 1 is down

PreSet PROTO, bWidth:PTR WORD, bHeight:PTR WORD, bState:PTR BYTE
FillTheWindows PROTO, bWidth:WORD, bHeight:WORD, bState:PTR BYTE

.code
main PROC
	INVOKE SetConsoleTitle, ADDR titleStr	; set the title of the console
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE	; Get the console output handle
	mov outputHandle, eax					; save console output handle
	INVOKE GetStdHandle, STD_INPUT_HANDLE	; Get the console input handle
	mov inputHandle, eax					; save console input handle
	; get the console screen buffer info and set it in var consoleInfo
	INVOKE GetConsoleScreenBufferInfo, outputHandle, ADDR consoleInfo
	call Clrscr

	mov win, 0
	; preset width & height & all the state of the printable position
	INVOKE PreSet, OFFSET windowWidth, OFFSET windowHeight, OFFSET State
	; fill the console window by the state
	INVOKE FillTheWindows, windowWidth, windowHeight, OFFSET State
		
L1:
	; remove the ball
	INVOKE WriteConsoleOutputCharacter,
		outputHandle,		; output handle
		ADDR boxSpace,		; pointer to the character to be written
		LENGTHOF boxSpace,	; size of buffer
		ballxyPosition,		; coordinates of first char
		ADDR count			; output count
	; test for right line
	mov ax, windowWidth
	sub ax, 2			; the printable charactor is place in 2 space
	mov bx, ballxyPosition.X
	add bx, ballxDir
	cmp bx, ax
	jle L2_1
	mov ax, ballxDir
	mov bx, -1
	mul bx
	mov ballxDir, ax
	jmp L2
L2_1:
	; test for left line
	cmp bx, 0
	jge L2
	mov ax, ballxDir
	mov bx, -1
	mul bx
	mov ballxDir, ax
L2:
	; test for bottom line
	mov ax, windowHeight
	sub ax, 1
	mov bx, ballxyPosition.Y
	add bx, ballyDir
	cmp bx, ax
	jle L3_1
	mov win, 1
	; mov ax, ballyDir
	; mov bx, -1
	; mul bx
	; mov ballyDir, ax
	jmp L3
L3_1:
	; test for top line
	cmp bx, 0
	jge L3
	mov ax, ballyDir
	mov bx, -1
	mul bx
	mov ballyDir, ax
L3:
	; check the horizontal direction's wall
	mov esi, OFFSET State
	movsx eax, ballxyPosition.X
	movsx edx, ballxDir
	add eax, edx
	xor edx, edx
	mov ebx, 2
	div ebx
	add esi, eax
	movsx eax, ballxyPosition.Y
	movsx ebx, windowWidth
	mul ebx
	xor edx, edx
	mov ebx, 2
	div ebx
	add esi, eax
	movsx eax, BYTE PTR [esi]
	; take out the state of the place next to the ball
	cmp eax, 3
	jne L4_1
	; calculate the wall's place
	mov ax, ballxyPosition.X
	add ax, ballxDir
	mov wallxyPosition.X, ax
	mov bx, ballxyPosition.Y
	mov wallxyPosition.Y, bx
	; remove the wall
	INVOKE WriteConsoleOutputCharacter,
		outputHandle,		; output handle
		ADDR boxSpace,		; pointer to the character to be written
		LENGTHOF boxSpace,	; size of buffer
		wallxyPosition,		; coordinates of first char
		ADDR count			; output count
	mov ax, ballxDir
	mov bx, -1
	mul bx
	mov ballxDir, ax
L4_1:
	; check the vertical direction's wall
	mov esi, OFFSET State
	movsx eax, ballxyPosition.X
	xor edx, edx
	mov ebx, 2
	div ebx
	add esi, eax
	movsx eax, ballxyPosition.Y
	movsx edx, ballyDir
	add eax, edx
	movsx ebx, windowWidth
	mul ebx
	xor edx, edx
	mov ebx, 2
	div ebx
	add esi, eax
	movsx eax, BYTE PTR [esi]
	; take out the state of the place next to the ball
	cmp eax, 3
	jne L4
	; calculate the wall's place
	mov ax, ballxyPosition.X
	mov wallxyPosition.X, ax
	mov bx, ballxyPosition.Y
	add bx, ballyDir
	mov wallxyPosition.Y, bx
	; remove the wall
	INVOKE WriteConsoleOutputCharacter,
		outputHandle,		; output handle
		ADDR boxSpace,		; pointer to the character to be written
		LENGTHOF boxSpace,	; size of buffer
		wallxyPosition,		; coordinates of first char
		ADDR count			; output count
	mov ax, ballyDir
	mov bx, -1
	mul bx
	mov ballyDir, ax
L4:
	; check the bat
	mov esi, OFFSET State
	movsx eax, ballxyPosition.X
	xor edx, edx
	mov ebx, 2
	div ebx
	add esi, eax
	movsx eax, ballxyPosition.Y
	movsx edx, ballyDir
	; check the ball's direction
	cmp edx, 1
	jne L5
	add eax, edx
	movsx ebx, windowWidth
	mul ebx
	xor edx, edx
	mov ebx, 2
	div ebx
	add esi, eax
	movsx eax, BYTE PTR [esi]
	; take out the state of the place next to the ball
	cmp eax, 2
	jne L5
	mov ax, ballyDir
	mov bx, -1
	mul bx
	mov ballyDir, ax
L5:
	; set the ball's next place
	mov ax, ballxyPosition.X
	add ax, ballxDir
	mov ballxyPosition.X, ax
	mov bx, ballxyPosition.Y
	add bx, ballyDir
	mov ballxyPosition.Y, bx
	; print out the ball
	INVOKE WriteConsoleOutputCharacter,
		outputHandle,		; output handle
		ADDR boxBall,		; pointer to the character to be written
		LENGTHOF boxBall,	; size of buffer
		ballxyPosition,		; coordinates of first char
		ADDR count			; output count

	xor eax, eax
	INVOKE GetKeyState, VK_LEFT
	cmp al, 0
	je L6
	cmp al, 1
	jg L6
	; movzx eax, al
	; call WriteDec
	; call WaitMsg
	cmp batxyPosition.X, 0
	jle L6
	sub batxyPosition.X, 2
	mov esi, OFFSET State
	add esi, 1740	;1740 = 29 * 60
	movsx eax, batxyPosition.X
	xor edx, edx
	mov ebx, 2
	div ebx
	add esi, eax
	mov BYTE PTR [esi], 2
	; set the bat
	INVOKE WriteConsoleOutputCharacter,
		outputHandle,		; output handle
		ADDR boxBat,		; pointer to the character to be written
		LENGTHOF boxBat,	; size of buffer
		batxyPosition,		; coordinates of first char
		ADDR count			; output count
	add batxyPosition.X, 10
	add esi, 5				; 5 = 10 / 2
	mov BYTE PTR [esi], 0
	; remove the bat
	INVOKE WriteConsoleOutputCharacter,
		outputHandle,		; output handle
		ADDR boxSpace,		; pointer to the character to be written
		LENGTHOF boxSpace,	; size of buffer
		batxyPosition,		; coordinates of first char
		ADDR count			; output count
	sub batxyPosition.X, 1	; clear the bat's butt
	INVOKE WriteConsoleOutputCharacter,
		outputHandle,		; output handle
		ADDR boxSpace,		; pointer to the character to be written
		LENGTHOF boxSpace,	; size of buffer
		batxyPosition,		; coordinates of first char
		ADDR count			; output count
	sub batxyPosition.X, 1	; clear the bat's butt
	INVOKE WriteConsoleOutputCharacter,
		outputHandle,		; output handle
		ADDR boxSpace,		; pointer to the character to be written
		LENGTHOF boxSpace,	; size of buffer
		batxyPosition,		; coordinates of first char
		ADDR count			; output count
	sub batxyPosition.X, 8
L6:
	xor eax, eax
	INVOKE GetKeyState, VK_RIGHT
	cmp al, 0
	je L7
	cmp al, 1
	jg L7
	; movzx eax, al
	; call WriteDec
	; call WaitMsg
	mov ax, windowWidth
	sub ax, 10
	cmp batxyPosition.X, ax
	jge L7
	mov esi, OFFSET State
	add esi, 1740	;1740 = 29 * 60
	movsx eax, batxyPosition.X
	xor edx, edx
	mov ebx, 2
	div ebx
	add esi, eax
	mov BYTE PTR [esi], 0
	; remove the bat
	INVOKE WriteConsoleOutputCharacter,
		outputHandle,		; output handle
		ADDR boxSpace,		; pointer to the character to be written
		LENGTHOF boxSpace,	; size of buffer
		batxyPosition,		; coordinates of first char
		ADDR count			; output count
	add batxyPosition.X, 10
	add esi, 5				; 5 = 10 / 2
	mov BYTE PTR [esi], 2
	; set the bat
	INVOKE WriteConsoleOutputCharacter,
		outputHandle,		; output handle
		ADDR boxBat,		; pointer to the character to be written
		LENGTHOF boxBat,	; size of buffer
		batxyPosition,		; coordinates of first char
		ADDR count			; output count
	sub batxyPosition.X, 8
L7:
	INVOKE Sleep, 75		; set the time to wait arround 45-150
	cmp win, 0				; check win or lose
	je L1

	; mov ah, 0 ; 0 in AH means to set video mode
 	; mov al, 6 ; 640 x 200 graphics mode
 	; int 10h
 	; mov ah, 0
 	; mov al, 3 ; 80x25 color text
 	; int 10h
 	; mov ah, 0
 	; mov al, 13h ; linear mode 320x200x256 color graphics
 	; int 10h
	call Clrscr
	call WaitMsg
	exit
main ENDP

PreSet PROC, bWidth:PTR WORD, bHeight:PTR WORD, bState:PTR BYTE
	mov ax, consoleInfo.srWindow.Right
	mov dx, consoleInfo.srWindow.Left
	sub ax, dx
	inc ax
	mov esi, bWidth
	mov WORD PTR [esi], ax

	mov bx, consoleInfo.srWindow.Bottom
	mov dx, consoleInfo.srWindow.Top
	sub bx, dx
	inc bx
	mov edi, bHeight
	mov WORD PTR [edi], bx
	
	; set wall
	mov edi, bWidth
	movsx eax, WORD PTR [edi]
	mov ebx, 10
	mul ebx
	xor edx, edx
	mov ecx, 2
	div ecx
	mov ecx, eax

	mov esi, bState
L01:
	mov BYTE PTR [esi], 3
	inc esi
	loop L01

	; set space
	mov edi, bWidth
	movsx eax, WORD PTR [edi]
	xor edx, edx
	mov ebx, 20
	mul ebx
	mov ecx, 2
	div ecx
	mov ecx, eax
L02:
	mov BYTE PTR [esi], 0
	inc esi
	loop L02

	mov esi, bState
	add esi, 1710	;1710 = 28*60+30
	mov BYTE PTR [esi], 1
	add esi, 58		;58=60-2
	mov ecx, 5
L03:
	mov BYTE PTR [esi], 2
	inc esi
	loop L03
	ret
PreSet ENDP

FillTheWindows PROC, bWidth:WORD, bHeight:WORD, bState:PTR BYTE
	movsx eax, bWidth
	movsx ebx, bHeight
	mul ebx
	xor edx, edx
	mov ecx, 2
	div ecx
	mov ecx, eax	; set the total loop time
	mov esi, bState	; point to the first place
L1:	push ecx	; save ecx to stack
	; take out the state of the printable position
	movsx eax, BYTE PTR [esi]

	cmp eax, 0	; if it is space
	jne L2
	; print Space
	INVOKE WriteConsole,
		outputHandle,		; output handle
		ADDR boxSpace,		; pointer to buffer
		LENGTHOF boxSpace,	; size of buffer
		ADDR count,			; output count
		lpReserved			; (not used)
	jmp L5
L2:	cmp eax, 1	; if it is ball
	jne L3
	; print Ball
	INVOKE WriteConsole,
		outputHandle,		; output handle
		ADDR boxBall,		; pointer to buffer
		LENGTHOF boxBall,	; size of buffer
		ADDR count,			; output count
		lpReserved			; (not used)
	jmp L5
L3:	cmp eax, 2	; if it is bat
	jne L4
	; print Bat
	INVOKE WriteConsole,
		outputHandle,		; output handle
		ADDR boxBat,		; pointer to buffer
		LENGTHOF boxBat,	; size of buffer
		ADDR count,			; output count
		lpReserved			; (not used)
	jmp L5
L4:	cmp eax, 3	; if it is wall
	jne L5		; check which type of wall
	xor edx, edx
	mov eax, esi
	mov ebx, 2
	div ebx
	cmp edx, 0
	jz L6
	; print Wall1
	INVOKE WriteConsole,
		outputHandle,		; output handle
		ADDR boxWall1,		; pointer to buffer
		LENGTHOF boxWall1,	; size of buffer
		ADDR count,			; output count
		lpReserved			; (not used)
	jmp L5
L6:	; print Wall2
	INVOKE WriteConsole,
		outputHandle,		; output handle
		ADDR boxWall2,		; pointer to buffer
		LENGTHOF boxWall2,	; size of buffer
		ADDR count,			; output count
		lpReserved			; (not used)
L5:	pop ecx	; pop back ecx
	inc esi	; point to next printable position
	dec ecx	; set loop time
	jnz L1	; jump (loop too far so do jump)
	ret
FillTheWindows ENDP

END main
