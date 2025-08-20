// Signum.asm: R1 = 1 if R0 > 0 else 0
@R0
D=M

@POSITIVE  // label references are to line # after declaration
D;JGT

@1
M=0

@END
0;JMP

(POSITIVE)  // label declarations aren't real lines in ROM.
@1
M=1

(END)
@END
0;JMP

