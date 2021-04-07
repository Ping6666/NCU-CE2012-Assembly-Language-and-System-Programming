INCLUDE Irvine32.inc

main EQU start@0

.data
dividend WORD 1545	; Group leader's student ID (4 decimal only)
divisor WORD 100
quotient WORD 1 DUP(?)
remainder WORD 1 DUP(?)

.code
divide MACRO dividend, divisor, quotient, remainder
IFB <dividend, divisor, quotient, remainder>
	EXITM
ENDIF
	mov ax, dividend	; ax = dividend_LOW
	xor dx, dx		; dx = dividend_HIGH = 0
	mov bx, divisor	; bx = divisor
	div bx		; do the division

	mov quotient, ax	; quotient = ax
	mov remainder, dx	; remainder = dx
ENDM

main PROC
	movsx eax, dividend
	call WriteDec
	call Crlf		; print out dividend + \n

	divide dividend, divisor, quotient, remainder

	movsx eax, quotient
	call WriteDec
	call Crlf		; print out quotient + \n

	movsx eax, remainder
	call WriteDec
	call Crlf		; print out remainder + \n

	call WaitMsg	; waiting for user's input
	exit
main ENDP
END main