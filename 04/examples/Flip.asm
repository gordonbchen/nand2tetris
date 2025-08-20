// Flip.asm: flip RAM[0] and RAM[1]
@R0
D=M
@temp  // variables are assigned to unused register.
M=D    // temp = R0

@R1
D=M
@R0
M=D    // R0 = R1

@temp
D=M
@R1
M=D    // R1 = temp

(END)
@END
0;JMP

