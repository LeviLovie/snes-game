.p816
.smart

.include "macros.inc"
.include "registers.inc"

.include "header.asm"

.segment "CODE"

VRAM_CHARS = $0000
VRAM_BG1   = $1000

PLAYER_X = $0000
PLAYER_Y = $0002

start:
	.include "init.asm"

	setA16
	lda #$001
	sta PLAYER_X
	sta PLAYER_Y
	setA8

	; Set up the color palette
	stz CGADD
	; Color 0 = black
	lda #$00
	sta CGDATA
	lda #$00
	sta CGDATA
	; Color 1 = red
	lda #$1f
	sta CGDATA
	lda #$00
	sta CGDATA
	; Color 2 = blue
	lda #$e0
	sta CGDATA
	lda #$03
	sta CGDATA
	; Color 3 = green
	lda #$00
	sta CGDATA
	lda #$7c
	sta CGDATA

	; Set Graphics Mode 0, 8x8 tiles
	stz BGMODE

	; Set BG1 and tile map and character data
	lda #>VRAM_BG1
	sta BG1SC
	lda #VRAM_CHARS
	sta BG12NBA

	; Load character data into VRAM
	lda #$80
	sta VMAIN
	ldx #VRAM_CHARS
	stx VMADDL
	ldx #0
@charset_loop:
	lda charset,x
	sta VMDATAL
	inx
	lda charset,x
	sta VMDATAH
	inx
	cpx #(charset_end - charset)
	bne @charset_loop

	; Clear the tile map
	ldx #VRAM_BG1
	stx VMADDL
	ldx #0
@clear_loop:
	sta VMDATAL
	stz VMDATAH
	inx
	cpx #32*32
	bne @clear_loop

@draw_player:
	; Write a tile to position (1, 1)
	; (VRAM_BG1 + (PLAYER_Y * 32) + PLAYER_X)
	ldy #$00
	setA16
	lda #$0000
	lda PLAYER_Y
	; Multiply Y by 32
	asl
	asl
	asl
	asl
	asl
	adc #VRAM_BG1
	adc PLAYER_X
	tax
	lda #$0000
	setA8
	; ldx #(VRAM_BG1 + (2 * 32) + 2)
	stx VMADDL
	lda #$01 ; tile number
	sta VMDATAL
	stz VMDATAH

	; Show BG1
	lda #%00000001
	sta TM

	lda #$0f
	sta INIDISP

mainloop:
	lda JOY1H
	bit #%00000100 ; Down button
	beq @down_not_pressed
	inc PLAYER_Y
	@down_not_pressed:

	bra mainloop

nmi:
	bit RDNMI
_rti:
	rti

.include "charset.asm"