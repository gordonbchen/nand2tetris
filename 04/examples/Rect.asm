// Rect.asm: draw a rectangle in the top left corner of the screen
// with height = RAM[0] and width = 16 pixels.
//
// height = RAM[0]
// i = 0
// addr = SCREEN
// LOOP
//   if i == height: jump END
//   RAM[addr] = -1             // -1 = (1111 1111 1111 1111)
//   addr += 32                 // move onto next row
//   i++
//   jump LOOP
// END

@R0
D=M
@height
M=D  // height = RAM[0]

@i
M=0  // i = 0

@SCREEN
D=A
@addr
M=D  // addr = SCREEN

(LOOP)
@height
D=M
@i
D=D-M  // D = height - i

@END
D;JEQ  // jump END if i == height

@addr
A=M
M=-1  // RAM[addr] = -1

@32
D=A
@addr
M=D+M  // addr += 32

@i
M=M+1  // i++

@LOOP
0;JMP  // jump LOOP

(END)
@END
0;JMP

