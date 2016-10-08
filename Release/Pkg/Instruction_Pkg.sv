//Release 2016.10.08
//File         : Instruction_Pkg.sv
//Creator(s)   : Yang, Yu-Xiang (M10412034@yuntech.edu.tw)
//
//Description: About Instruction information for test
//version : 1.0
//


package Instruction_Pkg;

//OP Codes
typedef enum logic [5:0] {
R_Type     =6'b00_0000, 
Regimm     =6'b00_0001,
Addi       =6'b00_1000,
Andi       =6'b00_1100,
Beq        =6'b00_0100,
Bgtz       =6'b00_0111,
Blez       =6'b00_0110,
Bne        =6'b00_0101,
J          =6'b00_0010,
Jal        =6'b00_0011,
//Lb         =6'b10_0000,
//Lbu        =6'b10_0100,
//Lh         =6'b10_0001,
//Lhu        =6'b10_0101,
//Ll         =6'b11_0000,
//Lui        =6'b00_1111,
//Lw         =6'b10_0011,
//Lwl        =6'b10_0010,
//Lwr        =6'b10_0110,
Ori        =6'b00_1101,
//Sb         =6'b10_1000,
//Sh         =6'b10_1001,
//Slti       =6'b00_1010,
//Sltiu      =6'b00_1011,
//Sw         =6'b10_1011,
Xori       =6'b00_1110
} opcode_t;

//Function Codes for R-Type Op Codes
typedef enum logic [5:0] {
Add     =6'b10_0000,
Addu    =6'b10_0001,
And     =6'b10_0100,
Jr      =6'b00_1000,
Jalr    =6'b00_1001,
Nor     =6'b10_0111,
Or      =6'b10_0101,
//Sll     =6'b00_0000,
//Sllv    =6'b00_0100,
//Slt     =6'b10_1010,
//Sltu    =6'b10_1011,
//Sra     =6'b00_0011,
//Srav    =6'b00_0111,
//Srl     =6'b00_0010,
//Srlv    =6'b00_0110,
Sub     =6'b10_0010,
Xor     =6'b10_0110
} funct_t;

// Op Code Rt fields for Branches 

typedef enum logic [4:0] {
Bgez   =5'b00001,
Bgezal =5'b10001,
Bltz   =5'b00000,
Bltzal =5'b10000
} Rt_funct_t;

endpackage
