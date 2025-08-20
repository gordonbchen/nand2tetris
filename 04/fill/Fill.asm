// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// nScreen = KBD - SCREEN
//
// LOOP
//   color = 0
//   if RAM[KBD] == 0: jump DRAW
//   color = -1
//
//  DRAW
//    i = nScreen
//    addr = SCREEN
//    DRAWLOOP
//      RAM[addr] = color
//      i--
//      addr++
//      if i > 0: jump DRAWLOOP
//
//  jump LOOP

@KBD
D=A
@SCREEN
D=D-A
@nScreen
M=D  // nScreen = KBD - SCREEN

(LOOP)
@color
M=0  // color = 0

@KBD
D=M
@DRAW
D;JEQ  // if RAM[KBD] == 0: jump DRAW

@color
M=M-1  // color = -1

(DRAW)
@nScreen
D=M
@i
M=D  // i = nScreen

@SCREEN
D=A
@addr
M=D  // addr = SCREEN

(DRAWLOOP)
@color
D=M
@addr
A=M
M=D  // RAM[addr] = color

@i
M=M-1  // i--

@addr
M=M+1  // addr++

@i
D=M
@DRAWLOOP
D;JGT  // if i > 0: jump DRAWLOOP

@LOOP
0;JMP  // jump LOOP

