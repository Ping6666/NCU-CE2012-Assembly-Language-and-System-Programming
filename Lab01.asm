TITLE Homework01              (HW01.ASM)
INCLUDE Irvine32.inc

main          EQU start@0
.code
main PROC		
	mov al, 45d	;last two digits of leader’s students ID
	mov ah, 23d	;last two digits of member’s students ID
	mov ax, 2533h	;last four digits of student’s ID in hexadecimal
	mov dx, 0eeeah	;let the value of dx is eeea
	sub dx, ax	;value of dx subtracting by ax
	
main ENDP
END main