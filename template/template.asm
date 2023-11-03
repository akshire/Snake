;	set game state memory location
.equ    HEAD_X,         0x1000  ; Snake head's position on x
.equ    HEAD_Y,         0x1004  ; Snake head's position on y
.equ    TAIL_X,         0x1008  ; Snake tail's position on x
.equ    TAIL_Y,         0x100C  ; Snake tail's position on Y
.equ    SCORE,          0x1010  ; Score address
.equ    GSA,            0x1014  ; Game state array address

.equ    CP_VALID,       0x1200  ; Whether the checkpoint is valid.
.equ    CP_HEAD_X,      0x1204  ; Snake head's X coordinate. (Checkpoint)
.equ    CP_HEAD_Y,      0x1208  ; Snake head's Y coordinate. (Checkpoint)
.equ    CP_TAIL_X,      0x120C  ; Snake tail's X coordinate. (Checkpoint)
.equ    CP_TAIL_Y,      0x1210  ; Snake tail's Y coordinate. (Checkpoint)
.equ    CP_SCORE,       0x1214  ; Score. (Checkpoint)
.equ    CP_GSA,         0x1218  ; GSA. (Checkpoint)

.equ    LEDS,           0x2000  ; LED address
.equ    SEVEN_SEGS,     0x1198  ; 7-segment display addresses
.equ    RANDOM_NUM,     0x2010  ; Random number generator address
.equ    BUTTONS,        0x2030  ; Buttons addresses

; button state
.equ    BUTTON_NONE,    0
.equ    BUTTON_LEFT,    1
.equ    BUTTON_UP,      2
.equ    BUTTON_DOWN,    3
.equ    BUTTON_RIGHT,   4
.equ    BUTTON_CHECKPOINT,    5

; array state
.equ    DIR_LEFT,       1       ; leftward direction
.equ    DIR_UP,         2       ; upward direction
.equ    DIR_DOWN,       3       ; downward direction
.equ    DIR_RIGHT,      4       ; rightward direction
.equ    FOOD,           5       ; food

; constants
.equ    NB_ROWS,        8       ; number of rows
.equ    NB_COLS,        12      ; number of columns
.equ    NB_CELLS,       96      ; number of cells in GSA
.equ    RET_ATE_FOOD,   1       ; return value for hit_test when food was eaten
.equ    RET_COLLISION,  2       ; return value for hit_test when a collision was detected
.equ    ARG_HUNGRY,     0       ; a0 argument for move_snake when food wasn't eaten
.equ    ARG_FED,        1       ; a0 argument for move_snake when food was eaten

; initialize stack pointer
addi    sp, zero, LEDS
;-----------------------------------------------------------------------------------------
; main
; arguments
;     none
;
; return values
;     This procedure should never return.
main:
    ; TODO: Finish this procedure.
	
	addi a0,zero,0
	addi a1,zero,0 
	addi t0, zero, BUTTON_DOWN
	stw t0, 0x1014(zero)
	

	stw zero, HEAD_X(zero)
	stw zero, HEAD_Y(zero)
	stw zero, TAIL_X(zero)
	stw zero, TAIL_Y(zero)
	call draw_array

	infinite_loop_main:
		call clear_leds
		call get_input
		call move_snake
		call draw_array
		jmpi infinite_loop_main

;-----------------------------------------------------------------------------------------
; BEGIN: clear_leds
; arguments
;     None
;
; return values
;     None
;
clear_leds:
	stw zero, LEDS(zero)
	stw zero, 0x2004(zero)
	stw zero, 0x2008(zero)
	ret
; END: clear_leds


; BEGIN: set_pixel
; arguments
;     a0 <- pixel's x-coordinate
;	  a1 <- pixel's y-coordinate
;
; return values
;     None
set_pixel:

	addi t5, zero, 0x0001
	slli t6, a0, 3
	add t6, t6, a1
	sll t5, t5, t6
	ldw t7, 0x2000(a0)
	or t5, t5, t7
	stw t5, LEDS(a0)

	finally : ret
; END: set_pixel

;-----------------------------------------------------------------------------------------

; BEGIN: display_score
display_score:

; END: display_score

;-----------------------------------------------------------------------------------------

; BEGIN: init_game
init_game:

; END: init_game

;-----------------------------------------------------------------------------------------

; BEGIN: create_food
create_food:
	search_valid_position_create_food:
		; search in the stack
		ldw t0, RANDOM_NUM(zero)
		; isolate the first byte
		andi t1, t0, 0xFF
		; compare if value > 96
		addi t2, zero, 96
		bge t1,t2,search_valid_position_create_food
		; loading the GSA location
		ldw t3, GSA(t1)

		addi t4, zero, 1
		beq t3,t4, search_valid_position_create_food
		addi t4, t4, 1
		beq t3,t4, search_valid_position_create_food
		addi t4, t4, 1
		beq t3,t4, search_valid_position_create_food
		addi t4, t4, 1
		beq t3,t4, search_valid_position_create_food

		addi t5 , zero, 5
		stw t5, GSA(t1)

; END: create_food

;-----------------------------------------------------------------------------------------

; BEGIN: hit_test
hit_test:

; END: hit_test

;-----------------------------------------------------------------------------------------

; BEGIN: get_input
; arguments
;     none
;
; return values
;     v0 <- Direction of the Head
get_input:
	; Getting the Values Buttons and Buttons + 4
	addi t0, zero, 0x0004
	; Buttons + 4
	ldw t1, BUTTONS(t0)
	; checking which Button was pressed with priority to checkpoint
	addi t3, zero, 0x0010 ; 10000
	bge t1, t3, case_checkpoint
; ---------------------------------------------------------
	; Loading the Head_x and Head_y
		ldw t6, HEAD_X(zero)
		ldw t7, HEAD_Y(zero)
		addi t5,zero,0 ; address counter
		slli t0, t6,5 ; x in address
		slli t2,t7,2; y counter
		add t5, t0, t2
		; loading the direction
		ldw t6, GSA(t5); old direction
;----------------------------------------------

	; increase comparing value by shifting
	srli t3, t3, 0x0001 ; 01000
	bge t1, t3, case_right
	
	srli t3, t3, 0x0001 ; 00100
	bge t1, t3, case_down
	
	srli t3, t3, 0x0001 ; 00010
	bge t1, t3, case_up
	
	srli t3, t3, 0x0001 ; 00001
	bge t1, t3, case_left
	
	bge t1, zero, case_nothing ; 00000

	; Different cases for the buttons
	case_checkpoint :
		addi v0,zero,BUTTON_CHECKPOINT
		jmpi get_input_done
	

	case_right :
		; setting v0
		addi v0, zero, BUTTON_RIGHT
		; Check if the old direction(t6 is the old direction) is opposite of pressed
		addi t4, zero, BUTTON_LEFT
		beq t6,t4, get_input_done
		stw v0, GSA(t5)
		jmpi get_input_done
	
	
	case_down :
		; setting v0
		addi v0, zero, BUTTON_DOWN
		; Check if the old direction(t6 is the old direction) is opposite of pressed
		addi t4, zero, BUTTON_UP
		beq t6,t4, get_input_done
		stw v0, GSA(t5)
		jmpi get_input_done
	

	case_up :
			; setting v0
		addi v0, zero, BUTTON_UP
		; Check if the old direction(t6 is the old direction) is opposite of pressed
		addi t4, zero, BUTTON_DOWN
		beq t6,t4, get_input_done
		stw v0, GSA(t5)
		jmpi get_input_done

	
	case_left :
			; setting v0
		addi v0, zero, BUTTON_LEFT
		; Check if the old direction(t6 is the old direction) is opposite of pressed
		addi t4, zero, BUTTON_RIGHT
		beq t6,t4, get_input_done
		stw v0, GSA(t5)
		jmpi get_input_done

	
	case_nothing :
		addi v0, zero, BUTTON_NONE
get_input_done:
		ret
; END: get_input

;-----------------------------------------------------------------------------------------

; BEGIN: draw_array
; arguments
;     None
;
; return values
;     None
draw_array:

	addi t0, zero, 0
	addi t2, zero, 0 ; x
	addi t3, zero, 0 ; y
	addi t4, zero, 7

	for_loop_draw_array:

		; a verifier : les x et y dans la loop, et le stw t5 LEDS(t2) 
		; probablement remplacer ca par mettre les bonnes valeurs a0 et a1 puis call set_pixel


		ldw t1, GSA(t0)
		addi t5, zero, 0x0001
		slli t6, t2, 3
		add t6, t6, t3
		sll t5, t5, t6
		
		beq t1, zero, dont_draw
		
		add a0, zero, t2 ;x
		add a1, zero, t3 ;y
	
		addi sp, sp, -36
		stw t0, 0(sp)
		stw t1, 4(sp)
		stw t2, 8(sp)
		stw t3, 12(sp)
		stw t4, 16(sp)
		stw t5, 20(sp)
		stw t6, 24(sp)
		stw t7, 28(sp)
		stw ra, 32(sp)
		
		call set_pixel

		
		ldw t0, 0(sp)
		ldw t1, 4(sp)
		ldw t2, 8(sp)
		ldw t3, 12(sp)
		ldw t4, 16(sp)
		ldw t5, 20(sp)
		ldw t6, 24(sp)
		ldw t7, 28(sp)
		ldw ra, 32(sp)

		addi sp, sp, 36

		

		dont_draw:

		addi t0, t0, 4
		addi t3, t3, 1
		beq t3, t4, reset_y
		jmpi skip

	reset_y:
		addi t3, zero, 0
		addi t2, zero, 1; increment x

	skip:
		addi t5, zero, 32
		bne t0, t5, for_loop_draw_array
		ret
; END: draw_array

;-----------------------------------------------------------------------------------------

; BEGIN: move_snake
; arguments
;     a0 <- = 1 if the snake�s head collides with the food, else 0
;
; return values
;     None
move_snake:
	; Loading the Head_x and Head_y
		ldw t6, HEAD_X(zero)
		ldw t7, HEAD_Y(zero)
		addi t5,zero,0 ; address counter
		slli t0, t6,5 ; x counter
		slli t2,t7,2; y counter
		add t5, t0,t2

	
		ldw t6, GSA(t5); old direction


	addi t0,zero,BUTTON_LEFT
	beq t6,t0,move_left
	addi t0,zero,BUTTON_UP
	beq t6,t0,move_up
	addi t0,zero,BUTTON_DOWN
	beq t6,t0,move_down
	addi t0,zero,BUTTON_RIGHT
	beq t6,t0,move_right
	

	move_left:
		; updating HEAD_X
		ldw t1, HEAD_X(zero)
		addi t2, zero, 1
		sub t1, t1, t2
		stw t1, HEAD_X(zero)
		; updating the direction
		addi t0,zero,32
		sub t5,t5,t0
		addi t0,zero,BUTTON_LEFT
		stw t0, GSA(t5)
		jmpi move_tail


	
	move_up:
		; updating HEAD_Y
		ldw t1, HEAD_Y(zero)
		addi t2, zero, 1
		sub t1, t1, t2
		stw t1, HEAD_Y(zero)
		; updating the direction
		addi t0,zero,4
		sub t5,t5,t0
		addi t0,zero,BUTTON_UP
		stw t0, GSA(t5)
		jmpi move_tail
	

	move_down:
		; updating HEAD_Y
		ldw t1, HEAD_Y(zero)
		addi t1, t1, 1
		stw t1, HEAD_Y(zero)
		; updating direction
		addi t5,t5,4
		addi t0,zero,BUTTON_DOWN
		stw t0, GSA(t5)
		jmpi move_tail
	
	
	
	move_right:
		; updating HEAD_X
		ldw t1, HEAD_X(zero)
		addi t1, t1, 1
		stw t1, HEAD_X(zero)
		; updating direction
		addi t5,t5,32
		addi t0,zero,BUTTON_RIGHT
		stw t0, GSA(t5)
		jmpi move_tail

	
	
	move_tail:
		; Getting the tail coordinates
		bne a0,zero, tail_does_not_move

		ldw t2, TAIL_X(zero)		
		ldw t1, TAIL_Y(zero)
	
		slli t1, t1, 2; adress y
		slli t2,t2,5; address x
		
		add t3, t2, t1
		ldw t4, GSA(t3) ; direction


		
		addi t0,zero,BUTTON_LEFT
		beq t4,t0,move_left_tail
		addi t0,zero,BUTTON_UP
		beq t4,t0,move_up_tail
		addi t0,zero,BUTTON_DOWN
		beq t4,t0,move_down_tail
		addi t0,zero,BUTTON_RIGHT
		beq t4,t0,move_right_tail


		move_left_tail:

			stw zero, GSA(t3)

			ldw t1, TAIL_X(zero)
			addi t2, zero, 1
			sub t1, t1, t2
			stw t1, TAIL_X(zero)
 		 	jmpi move_tail_done


		move_right_tail:
			stw zero, GSA(t3)


			ldw t1, TAIL_X(zero)
			addi t1, t1, 1
			stw t1, TAIL_X(zero)
 		 	jmpi move_tail_done
	

		move_down_tail:
			stw zero, GSA(t3)

			ldw t1, TAIL_Y(zero)
			addi t1, t1, 1
			stw t1, TAIL_Y(zero)
			jmpi move_tail_done


		move_up_tail:
			stw zero, GSA(t3)

			ldw t1, TAIL_Y(zero)
			addi t2, zero, 1
			sub t1, t1, t2
			stw t1, TAIL_Y(zero)
 			jmpi move_tail_done
	
			
		
		tail_does_not_move:
		move_tail_done:
			ret

; END: move_snake

;-----------------------------------------------------------------------------------------

; BEGIN: save_checkpoint
save_checkpoint:

; END: save_checkpoint

;-----------------------------------------------------------------------------------------

; BEGIN: restore_checkpoint
restore_checkpoint:

; END: restore_checkpoint

;-----------------------------------------------------------------------------------------

; BEGIN: blink_score
blink_score:

; END: blink_score
