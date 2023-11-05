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
start:
call clear_leds

addi t0, zero, 10000
wait_procedure_5:
addi t0,t0,-1
bne t0,zero,wait_procedure_5

addi t0, zero, 10000
wait_procedure:
addi t0,t0,-1
bne t0,zero,wait_procedure

addi t0,zero,0
addi t1,zero,96
addi t2, zero,1

for_loop_gsa:
	slli t3,t0,2
	stw t2,GSA(t3)
	addi t0,t0,1
	bne t1,t0,for_loop_gsa
call draw_array

addi t0, zero, 10000
wait_procedure_2:
addi t0,t0,-1
bne t0,zero,wait_procedure_2

addi t0, zero, 10000
wait_procedure_3:
addi t0,t0,-1
bne t0,zero,wait_procedure_3

addi t0, zero, 10000
wait_procedure_4:
addi t0,t0,-1
bne t0,zero,wait_procedure_4

jmpi start




ret
;-----------------------------------------------------------------------------------------
; BEGIN: clear_leds
; arguments
;     None
;
; return values
;     None
;
clear_leds:
	stw zero, LEDS+0(zero)
	stw zero, LEDS+4(zero)
	stw zero, LEDS+8(zero)
	ret
; END: clear_leds
;-----------------------------------------------------------------------------------------
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

	ldw t0, digit_map(zero)
	stw t0, SEVEN_SEGS(zero)
	stw t0, SEVEN_SEGS+4(zero)
	ldw t1, SCORE(zero)
	bne t1, zero, NOT_ZERO
	stw t0, SEVEN_SEGS+8(zero)
	stw t0, SEVEN_SEGS+12(zero)
	jmpi end_display_score

	NOT_ZERO:
	addi t3, zero, 0 ;TENTH
	addi t2, zero, 9
	
	loop_display_score:
	bge t2, t1, unit
	addi t1, t1, -10
	addi t3, t3, 10 ; tenth 
	jmpi loop_display_score

unit:
	beq t1, t2, UNIT_NINE ;t2 = 9
	addi t2, t2, -1
	beq t1, t2, UNIT_EIGHT ;t2 = 8
	addi t2, t2, -1
	beq t1, t2, UNIT_SEVEN ;t2 = 7
	addi t2, t2, -1
	beq t1, t2, UNIT_SIX ;t2 = 6
	addi t2, t2, -1
	beq t1, t2, UNIT_FIVE ;t2 = 5
	addi t2, t2, -1
	beq t1, t2, UNIT_FOUR ;t2 = 4
	addi t2, t2, -1
	beq t1, t2, UNIT_THREE ;t2 = 3
	addi t2, t2, -1
	beq t1, t2, UNIT_TWO ;t2 = 2
	addi t2, t2, -1
	beq t1, t2, UNIT_ONE ;t2 = 1
	jmpi UNIT_ZERO

UNIT_NINE:
	ldw t0, digit_map+36(zero)
	stw t0, SEVEN_SEGS+12(zero); SEVEN_SEGS[3]
jmpi TENTH

UNIT_EIGHT:
	ldw t0, digit_map+32(zero)
	stw t0, SEVEN_SEGS+12(zero)
jmpi TENTH

UNIT_SEVEN:
	ldw t0, digit_map+28(zero)
	stw t0, SEVEN_SEGS+12(zero)
jmpi TENTH

UNIT_SIX:
	ldw t0, digit_map+24(zero)
	stw t0, SEVEN_SEGS+12(zero)
jmpi TENTH

UNIT_FIVE:
	ldw t0, digit_map+20(zero)
	stw t0, SEVEN_SEGS+12(zero)
jmpi TENTH

UNIT_FOUR:
	ldw t0, digit_map+16(zero)
	stw t0, SEVEN_SEGS+12(zero)
jmpi TENTH

UNIT_THREE:
	ldw t0, digit_map+12(zero)
	stw t0, SEVEN_SEGS+12(zero)
jmpi TENTH

UNIT_TWO:
	ldw t0, digit_map+8(zero)
	stw t0, SEVEN_SEGS+12(zero)
jmpi TENTH
 
UNIT_ONE:
	ldw t0, digit_map+4(zero)
	stw t0, SEVEN_SEGS+12(zero)
jmpi TENTH

UNIT_ZERO: ;already done before the loop but just in case
	ldw t0, digit_map(zero)
	stw t0, SEVEN_SEGS+12(zero)
jmpi TENTH
 
TENTH:
	addi t2, zero, 90
	beq t3, t2, TENTH_NINE ;t2 = 90
	addi t2, t2, -10
	beq t3, t2, TENTH_EIGHT ;t2 = 80
	addi t2, t2, -10
	beq t3, t2, TENTH_SEVEN ;t2 = 70
	addi t2, t2, -10
	beq t3, t2, TENTH_SIX ;t2 = 60
	addi t2, t2, -10
	beq t3, t2, TENTH_FIVE ;t2 = 50
	addi t2, t2, -10
	beq t3, t2, TENTH_FOUR ;t2 = 40
	addi t2, t2, -10
	beq t3, t2, TENTH_THREE ;t2 = 30
	addi t2, t2, -10
	beq t3, t2, TENTH_TWO ;t2 = 20
	addi t2, t2, -10
	beq t3, t2, TENTH_ONE ;t2 = 10
	jmpi TENTH_ZERO

TENTH_NINE:
	ldw t0, digit_map+36(zero)
	stw t0, SEVEN_SEGS+8(zero) ;SEVEN_SEGS[2]
jmpi end_display_score

TENTH_EIGHT:
	ldw t0, digit_map+32(zero)
	stw t0, SEVEN_SEGS+8(zero) ;SEVEN_SEGS[2]
jmpi end_display_score

TENTH_SEVEN:
	ldw t0, digit_map+28(zero)
	stw t0, SEVEN_SEGS+8(zero) ;SEVEN_SEGS[2]
jmpi end_display_score

TENTH_SIX:
	ldw t0, digit_map+24(zero)
	stw t0, SEVEN_SEGS+8(zero) ;SEVEN_SEGS[2]
jmpi end_display_score

TENTH_FIVE:
	ldw t0, digit_map+20(zero)
	stw t0, SEVEN_SEGS+8(zero) ;SEVEN_SEGS[2]
jmpi end_display_score

TENTH_FOUR:
	ldw t0, digit_map+16(zero)
	stw t0, SEVEN_SEGS+8(zero) ;SEVEN_SEGS[2]
jmpi end_display_score

TENTH_THREE:
	ldw t0, digit_map+12(zero)
	stw t0, SEVEN_SEGS+8(zero) ;SEVEN_SEGS[2]
jmpi end_display_score

TENTH_TWO:
	ldw t0, digit_map+8(zero)
	stw t0, SEVEN_SEGS+8(zero) ;SEVEN_SEGS[2]
jmpi end_display_score

TENTH_ONE:
	ldw t0, digit_map+4(zero)
	stw t0, SEVEN_SEGS+8(zero) ;SEVEN_SEGS[2]
jmpi end_display_score

TENTH_ZERO: ;again probably useless
	ldw t0, digit_map(zero)
	stw t0, SEVEN_SEGS+8(zero) ;SEVEN_SEGS[2]
jmpi end_display_score

end_display_score:
ret
; END: display_score
;-----------------------------------------------------------------------------------------
; BEGIN: init_game
init_game:
	call clear_leds
	stw zero, HEAD_X(zero)
	stw zero, HEAD_Y(zero)
	stw zero, TAIL_X(zero)
	stw zero, TAIL_Y(zero)
	stw zero, SCORE(zero)
	addi t0, zero, DIR_RIGHT
	stw t0, GSA(zero)
	call display_score
	addi t1, zero, 0
	addi t2, zero, 95

	init_game_loop_reset_GSA:
	addi t1,t1,1
	slli t3,t1,2
	stw zero, GSA(t3)
	bne t1, t2, init_game_loop_reset_GSA
	call create_food
	call draw_array
	ret
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
		addi t2, zero, NB_CELLS
		bge t1,t2,search_valid_position_create_food
		; loading the GSA location
		slli t1, t1, 2
		ldw t3, GSA(t1)
		; comparisons
		addi t4, zero, 1
		beq t3,t4, search_valid_position_create_food
		addi t4, t4, 1
		beq t3,t4, search_valid_position_create_food
		addi t4, t4, 1
		beq t3,t4, search_valid_position_create_food
		addi t4, t4, 1
		beq t3,t4, search_valid_position_create_food
		; storing the food in the position
		addi t5 , zero, 5
		stw t5, GSA(t1)
		ret
; END: create_food
;-----------------------------------------------------------------------------------------
; BEGIN: hit_test
hit_test:
	; getting the address of the head in GSA
	ldw t0, HEAD_X(zero)
	ldw t1, HEAD_Y(zero)
	slli t2,t0,5
	slli t3,t1,2
	; getting the direction
	add t4,t2,t3 ; address in the GSA
	ldw t5,GSA(t4) ; direction
	; searching where we re gonna move
	addi t2, zero, DIR_LEFT
	beq t5,t2,hit_test_left
	addi t2, zero, DIR_UP
	beq t5,t2,hit_test_up
	addi t2, zero, DIR_DOWN
	beq t5,t2,hit_test_down
	addi t2, zero, DIR_RIGHT
	beq t5,t2,hit_test_right

	hit_test_left:
		beq t0,zero,hit_test_hit_screen_boundary
		addi t4,t4,-32
		ldw t2,GSA(t4) ; what is on the left
		addi t6, zero,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_food

	hit_test_up:
		beq t1,zero,hit_test_hit_screen_boundary
		addi t4,t4,-4
		ldw t2,GSA(t4) ; what is on the top
		addi t6, zero,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_food
		jmpi hit_test_no_collision

	hit_test_down:
		addi t7, zero, 7
		beq t1,t7,hit_test_hit_screen_boundary
		addi t4,t4,4
		ldw t2,GSA(t4) ; what is on the bottom
		addi t6, zero,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_food
		jmpi hit_test_no_collision

	hit_test_right:
		addi t7, zero, 11
		beq t0,t7,hit_test_hit_screen_boundary
		addi t4,t4,32
		ldw t2,GSA(t4) ; what is on the right
		addi t6, zero,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_snake
		addi t6, t6,1
		beq t2,t6,hit_test_hit_food
		jmpi hit_test_no_collision

	hit_test_hit_screen_boundary:
		addi v0,zero, 2
		jmpi hit_test_done

	hit_test_hit_snake:
		addi v0,zero, 2
		jmpi hit_test_done

	hit_test_hit_food:
		addi v0,zero, 1
		addi a0, zero, 1
		jmpi hit_test_done

	hit_test_no_collision:
		addi v0,zero, 0

	hit_test_done:
		ret
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

	addi t0, zero, 0 ; total counter
	addi t2, zero, 0 ; x
	addi t3, zero, 0 ; y
	addi t4, zero, NB_ROWS

	for_loop_draw_array:
		slli t5,t0,2
		ldw t1, GSA(t5)
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
		addi t0, t0, 1
		addi t3, t3, 1
		beq t3, t4, reset_y
		jmpi skip

	reset_y:
		addi t3, zero, 0 ; increment y
		addi t2, t2, 1; increment x
		

	skip:
		addi t5, zero, NB_CELLS ;96
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
	; searching for the good direction
	addi t0,zero,DIR_LEFT
	beq t6,t0,move_left
	addi t0,zero,DIR_UP
	beq t6,t0,move_up
	addi t0,zero,DIR_DOWN
	beq t6,t0,move_down
	addi t0,zero,DIR_RIGHT
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
		addi t0,zero,DIR_LEFT
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
		addi t0,zero,DIR_UP
		stw t0, GSA(t5)
		jmpi move_tail
	
	move_down:
		; updating HEAD_Y
		ldw t1, HEAD_Y(zero)
		addi t1, t1, 1
		stw t1, HEAD_Y(zero)
		; updating direction
		addi t5,t5,4
		addi t0,zero,DIR_DOWN
		stw t0, GSA(t5)
		jmpi move_tail
	
	move_right:
		; updating HEAD_X
		ldw t1, HEAD_X(zero)
		addi t1, t1, 1
		stw t1, HEAD_X(zero)
		; updating direction
		addi t5,t5,32
		addi t0,zero,DIR_RIGHT
		stw t0, GSA(t5)
		jmpi move_tail

	
	
	move_tail:
		; Getting the tail coordinates
		bne a0,zero, move_tail_done
		ldw t2, TAIL_X(zero)		
		ldw t1, TAIL_Y(zero)
		slli t1, t1, 2; adress y
		slli t2,t2,5; address x
		add t3, t2, t1
		ldw t4, GSA(t3) ; direction
		; check for direction
		addi t0,zero,DIR_LEFT
		beq t4,t0,move_left_tail
		addi t0,zero,DIR_UP
		beq t4,t0,move_up_tail
		addi t0,zero,DIR_DOWN
		beq t4,t0,move_down_tail
		addi t0,zero,DIR_RIGHT
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
	ldw t0, SEVEN_SEGS(zero)
	ldw t1, SEVEN_SEGS+4(zero)
	ldw t2, SEVEN_SEGS+8(zero)
	ldw t3, SEVEN_SEGS+12(zero)
	addi t4, zero, 0
	addi t5, zero, 50

	Loop_blink:
	stw zero, SEVEN_SEGS(zero)
	stw zero, SEVEN_SEGS+4(zero)
	stw zero, SEVEN_SEGS+8(zero)
	stw zero, SEVEN_SEGS+12(zero)
	call wait_blink_score
	stw t0, SEVEN_SEGS(zero)
	stw t1, SEVEN_SEGS+4(zero)
	stw t2, SEVEN_SEGS+8(zero)
	stw t3, SEVEN_SEGS+12(zero)
	addi t4, t4, 1
	bne t4, t5, Loop_blink
ret
wait_blink_score:
	addi t7, zero,-1
	addi t6, zero, 1000
	loop_wait:
	addi t7, t7, 1
	bne t7, t6, loop_wait
ret
; END: blink_score
digit_map:
.word 0xFC ; 0
.word 0x60 ; 1
.word 0xDA ; 2
.word 0xF2 ; 3
.word 0x66 ; 4
.word 0xB6 ; 5
.word 0xBE ; 6
.word 0xE0 ; 7
.word 0xFE ; 8
.word 0xF6 ; 9