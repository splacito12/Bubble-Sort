;Samantha Placito,  Noah Curtis, Shawn Chacko
;CIS 11; Bubble sort (Final Project)
;Input: User will input 8 numbers within the given range
;Output: Program will output the numbers in ascending order


.ORIG   x3000

;SUBROUTINE CALLS
JSR INPUT_USER

;HALT

;Initialize pointers
	AND R1, R1, #0	;CLEAR R1	
	AND R5, R5, #0	;CLEAR R5
	AND R0, R0, #0	;CLEAR R0
	LD R4, STACK
	LD R5, COUNTER	;LOAD COUNTER TO R5
	LD R6, ARRAY	;LOAD ARRAY TO R6

INPUT_USER
	LEA R0, PROMPT	;DISPLAY PROMPT
    	PUTS

ZEROES
	JSR SAVEREG
	AND R0, R0, #0	;CLEAR R0
	GETC
	OUT
	AND R2, R2, #0	;CLEAR R2
	AND R5, R5, #0	;CLEAR R5
	LDI R5, HUNNID
	JSR ASCII		;CALL ASCII SUBROUTINE
	ADD R0, R0, R2
	ADD R2, R0, #0	;COPY R0 TO R2
	AND R0, R0, #0
	ADDHUNNID
	ADD R0, R0, R2	;R0 += R2
	ADD R5, R5, #-1	;DECREMENT R5
	BRp ADDHUNNID	;BRANCH TO ADDHUNNID IF POSITIVE
	ADD R1, R0, #0
	AND R0, R0, #0

TENS	
	AND R1, R1, #0
	AND R0, R0, #0	;CLEAR R0 FOR INPUT
	GETC 
	OUT			;DISPLAY
	AND R2, R2, #0	;CLEAR R2
	AND R5, R5, #0	;CLEAR R5
	LDI R3, TEN
	JSR ASCII
	ADD R0, R0, R2
	ADD R2, R0, #0
	AND R0, R0, #0
	ADDTEN
	ADD R0, R0, R2
	ADD R5, R5, #-1
	BRp ADDTEN		;BRANCH TO ADDTEN IF POSITIVE
	ADD R3, R0, #0
	AND R0, R0, #0	;CLEAR R0

HUNDREDS
	AND R2, R2, #0
	AND R1, R1, #0
	ADD R1, R1, #0
	AND R0, R0, #0
	GETC
	OUT
	JSR ASCII
	ADD R0, R1, R0
	JSR STORE
	AND R2, R2, #0

;PUT THE NUMBERS TOGETHER
	ADD R2, R1, R4	;R2 NOW HAS BOTH NUMBERS ADDED
	ADD R2, R0, R2	;ADD THIRD NUMBER
	STR R2, R3, #0
	ADD R3, R3, #1	;R3 + 1
	ADD R6, R6, #-1	;R6 = R6 - 1
	BRp CONTINUE	;BRANCH TO CONTINUE IF POSITIVE
	CONTINUE
		JSR INPUT_USER
	
	
	

UNSORT_ARR
	AND R5, R5, #0	;REINIT COUNTER
	AND R6, R6, #0	;REINIT ARRAY
	LD R5, COUNTER
	LD R6, ARRAY            ;show array before sort
	LEA R0, UNSORT
	PUTS
	AND R0, R0, #0	;CLEAR R0
	AND R1, R1, #0	;CLEAR R1
	
;PRINT OUTPUT AND ASCII
   PRINT_LOOP1
	JSR SAVEREG	
	AND R0, R0, #0	;CLEAR R0
	AND R2, R2, #0	;CLEAR R2
	JSR GET		;GET AN ELEMENT FROM THE ARRAY
	ADD R2, R2, #1		
	ADD R0, R0, #-10		
	BRzp PRINT_LOOP1	;BRANCH TO PRINT_LOOP1 IF ZERO OR POSITIVE	
		
   PRINT_LOOP2
	ADD R0, R0, #10	
	AND R3, R3, #0	;CLEAR R3
	ADD R3, R0, #0	;COPY R0 TO R3
	AND R0, R0, #0	;CLEAR R0		
	JSR POS_ASCII	;ASCII CONVERT
	OUT			;SHOW R0 TO CONSOLE
	AND R0, R0, #0	;CLEAR R0	
	ADD R0, R3, #0
	NOT R2, R2		
	ADD R2, R2, #1	;2’S COMPLEMENT R2
	ADD R0, R2, #1		
	JSR POS_ASCII	;ASCII CONVERT	
	OUT			;SHOW R0 TO CONSOLE AFTER R2 COPIED TO IT
	;MAKE #S PRINT OUT LEGIBLY
	LEA R0, SPC			;GAP BETWEEN NUMBERS
	PUTS		
	
	ADD R5, R5, #-1		;DECREMENT R5
	BRp PRINT_LOOP1		;RESTART PRINT LOOP OF ELEMENTS TO BE PRINTED
	ADD R1, R1, #0
	JSR LOADREG
	BRz SORT		;BRANCH TO SORT IF ZERO
	HALT
	
;ARRAY
STORE		
	STR R0, R6, #0		;STORE ARRAY ELEMENT N R0
	ADD R6, R6, #1	             ;INCREMENT R6 (FOR ARR SIZE)
	RET
GET		
	LDR R0, R6, #0		;LD R6 ELEMENT INTO R0
	ADD R6, R6, #1		;INCREMENT R6
	RET	


;BUBBLE SORT

SORT 	
	JSR SAVEREG
	;REINIT POINTER & COUNTERS FOR ARRAY LOOP
	AND R3, R3, #0	;CLEAR R3
	LD R3, PT	
	AND R4, R4, #0	;CLEAR R4	
	LD R4, COUNT		
	AND R5, R5, #0	;CLEAR R5
	ADD R5, R4, #0		
	

	;OUTER LOOP// RUNS THRU ARR MULTIPLE TIMES
	OUTER_LOOP
		ADD R4, R4, #-1	;DECREMENT COUNTER
		BR INNER_LOOP	;TO INNER LOOP
		BRnz SORTED		;ARR IS SORTED IF COUNTER <= 0
		ADD R5, R4, #0	;
		LD R3, PT	
	
	;INNER LOOP// SORTS ARRAY
	INNER_LOOP
		LDR R0, R3, #0	;LOAD R3 INTO R0
		LDR R1, R3, #1	;LOAD R3 + 1 INTO R1	
		AND R2, R2, #0		
		NOT R2, R1		;1S COMPLIMENT OF R2
		ADD R2, R2, #1	; 2S’ COMP OF R2, R2 IS NOW NEG	
		ADD R2, R0, R2	;R2 = R0 - R2
		BRnz SWAPPED	;BRANCH TO SWAPPED IF NEG OR ZERO	
		;PERFORM SWAP	
		STR R1, R3, #0		;STORE R1 INTO R3
		STR R0, R3, #1		;STORE R0 INTO R3 + 1

	;Increments/Decrements counters and pointer once values swapped
	SWAPPED
		ADD R3, R3, #1		
		ADD R5, R5, #-1
		
		BRp INNER_LOOP		;Branch to inner loop if positive 
		BRzp OUTER_LOOP		;branch to outer loop if zero or positive

	;PRINT SORTED ARRAY
	SORTED	
		LEA R0, SORTED_NUMBERS
		PUTS
		BR PRINT_LOOP1		;BRANCH TO PRINT_LOOP1
		RET		
JSR LOADREG	
			

;ASCII CONVERSION(S)
ASCII		ADD R2, R2, #-15	;SUBTRACT TOTAL OF #48
		ADD R2, R2, #-15	
		ADD R2, R2, #-15
		ADD R2, R2, #-3
		RET

POS_ASCII	ADD R0, R0, #15		; Add total of #48
		ADD R0, R0, #15
		ADD R0, R0, #15
		ADD R0, R0, #3
		RET
  
;STACK
PUSH		ADD R4, R4, #-1		;MAKE STACK 1 ELEMENT BIGGER
		STR R0, R4, #0	             		;PUSH ELEMENT ONTO STACK
		RET 		

POP		LDR R0, R4, #0		;POP ELEMENT OFF STACK
		ADD R4, R4, #1		;MAKE STACK 1 ELEMENT SMALLER
		RET

;SAVE/LOAD REGISTERS
SAVEREG
	STI R7, TMPX		 ; Store the current value of R7 as a temp
	LDI R7, STCK
	ADD R7, R7, #7
	STR R0, R7, #0
	STR R1, R7, #1
	STR R2, R7, #2
	STR R3, R7, #3
	STR R4, R7, #4
	STR R5, R7, #5
	STR R6, R7, #6
	LDI R0, TMPX
	ADD R7, R7, #1
	STI R7, STCK
	LDI R7, TMPX
	JMP R7

LOADREG
	STI R7, TMPX		 ; Store the current value of R7 as a temp
	LDI R7, STCK
	AND R0, R0, #0
	ADD R0, R0, #1
	LDR R1, R7, #0
	ADD R1, R1, R0
	BRz BREAK
	LDR R0, R7, #-8	 ; Load the value from R7 with -8 at R0
	LDR R1, R7, #-7	 ; Load the value from  R7 with -7 at R1
	LDR R2, R7, #-6	 ; Load the value from R7 with -6 at R2
	LDR R3, R7, #-5	; Load the value from R7 with -5 at R3
	LDR R4, R7, #-4	; Load the value from R7 with -4 at R4
	LDR R5, R7, #-3	; Load the value from R7 with -3 at R5
	LDR R6, R7, #-2	; Load the value from R7 with -2 at R6
	AND R1, R1, #0
	STR R1, R7, #-1
	LDR R1, R7, #7	
	ADD R7, R7, #-8
	STI R7, TMPX
	BREAK
	LDI R7, TMPX
	RET
	
;STRINGS AND BASE POINTER TO THE STACK AND COUNTER
		ARRAY		.FILL x3500	
		STACK		.FILL x4000	
		HUNNID		.FILL X0064
		TEN		.FILL X000A
		COUNTER		.FILL x0008
		PT		.FILL x4000
		COUNT		.FILL #8
		TMPX		.FILL x340C
		STCK		.FILL x340D
		PROMPT		.STRINGZ    "\nEnter a number from within the range of 0-100 (EX: Input 8 as 008 or 97 as 097):"
		INV		.STRINGZ    "Invalid input, please try again!"
		UNSORT		.STRINGZ    "Unsorted Values: "
		SORTED_NUMBERS	.STRINGZ    "Sorted Values: "
		SPC		.STRINGZ	" "	


.END
