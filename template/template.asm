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

; main
; arguments
;     none
;
; return values
;     This procedure should never return.
main:
    ; TODO: Finish this procedure.
	
	addi t0,zero,1
	
	stw HEAD_X,t0
	stw HEAD_Y, 0
	stw TAIL_X,zero
	stw TAIL_Y,zero
	stw TAIL_X,


; BEGIN: clear_leds
clear_leds:
	stw zero, LEDS(zero)
	stw zero, 0x2004(zero)
	stw zero, 0x2008(zero)
	ret
; END: clear_leds


; BEGIN: set_pixel
set_pixel:

	addi t5, zero, 0x0001
	slli t6, a0, 3
	add t6, t6, a1
	sll t5, t5, t6
	ldw t7, 0x2000(a0)
	or t5, t5, t7
	stw t5, LEDS(a0)

	finally: ret
	

; END: set_pixel


; BEGIN: display_score
display_score:

; END: display_score


; BEGIN: init_game
init_game:

; END: init_game


; BEGIN: create_food
create_food:

; END: create_food


; BEGIN: hit_test
hit_test:

; END: hit_test


; BEGIN: get_input
get_input:
	addi t2, zero, BUTTONS 
	addi t0, t2, 0x0004
	
	ldw t1, 0x0000(t0)
	
	
	addi t3, zero, 0x0010 ; 10000
	bge t1, t3, case_checkpoint
	
	srli t3, t3, 0x0001 ; 01000
	bge t1, t3, case_right
	
	srli t3, t3, 0x0001 ; 00100
	bge t1, t3, case_down
	
	srli t3, t3, 0x0001 ; 00010
	bge t1, t3, case_up
	
	srli t3, t3, 0x0001 ; 00001
	bge t1, t3, case_left
	
	bge t1, zero, true_case_nothing ; 00000
	
	case_checkpoint :
		addi t4, zero, BUTTON_CHECKPOINT
		add v0,t4,zero
		jmpi case_nothing
	
	case_right :
		addi t4, zero, BUTTON_LEFT
		beq v0,t4, case_nothing
		addi t5,zero,BUTTON_RIGHT
		add v0,t5,zero
		addi t4, v0, 0
		
		jmpi case_nothing
	
	
	case_down :
		addi t4, zero, BUTTON_UP
		beq v0,t4, case_nothing
		addi t5,zero,BUTTON_DOWN
		add v0,t5,zero
		
		
		
		
		jmpi case_nothing
	
	case_up :
		addi t4, zero, BUTTON_DOWN
		beq v0,t4, case_nothing
		addi t5,zero,BUTTON_UP
		add v0,t5,zero
		jmpi case_nothing
	
	case_left :
		addi t4, zero, BUTTON_RIGHT
		beq v0,t4, case_nothing
		addi t5,zero,BUTTON_LEFT
		add v0,t5,zero
		jmpi case_nothing
	
	case_nothing :

		ldw t6, HEAD_X(zero)
		ldw t7, HEAD_Y(zero)
		
		addi t5, zero, 0
		; FOR LOOP TO INCREASE
		forLoop_:
			beq t5, t6, done_forL
			addi t5, t5, 1 
			slli t4, t4, 8
			bne t5, t6, forLoop_ ; tant que  t5 != t6 (qui est = x)
		done_forL:
		
		ldw t3, GSA(t6)
		
		or t4, t4, t3
		
		stw t4, GSA(t6)
		stw zero, 0x0000(t0)

true_case_nothing:
		ret

; END: get_input


; BEGIN: draw_array
draw_array:

addi t0, zero, 0
addi t2, zero, 0 ; x
addi t3, zero, 0 ; y
addi t4, zero, 8
forCooking:
	
	

	
	ldw t1, GSA(t0)

	addi t5, zero, 0x0001
	slli t6, t2, 3
	add t6, t6, t3
	sll t5, t5, t6
	ldw t7, LEDS(t2)
	or t5, t5, t7
	stw t5, LEDS(t2)

	addi t0, t0, 1

	addi t3, t3, 1
	beq t3, t4, reset_y

	jmpi skip

	reset_y:
 
		addi t3, zero, 0
		addi t2, zero, 1; increment x

	skip:
	addi t5, zero, 96
	bne t1, t5 forCooking

	

; END: draw_array


; BEGIN: move_snake
move_snake:
	addi t0,zero,0
	beq v0,t0,move_none
	addi t0,zero,1
	beq v0,t0,move_left
	addi t0,zero,2
	beq v0,t0,move_up
	addi t0,zero,3
	beq v0,t0,move_down
	addi t0,zero,4
	beq v0,t0,move_right
	addi t0,zero,5
	beq v0,t0,move_cp
	
	
	move_none:
	
	move_left:
	ldw t1, HEAD_X(zero)
	addi t2, zero, 1
	sub t1, t1, t2
	stw t1, HEAD_X(zero)
	
	jmpi move_tail
	
	
	
	
	
	move_up:
	ldw t1, HEAD_Y(zero)
	addi t2, zero, 1
	sub t1, t1, t2
	stw t1, HEAD_Y(zero)
	jmpi move_tail
	
	move_down:
	
	ldw t1, HEAD_Y(zero)
	addi t1, t1, 1
	stw t1, HEAD_Y(zero)
	jmpi move_tail
	
	
	
	move_right:
	ldw t1, HEAD_X(zero)
	addi t1, t1, 1
	stw t1, HEAD_X(zero)
	
	jmpi move_tail

	move_cp:
	jmpi move_tail
	
	
	move_tail:
		bne a0,zero, tail_does_not_move
		ldw t2, TAIL_X(zero)
		ldw t1, TAIL_Y(zero)
		
		addi t3, zero, 0
	
		slli t2, t2, 3
		add t3, t2, t1
		ldw t4, GSA(t3) ; direction


		addi t0,zero,0
		beq t4,t0,tail_does_not_move
		addi t0,zero,1
		beq t4,t0,move_left_tail
		addi t0,zero,2
		beq t4,t0,move_up_tail
		addi t0,zero,3
		beq t4,t0,move_down_tail
		addi t0,zero,4
		beq t4,t0,move_right_tail
		addi t0,zero,5
		beq t4,t0,tail_does_not_move ; pas sur




	move_left_tail:
		ldw t1, TAIL_X(zero)
		addi t2, zero, 1
		sub t1, t1, t2
		stw t1, TAIL_X(zero)
 	 jmpi tail_does_not_move

	move_right_tail:
		
		ldw t1, TAIL_X(zero)
		addi t1, t1, 1
		stw t1, TAIL_X(zero)
 	 jmpi tail_does_not_move
	
	move_down_tail:

		ldw t1, TAIL_Y(zero)
		addi t1, t1, 1
		stw t1, TAIL_Y(zero)
 	 jmpi tail_does_not_move

	move_up_tail:
		ldw t1, TAIL_Y(zero)
		addi t2, zero, 1
		sub t1, t1, t2
		stw t1, TAIL_Y(zero)
 	 jmpi tail_does_not_move
	
			
	
	tail_does_not_move:
	ret

; END: move_snake


; BEGIN: save_checkpoint
save_checkpoint:

; END: save_checkpoint


; BEGIN: restore_checkpoint
restore_checkpoint:

; END: restore_checkpoint


; BEGIN: blink_score
blink_score:

; END: blink_score
