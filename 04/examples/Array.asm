// Set first RAM[1] = n values of array starting at RAM[0] = arr to -1.
//
// arr = RAM[0]
// n = RAM[1]
// i = 0
// LOOP
//   if i == n: jump END
//   RAM[arr + i] = -1
//   i++
//   jump LOOP
// END

@R0
D=M
@arr
M=D  // arr = RAM[0]

@R1
D=M
@n
M=D  // n = RAM[1]

@i
M=0  // i = 0

(LOOP)
@n
D=M
@i
D=D-M  // D=n-i

@END
D;JEQ  // if i == n: jump END

@arr
D=M
@i
A=D+M
M=-1   // RAM[arr + i] = -1

@i
M=M+1  // i++

@LOOP
0;JMP  // jump LOOP

(END)
@END
0;JMP

