// Sum1toN.asm: RAM[1] = 1 + 2 + ... + RAM[0]
// n = RAM[0]
// i = 1
// sum = 0
// LOOP
//  if i > n: jump STOP
//  sum += i
//  i++
//  jump LOOP
// STOP
//  RAM[1] = sum
// END: infinite loop

@i
M=1  // i = 1

@sum
M=0  // sum = 0

(LOOP)
@R0
D=M
@i
D=D-M  // D = n - i

@STOP
D;JLT  // STOP if n - i < 0

@i
D=M
@sum
M=D+M  // sum += i

@i
M=M+1  // i++

@LOOP
0;JMP

(STOP)
@sum
D=M
@R1
M=D  // RAM[1] = sum

(END)
@END
0;JMP

