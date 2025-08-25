#!/usr/bin/env python3

from argparse import ArgumentParser
from pathlib import Path


class SymbolTable:
    def __init__(self):
        self.symbols = {f"R{i}": i for i in range(16)}
        self.symbols["SCREEN"] = 16384
        self.symbols["KBD"] = 24576
        for i, symbol in enumerate(("SP", "LCL", "ARG", "THIS", "THAT")):
            self.symbols[symbol] = i

        self.n = 16

    def add_label(self, label_name: str, n_instruction: int) -> None:
        self.symbols[label_name] = n_instruction

    def add_var(self, var_name: str) -> int:
        self.symbols[var_name] = self.n
        self.n += 1
        return self.n - 1

    def __str__(self) -> str:
        return str(self.symbols)


# C-instruction tables.
C_COMP_TABLE = {
    "0": "101010",
    "1": "111111",
    "-1": "111010",
    "D": "001100",
    "A": "110000",
    "!D": "001101",
    "!A": "110001",
    "-D": "001111",
    "-A": "110011",
    "D+1": "011111",
    "A+1": "110111",
    "D-1": "001110",
    "A-1": "110010",
    "D+A": "000010",
    "D-A": "010011",
    "A-D": "000111",
    "D&A": "000000",
    "D|A": "010101",
}
C_JUMP_TABLE = {
    "": "000",
    "JGT": "001",
    "JEQ": "010",
    "JGE": "011",
    "JLT": "100",
    "JNE": "101",
    "JLE": "110",
    "JMP": "111",
}


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("file", help=".asm file to assemble")
    args = parser.parse_args()

    with open(args.file, "r") as f:
        text = f.read()
    print()
    print(args.file)
    print(text)

    # Remove whitespace and comments.
    lines = []
    for line in text.split("\n"):
        # Remove everything to the right of //.
        comment_index = line.find("//")
        if comment_index != -1:
            line = line[:comment_index]
        # Strip left and right whitespace.
        line = line.strip()
        # Skip blank lines.
        if line:
            lines.append(line)

    # Init symbol table.
    symbol_table = SymbolTable()

    # 1st pass: save (LABEL) declarations to symbol table.
    n_instruction = 0
    labeled_lines = lines
    lines = []
    for line in labeled_lines:
        if line[0] == "(":
            label_name = line[1: line.index(")")]
            symbol_table.add_label(label_name, n_instruction)
        else:
            n_instruction += 1
            lines.append(line)

    # 2nd pass: assemble.
    instructions = []
    for line in lines:
        # Handle A-instructions.
        if line[0] == "@":
            symbol = line[1:]
            # Get the value of the symbol.
            if symbol in symbol_table.symbols:
                symbol_val = symbol_table.symbols[symbol]
            elif symbol.isnumeric():
                symbol_val = int(symbol)
            else:
                symbol_val = symbol_table.add_var(symbol)
            # Convert int to bits.
            instruction = f"0{symbol_val:015b}"
            instructions.append(instruction)
            continue

        # Handle C-instruction.
        # Parse dest.
        eq_index = line.find("=")
        if eq_index == -1:
            dest = ""
        else:
            dest = line[:eq_index]
            line = line[eq_index + 1:]
        dest_bits = "".join(["1" if reg in dest else "0" for reg in ("A", "D", "M")])

        # Parse comp.
        semi_index = line.find(";")
        if semi_index == -1:
            comp = line
            jump = ""
        else:
            comp = line[:semi_index]
            jump = line[semi_index + 1:]
        a_bit = "1" if "M" in comp else "0"
        # Replace "M" with "A" for comp table.
        comp = comp.replace("M", "A")
        c_bits = C_COMP_TABLE[comp]
        comp_bits = f"{a_bit}{c_bits}"

        # Parse jump.
        jump_bits = C_JUMP_TABLE[jump]

        # Combine into instruction.
        instruction = f"111{comp_bits}{dest_bits}{jump_bits}"
        instructions.append(instruction)

    # Write instructions to .hack file.
    file = Path(args.file)
    hack_file = file.parent / (file.stem + ".hack")
    hack_txt = "\n".join(instructions)
    with open(hack_file, "w") as f:
        f.write(hack_txt)

    print()
    print(hack_file)
    print(hack_txt)
