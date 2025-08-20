// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
//
// This program only needs to handle arguments that satisfy
// R0 >= 0, R1 >= 0, and R0*R1 < 32768.
//
// x = R0
// y = R1
// i = 0
// product = 0
// LOOP
//   if i == x: jump STOP
//   product += y
//   i++
//   jump LOOP
// STOP
//   R2 = product
// END

@R0
D=M
@x
M=D  // x = R0

@R1
D=M
@y
M=D  // y = R1

@i
M=0  // i = 0

@product
M=0  // product = 0

(LOOP)
@x
D=M
@i
D=D-M  // D = x - i

@STOP
D;JEQ  // jump STOP if i == x

@y
D=M
@product
M=D+M  // product += y

@i
M=M+1  // i++

@LOOP
0;JMP  // jump LOOP

(STOP)
@product
D=M
@R2
M=D  // R2 = product

(END)
@END
0;JMP

