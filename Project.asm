    .ORIG    x3000
    BRnzp TEST_BEGIN

; STEP 1: MUL3ADD1
; ****************
; Multiplies an integer A by 3 and then adds 1.
;
; argument:     in R0 is A
; return value: in R1 will be the result of (A * 3) + 1
;
MUL3ADD1
; ************************* Start your code here *************************
    ST R0, S_0
    ADD R1, R0, R0 ; here is A * 2
    ADD R1, R1, R0 ; now is A * 3
    ADD R1, R1, #1 ; 3A + 1
    LD R0, S_0
    RET
    S_0 .FILL x0000
; ************************** End your code here **************************


; STEP 2: DIVIDEBY2
; *****************
; Divides even positive integer N by 2.
;
; argument:     in R0 is N
; return value: in R1 will be the result of N / 2
;
DIVIDEBY2
; ************************* Start your code here *************************
    ST R0, ST_0
    ST R4, ST_4
    AND R1, R1, #0 ;RESULT = 0

    WLP
    ADD R4, R0, #-2 ;while N >= 2
    BRn FAILED_RESULT

    ADD R0, R0, #-2 ;subtract 2 from N

    ADD R1, R1, #1 ;increment RESULT by 1

    BRnzp WLP ;back to start of whole loop

    FAILED_RESULT ;while N < 2

    LD R0, ST_0
    LD R4, ST_4
    RET
    ST_0 .FILL x0000
    ST_4 .FILL x0000
; ************************** End your code here **************************


; STEP 3: COLLATZ_STEPS
; *********************
; Calculates the number of steps to reach 1 from positive integer X.
;
; argument:     in R0 is X
; return value: in R1 will be the number of steps to reach 1
;
COLLATZ_STEPS
; ************************* Start your code here *************************
    ST R0, STORE_R0
    ST R2, STORE_R2
    ST R4, STORE_R4
    ST R7, STORE_R7

    AND R2, R2, #0 ;RESULT = 0

    BACK_START
    ADD R4 R0 #-1
    BRz X_Equal_1 ;while X is not equal to 1, continue

    AND R4, R0, #1
    BRz EVEN_VALUE ; check it is odd or even

    JSR MUL3ADD1 ;if X is odd  -> increase X to 3 * X + 1
    ADD R0, R1, #0
    BRnzp INCRE_1

    EVEN_VALUE
    JSR DIVIDEBY2 ;if X is even -> decrease X to X/2
    ADD R0, R1, #0

    INCRE_1
    ADD R2, R2 #1 ;increment STEPS by 1

    BRnzp BACK_START
    X_Equal_1

    ADD R1, R2 #0 ;while X is equal to 1, R1 = 1

    LD R0, STORE_R0
    LD R2, STORE_R2
    LD R4, STORE_R4
    LD R7, STORE_R7
    RET
    STORE_R0 .FILL x0000
    STORE_R2 .FILL x0000
    STORE_R4 .FILL x0000
    STORE_R7 .FILL x0000
; ************************** End your code here **************************




; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!      DO NOT REMOVE OR MODIFY ANYTHING BELOW THIS LINE!        !!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


; MAIN SECTION
; ************
; Contains helper subroutines and testing code
;
; We've provided 3 subroutines to help check and debug your implementation:
;    1. PRINT_DIGIT
;    2. PRINT_INT
;    3. COLLATZ
; *************************************************************************
;
; Except for the labels to call the 3 helper subroutines listed above,
; DO NOT USE ANY OF THE OTHER LABELS in our code below.


; HELPER 1: PRINT_DIGIT
; *********************
; Prints a single-digit integer N, where N is between 0 and 9,
;
; arguments:    in R0 is N
;
PRINT_DIGIT
; *************************************************************************
    ST R0, PRINT_DIGIT_R0
    ST R1, PRINT_DIGIT_R1
    ST R7, PRINT_DIGIT_R7

    LD R1, ASCII_ZERO
    ADD R0, R0, R1
    OUT

    LD R0, PRINT_DIGIT_R0
    LD R1, PRINT_DIGIT_R1
    LD R7, PRINT_DIGIT_R7

    RET

    PRINT_DIGIT_R0 .FILL x0000
    PRINT_DIGIT_R1 .FILL x0000
    PRINT_DIGIT_R7 .FILL x0000
    ASCII_ZERO .FILL x0030
; *************************************************************************


; HELPER 2: PRINT_INT
; *******************
; Prints a two-digit integer N followed by a new line character (x000A).
; N is between 0 and 99. For N < 10, the leading 0 is printed.
;
; This subroutine must call PRINT_DIGIT to print a single digit.
;
; arguments:    in R0 is N

PRINT_INT
; *************************************************************************
    ST R0, PRINT_INT_R0
    ST R1, PRINT_INT_R1
    ST R2, PRINT_INT_R2
    ST R7, PRINT_INT_R7

    AND R1, R1, #0 

    SUBTRACT_TEN
    ADD R0, R0, #-10
    BRn SUBTRACT_TEN_END
    ADD R1, R1, #1
    BR SUBTRACT_TEN

    SUBTRACT_TEN_END
    ADD R2, R0, #10

    AND R0, R1, R1
    JSR PRINT_DIGIT
    AND R0, R2, R2
    JSR PRINT_DIGIT
    LD R0, NEW_LINE
    OUT

    LD R0, PRINT_INT_R0
    LD R1, PRINT_INT_R1
    LD R2, PRINT_INT_R2
    LD R7, PRINT_INT_R7

    RET

    PRINT_INT_R0 .FILL x0000
    PRINT_INT_R1 .FILL x0000
    PRINT_INT_R2 .FILL x0000
    PRINT_INT_R7 .FILL x0000
    NEW_LINE .FILL x000A
; *************************************************************************


; HELPER 3: COLLATZ
; *****************
; Subroutine that prints the Collatz steps taken for N to 1.
; Uses the COLLATZ_STEPS subroutine to calculate the number of steps.
;
; argument:     in R0 is N, a positive integer
;
COLLATZ
; *************************************************************************
    ST R0, COLLATZ_R0
    ST R2, COLLATZ_R2
    ST R7, COLLATZ_R7

    AND R0, R0, R0

    ; Loop runs from N to 1
    LOOP_CONDITION
    ; Run the loop while R0 >= 1
    BRnz COLLATZ_LOOP_END

    JSR COLLATZ_STEPS

    ADD R2, R0, #0
    ADD R0, R1, #0

    JSR PRINT_INT

    ADD R0, R2, #0
    
    ; Decrement number
    ADD R0, R0, #-1

    BRnzp LOOP_CONDITION
    COLLATZ_LOOP_END

    LD R0, COLLATZ_R0
    LD R2, COLLATZ_R2
    LD R7, COLLATZ_R7

    RET

    COLLATZ_R0 .FILL x0000
    COLLATZ_R2 .FILL x0000
    COLLATZ_R7 .FILL x0000
; *************************************************************************

TEST_BEGIN

; ************************ TEST FOR MUL3ADD1 ******************************
    ; initialize the registers for checking callee saving
    LD R2, INIT_REG_VAL1
    LD R3, INIT_REG_VAL1
    LD R4, INIT_REG_VAL1
    LD R5, INIT_REG_VAL1
    LD R6, INIT_REG_VAL1

    ; print the message
    LEA R0, MUL3ADD1_MSG
    PUTS

    ; test the MUL3ADD1 subroutine to multiply a number with 3 and add 1
    AND R0, R0, #0
    LD R1, MUL3ADD1_N
    ADD R0, R0, R1        ; initialize the operand to 32
    JSR MUL3ADD1          ; calculate and store the result in R1
    AND R0, R1, R1        ; move the result of MUL from R1 to R0
    JSR PRINT_INT         ; print the value in R0

    ; check if the original values in the registers are preserved
    LD R0, INIT_REG_VAL_NEG1
    ADD R3, R3, R0
    BRnp MUL3ADD1_REG_SAVING_FAILED
    ADD R4, R4, R0
    BRnp MUL3ADD1_REG_SAVING_FAILED
    ADD R5, R5, R0
    BRnp MUL3ADD1_REG_SAVING_FAILED
    ADD R6, R6, R0
    BRnp MUL3ADD1_REG_SAVING_FAILED

    BRnzp TEST_MUL3ADD1_END

MUL3ADD1_REG_SAVING_FAILED
    LEA R0, MUL3ADD1_REG_SAVING_MSG
    PUTS
    BRnzp TEST_MUL3ADD1_END

    MUL3ADD1_MSG     .STRINGZ "\n32 * 3 + 1 = "
    MUL3ADD1_REG_SAVING_MSG   .STRINGZ "\nCheck for callee saving failed!\n"
    INIT_REG_VAL1     .FILL    x600D     ; DO NOT USE THIS LABEL/VALUE
    INIT_REG_VAL_NEG1 .FILL    #-24589   ; DO NOT USE THIS LABEL/VALUE
    MUL3ADD1_N        .FILL    #32       ; DO NOT USE THIS LABEL/VALUE

TEST_MUL3ADD1_END
; *************************************************************************

; ********************** TEST FOR DIVIDEBY2 *******************************
    ; initialize the registers for checking callee saving
    LD R2, INIT_REG_VAL2
    LD R3, INIT_REG_VAL2
    LD R4, INIT_REG_VAL2
    LD R5, INIT_REG_VAL2
    LD R6, INIT_REG_VAL2

    ; print the message
    LEA R0, DIVIDEBY2_MSG
    PUTS

    ; test the DIVIDEBY2 subroutine to Divide a number by 2
    AND R0, R0, #0
    LD R1, DIVIDEBY2_N     ; load operand value from memory
    ADD R0, R0, R1         ; initialize the operand
    JSR DIVIDEBY2          ; divide and store the result in R1
    AND R0, R1, R1         ; move the result of DIVIDEBY2 from R1 to R0
    JSR PRINT_INT          ; print the value in R0

    ; check if the original values in the registers are preserved
    LD R0, INIT_REG_VAL_NEG2
    ADD R2, R2, R0
    BRnp DIVIDEBY2_REG_SAVING_FAILED
    ADD R3, R3, R0
    BRnp DIVIDEBY2_REG_SAVING_FAILED
    ADD R4, R4, R0
    BRnp DIVIDEBY2_REG_SAVING_FAILED
    ADD R5, R5, R0
    BRnp DIVIDEBY2_REG_SAVING_FAILED
    ADD R6, R6, R0
    BRnp DIVIDEBY2_REG_SAVING_FAILED

    BRnzp TEST_DIVIDEBY2_END

DIVIDEBY2_REG_SAVING_FAILED
    LEA R0, DIVIDEBY2_REG_SAVING_MSG
    PUTS
    BRnzp TEST_DIVIDEBY2_END

    DIVIDEBY2_MSG    .STRINGZ "\n196 /  2 = "
    DIVIDEBY2_REG_SAVING_MSG .STRINGZ "\nCheck for callee saving failed!\n"
    INIT_REG_VAL2     .FILL    x600D     ; DO NOT USE THIS LABEL/VALUE
    INIT_REG_VAL_NEG2 .FILL    #-24589   ; DO NOT USE THIS LABEL/VALUE
    DIVIDEBY2_N       .FILL    #196      ; DO NOT USE THIS LABEL/VALUE

TEST_DIVIDEBY2_END
; *************************************************************************

; ************************** TEST FOR COLLATZ_STEPS ***********************
    ; initialize the registers for checking callee saving
    LD R2, INIT_REG_VAL3
    LD R3, INIT_REG_VAL3
    LD R4, INIT_REG_VAL3
    LD R5, INIT_REG_VAL3
    LD R6, INIT_REG_VAL3

    ; print the message
    LEA R0, COLLATZ_STEPS_MSG
    PUTS

    AND R0, R0, #0
    LD R1, COLLATZ_STEPS_N  ; load operand from memory (= 1982)
    ADD R0, R0, R1          ; initialize the operand 
    JSR COLLATZ_STEPS       ; calculate & store the number of steps in R1
    AND R0, R1, R1          ; move the result of COLLATZ_STEPS: R1 -> R0
    JSR PRINT_INT           ; print the value in R0

    ; check if the original values in the registers are preserved
    LD R0, INIT_REG_VAL_NEG3
    ADD R2, R2, R0
    BRnp COLLATZ_STEPS_REG_SAVING_FAILED
    ADD R3, R3, R0
    BRnp COLLATZ_STEPS_REG_SAVING_FAILED
    ADD R4, R4, R0
    BRnp COLLATZ_STEPS_REG_SAVING_FAILED
    ADD R5, R5, R0
    BRnp COLLATZ_STEPS_REG_SAVING_FAILED
    ADD R6, R6, R0
    BRnp COLLATZ_STEPS_REG_SAVING_FAILED

    BRnzp TEST_COLLATZ_STEPS_END

COLLATZ_STEPS_REG_SAVING_FAILED
    LEA R0, COLLATZ_STEPS_REG_SAVING_MSG
    PUTS
    BRnzp TEST_COLLATZ_STEPS_END

    COLLATZ_STEPS_MSG .STRINGZ "\nSteps for reaching 1 from 1982 = "
    COLLATZ_STEPS_REG_SAVING_MSG .STRINGZ "\nCheck for callee saving failed!\n"
    INIT_REG_VAL3     .FILL    x600D     ; DO NOT USE THIS LABEL/VALUE
    INIT_REG_VAL_NEG3 .FILL    #-24589   ; DO NOT USE THIS LABEL/VALUE
    COLLATZ_STEPS_N   .FILL    #1982     ; DO NOT USE THIS LABEL/VALUE
TEST_COLLATZ_STEPS_END
; *************************************************************************

; ************************ USING COLLATZ **********************************
    LEA R0, COLLATZ_MSG
    PUTS

    LD R0, COLLATZ_N
    JSR COLLATZ

    BRnzp COLLATZ_EXEC_END

COLLATZ_N   .FILL    #15                 ; DO NOT USE THIS LABEL/VALUE
COLLATZ_MSG .STRINGZ "\nNumber of Collatz Steps for 15, 14, 13, ..., 1\n"
COLLATZ_EXEC_END
; *************************************************************************

TEST_END
    HALT                   ; stop the program execution

.END
