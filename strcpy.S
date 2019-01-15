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
	rldicr.	5,0,0,7
	beq	.Lfound_on_byte_1
	rldicr.	7,0,8,7
	beq	.Lfound_on_byte_2
	rldicr.	7,0,16,7
	beq	.Lfound_on_byte_3
	rldicr.	7,0,24,7
	beq	.Lfound_on_byte_4
	andis.	7,0,0xff00
	beq	.Lfound_on_byte_5
	andis.	7,0,0xff
	beq	.Lfound_on_byte_6
	andi.	7,0,0xff00
	beq	.Lfound_on_byte_7

/* Treatment of each byte where the zero my be found, saving
   the correct register data. */
.Lfound_on_byte_8:
	std	0,0(3)
	b	.Lexit

.Lfound_on_byte_7:
	srdi	6,0,32
	stw	6,0(3)
	srdi	6,0,16
	sth	6,4(3)
	srdi	6,0,8
	stb	6,6(3)
	b	.Lexit

.Lfound_on_byte_6:
	srdi	6,0,32
	stw	6,0(3)
	srdi	6,0,16
	sth	6,4(3)
	b	.Lexit

.Lfound_on_byte_5:
	srdi	6,0,32
	stw	6,0(3)
	srdi	6,0,24
	stb	6,4(3)
	b	.Lexit

.Lfound_on_byte_4:
	srdi	6,0,32
	stw	6,0(3)
	b	.Lexit

.Lfound_on_byte_3:
	srdi	6,0,48
	sth	6,0(3)
	srdi	6,0,40
	stb	6,2(3)
	b	.Lexit

.Lfound_on_byte_2:
	srdi	6,0,48
	sth	6,0(3)
	b	.Lexit

.Lfound_on_byte_1:
	srdi	6,0,56
	stb	6,0(3)
.Lexit:
	xor	0,0,0   /* Erase data from register 0. */
	ld	3,-8(1) /* Load destination address. */
	blr
	
.section .note.GNU-stack,"",%progbits
