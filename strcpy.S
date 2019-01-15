.globl my_strcpy

my_strcpy:
	std	3,-8(1)


	andi.	0,4,0x7
	beq	.Lcopy_dw  /* Check if address is aligned. */

/* Align the reading address. */
.Lalignment:
	lbz	0,0(4)
	cmpdi	cr7,0,0
	stb	0,0(3)
	beq	cr7,.Lexit
	addi	4,4,1
	addi	3,3,1
	andi.	0,4,0x7
	bne	.Lalignment

/* Copy by double word with aligned address. */
.Lcopy_dw:
	ld	0,0(4)
	xor	6,6,6
	cmpb	5,0,6
	cmpdi	cr7,5,0
	bne	cr7,.Lcheck_zero
	addi	3,3,-8
.Lcopy_dw_loop:
	stdu	0,8(3)
	ldu	0,8(4)
	cmpb	5,0,6
	cmpdi	cr7,5,0
	beq	cr7,.Lcopy_dw_loop

	addi	3,3,8   /* Fix r3 to use std instruction. */
/* Find where the zero is located. */
.Lcheck_zero:
	andi.	7, 0, 0x00ff
	beq	.Lfound_on_byte_0 /* NB: LSB0 notation. Power ISA uses MSB0 notation. */
	andi.   7, 0, 0xff00
	beq	.Lfound_on_byte_1
	andis.  7, 0, 0x00ff
	beq	.Lfound_on_byte_2
	andis.  7, 0, 0xff00
	beq	.Lfound_on_byte_3
	rldicr. 7, 0, 24, 7
	beq	.Lfound_on_byte_4
	rldicr. 7, 0, 16, 7
	beq	.Lfound_on_byte_5
	rldicr. 7, 0, 8 , 7
	beq	.Lfound_on_byte_6

	/***
	 * NUL char is on byte 7, hence store all
	 * bytes using 'std' including it.
	 */

	/***
	 * Copy all bytes from byte 0 to byte where NUL was found,
	 * including NUL.
	 */

.Lfound_on_byte_7:
	std	0, 0(3)
	b	.Lexit

.Lfound_on_byte_6:
	stw	0, 0(3)
	srdi	6, 0, 32
	sth	6, 4(3)
	srdi	6, 0, 40
	stb	6, 6(3)
	b	.Lexit

.Lfound_on_byte_5:
	stw	0, 0(3)
	srdi	6, 0, 32
	sth	6, 4(3)
	b	.Lexit

.Lfound_on_byte_4:
	stw	0, 0(3)
	srdi	6, 0, 32
	stb	6, 4(3)
	b	.Lexit

.Lfound_on_byte_3:
	stw	0, 0(3)
	b	.Lexit

.Lfound_on_byte_2:
	sth	0, 0(3)
	srdi	6, 0, 16
	stb	6, 2(3)
	b	.Lexit

.Lfound_on_byte_1:
	sth	0, 0(3)
	b	.Lexit

.Lfound_on_byte_0:
	stb	0, 0(3)
.Lexit:
	ld	3, -8(1)  /* Load destination address. */
	blr

.section .note.GNU-stack,"",%progbits
