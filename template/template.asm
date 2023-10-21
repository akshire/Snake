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
	call clear_leds
	
	addi a0, zero, 0x0000
	addi a1, zero, 0x0000
	
	call set_pixel
	
	addi a0, zero, 0x0001
	addi a1, zero, 0x0001
	
	call set_pixel
	
    ret
    ;ret


; BEGIN: clear_leds
clear_leds:
	stw zero, LEDS(zero)
	stw zero, 0x2004(zero)
	stw zero, 0x2008(zero)
	ret
; END: clear_leds


; BEGIN: set_pixel
set_pixel:
	addi t0, zero, 0x0003
	addi t1, zero, 0x0007
	addi t2, zero, 0x000b
	addi t5, zero, 0x0001
	add t6, zero, a0
	
	bge t0, a0, caseLed0
	bge t1, a0, caseLed1
	bge t2, a0, caseLed2
	
	
	caseLed0:
	
	addi t3, zero, 0x0000
	addi t4, zero, 0x0000
	beq a0, t3, done
	
	forLoop:
	
	
	addi t4, t4, 0x0008
	addi t3, t3, 0x0001
	
	bne a0, t3, forLoop
	
	done: sll t5, t5, t4
	sll t5, t5, a1
	
	ldw t7, 0x2000(t6)
	
	or t5, t5, t7
	
	stw t5, 0x2000(t6)
	
	jmpi finally
	
	caseLed1:
	addi t0, t0, 0x0001
	sub a0, a0, t0
	jmpi caseLed0
	
	
	caseLed2:
	addi t1, t1, 0x0001
	sub a0, a0, t1
	jmpi caseLed0
	
	

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

; END: get_input


; BEGIN: draw_array
draw_array:

; END: draw_array


; BEGIN: move_snake
move_snake:

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
