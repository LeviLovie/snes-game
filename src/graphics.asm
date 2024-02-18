clear_tilemap:
	ldx #VRAM_BG1
	stx VMADDL
	ldx #0
@clear_loop:
	sta VMDATAL
	stz VMDATAH
	inx
	cpx #32*32
	bne @clear_loop

	lda #%00000001
	sta NMITIMEN

	rts