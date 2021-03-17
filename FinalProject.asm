TITLE FinalProject Program(template.asm)

; Author: Senna Titcomb
; Last Modified : 3 / 16 / 2021
; OSU email address : titcombs@oregonstate.edu
; Course number / section: 271 / 001
; Assignment Number : Final Project             Due Date : March 17
; Description: As the TSA’s resident programmer you’ve been assigned to write a
; MASM procedure that will implement the requested behavior.
; Your code must be capable of encryptingand decrypting messages.

INCLUDE Irvine32.inc


; (insert constant definitions here)
.data


.code
main PROC


exit; exit to operating system
main ENDP

; (insert additional procedures here)
;***************************************************************
; Procedure calls several different modes of operation
; receives: stack
; returns: returns result of operation modes
; preconditions: pushed items onto stack
; registers changed: eax, ax, bx, edi, ebp, esp
; ***************************************************************
compute PROC
	push	ebp
	mov		ebp, esp
	cdq

	mov edi, [ebp + 8] ;dest
	mov eax, 0
	cmp [edi], eax
	jge calldecoy

	mov eax, -1
	cmp[edi], eax
	je callencrypt

	mov eax, -2
	cmp[edi], eax
	je calldecrypt
	jmp calldecoy

	calldecoy:
	mov ax, [ebp + 14]	;op1
	mov bx, [ebp + 12]	;op2
	mov edi, [ebp + 8]	;dest
	push ax
	push bx
	push edi
	call decoy
	jmp finish

	callencrypt:
	mov ebx, [ebp + 16]; address of key
	mov eax, [ebp + 12]; address of message
	;mov edi, [ebp + 8]; dest
	push ebx
	push eax
	;push edi
	call encrypt
	jmp finish

	calldecrypt:
	mov eax, [ebp + 16]; address of key
	mov ebx, [ebp + 12]; address of message
	push eax
	push ebx
	call decrypt
	jmp finish

	finish:
	pop ebp
	ret 
compute ENDP

; ***************************************************************
; Procedure calculates sum of operands and returns result
; receives: stack, operands, destination
; returns: returns result of sum
; preconditions: pushed items onto stack
; registers changed: ax, bx, eax, ebx, edi, ebp, esp
; ***************************************************************
decoy PROC
	; decoy
	push ebp
	mov	ebp, esp

	mov ax, WORD PTR [ebp + 14]; operand1
	movsx eax, ax
	mov bx, WORD PTR [ebp + 12]; operand2
	movsx ebx, bx
	mov edi, [ebp + 8]; dest

	add eax, ebx
	mov [edi], eax
	
	pop ebp
	ret 8
decoy ENDP

; ***************************************************************
; Procedure uses a key to encode a secret message
; receives: stack, key, message
; returns: returns result of operation modes
; preconditions: pushed items onto stack
; registers changed: eax, ebx, ecx, edx, edi, esi, ebp, esp
; ***************************************************************
encrypt PROC
	push ebp
	mov	ebp, esp

	mov esi, [ebp + 12]; key
	mov edi, [ebp + 8] ; message
	mov ebx, 0

	encryptloop :
	movsx eax, BYTE PTR [edi + ebx]		;gets specific character
	mov ecx, 0
	cmp eax, ecx		; NULL ?
	je finish
	mov ecx, 97			;a
	cmp eax, ecx
	jl exception
	mov ecx, 122		;z
	cmp eax, ecx
	jg exception
	mov edx, eax	;take ASCII
	sub edx, 97		;subtract by A
	movsx eax, BYTE PTR [esi + edx]		;key place
	mov ecx, [edi + ebx + 1]	;store rest of string
	mov [edi + ebx], eax	;replace
	mov [edi + ebx + 1], ecx	;add on rest of string
	exception :
	inc ebx		;increase place on string
	jmp encryptloop

	finish :
	mov[ebp + 12], edi		;replace
	pop ebp
	ret 8
encrypt ENDP

; ***************************************************************
; Procedure decrypts an encoded message
; receives: stack, key, message
; returns: decoded message
; preconditions: pushed items onto stack
; registers changed: eax, ebx, ecx, edx, edi, esi, ebp, esp
; ***************************************************************
decrypt PROC
	push ebp
	mov	ebp, esp

	mov esi, [ebp + 12]; key
	mov edi, [ebp + 8]; message
	mov ebx, 0

	decryptloop:
	movsx eax, BYTE PTR[edi + ebx]		;get specific character
	mov ecx, 0
	cmp eax, ecx		; NULL ?
	je finish
	mov ecx, 97		; a
	cmp eax, ecx
	jl exception
	mov ecx, 122		; z
	cmp eax, ecx
	jg exception
	mov edx, 0
	findplace:
	cmp edx, 25		;within alphabet?
	jg exception
	movsx ecx, BYTE PTR [esi + edx]		;specific character
	cmp ecx, eax
	je found
	inc edx		;move through string
	jmp findplace
	found:
	add edx, 97
	mov ecx, [edi + ebx + 1]		; store rest of string
	mov[edi + ebx], edx		; replace
	mov[edi + ebx + 1], ecx		; add on rest of string
	exception :
	inc ebx
	jmp decryptloop

	finish :
	mov[ebp + 12], edi
	pop ebp
	ret 8
decrypt ENDP

END main
