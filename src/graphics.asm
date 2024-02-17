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