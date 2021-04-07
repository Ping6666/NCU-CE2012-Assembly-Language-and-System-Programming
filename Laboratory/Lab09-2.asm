INCLUDE Irvine32.inc

main EQU start@0

Str_remove PROTO, pStart:PTR BYTE, nChars:DWORD

.data
target1 BYTE "", 0		;填入組員的學號
target2 BYTE "", 0		;填入組員的學號
target3 BYTE "999999999", 0

.code
main PROC
	INVOKE Str_remove, OFFSET target1, 5		;第一個字串移除5個字元
	mov edx, OFFSET target1
	call WriteString
	call Crlf

	INVOKE Str_remove, OFFSET target2, 2		;第二個字串移除2個字元
	mov edx, OFFSET target2
	call WriteString
	call Crlf

	INVOKE Str_remove, OFFSET [target2+1], 15	; 第二個字串移除超過字串長度的字元
	mov edx, OFFSET target2
	call WriteString
	call Crlf

	call WaitMsg
	exit
main ENDP

Str_remove PROC,
	pStart:PTR BYTE,	; points to first character to delete
	nChars:DWORD	; number of characters to delete

	INVOKE Str_length, pStart
	mov ecx, eax		; 抓到字串長度存放在 ecx 給之後複製迴圈用

	.IF nChars <= ecx		; 檢查移除字元是否超過字串大小
		sub ecx, nChars	; 如果沒有超過，就剪掉移除的字元數量
	.ENDIF

	mov esi, pStart		; 設定複製來源字串的起始點
	add esi, nChars		; 將起始點移到正確要複製的位置
	mov edi, pStart		; 將目的起始點設定好

	cld			; clear direction flag (forward)
	rep movsb		; do the move
	mov BYTE PTR [edi], 0	; insert new null byte

Exit_proc:
	ret
Str_remove ENDP

END main