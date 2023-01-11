# Proccessor_Desing

Required to extend the MIPS-lite single-cycle implementation by implementing additional status register and instructions.You will use ModelSim simulator to develop and test code. The followings need to be implemented:
1) Sign/Negative Flag (S) - CPSR[2]: need to set the negative flag in your program status
register whenever your arithmetic instruction results in a negative result.
2) Overflow Flag (V) - CPSR[1]: This flag will be set if the result of a signed operation is too
large to fit with the corresponding 32-bit architecture to use for further instructions. That is, must set to 1 of the input operands have the same sign, and the result has a different sign. For example, if the sum of two positive numbers yields a negative result, then an overflow occurs.
3) Zero Flag (Z) - CPSR[0]: This flag has already been implemented in the MIPS-Lite. You must extend its usage to hold the resultant zero flag status one more cycle.
The above results need to be stored in the current program status register (CPSR), which
must have a size of 3 bits. The ordering must be the same as the following
visualization.
-> 3-bit Current Program Status Register.
Also, the next instructions must execute with the knowledge of the previous instruction’s
status bits. Moreover, the CPSR must be cleared or updated for each instruction-execution cycle. If the current instruction is not controlled by depending on the CPSR register (anyone of the above flags), its effect is just to update the content of the CPSR. On the other side, if the current instruction is controlled by the content of the CPSR register, architecture must clear the contents of the CPSR. Updated architecture needs to correctly execute the below instructions, some of whose 32-bit
ISA specifications are described in Appendix A of your textbook.
J-format: j: whose ISA is given in Appendix A of the textbook.
R-format: nor: whose ISA is given in Appendix A of the textbook.
I-type: addi: whose ISA is given in Appendix A of the textbook.
B-format:
- bvf: branch if overflow occurs for the previous instruction
- 31:26, opcode = 0x5
- 25:16, do not care bits. (xx)
- 15:0, branch address
- ben: branch if the previous instruction’ result is negative or equal to zero
- 31:26, opcode = 0x6
- 25:16, do not care bits. (xx)
- 15:0, branch address
For example,
````
1) add $t0, $s1, $s2
ben label
j X
X: ………………….
label: ………………….
s1 = 0x0000003, s2 = 0xFFFFFFFB and t0 will be
0xFFFFFFFE.
This instruction sets the CPSR as 100 as
- negative flag (S) = 1
- others will be 0.
ben instruction will take branch since S = 1
2) sub $t0, $s1, $s2
ben label
j X
X: ………………….
label: ………………….
s1 = 0x00000003, s2 = 0x00000003 and t0 will be 0.
This instruction sets the CPSR as 001 as
- zero flag (Z) = 1
- others will be 0.
ben instruction will take branch since Z = 1
3) add $t0, $s1, $s2
bvf label
j X
X: ………………….
label: ………………….
s1 = 0x7FFFFFFF, s2 = 0x00000001, and t0 will be
0x80000000.
This instruction sets the CPSR as 110 as
- negative flag (S) = 1,
- overflow flag (V) = 1,
- zero flag will be 0.
bvf instruction will take branch since V = 1
```

Example test code as below: (convert it to binary format, embed to the relevant storage files, and
test your architecture)
Initially, r2 = 0x05, r3 = 0x0A, r5 = 0x80000000
main:
(pc = 0x00) — j label_1 //→ label_1 should be 0x0C
label_2:
(pc = 0x04) — add $r4, $r4, $r5 // →r4 = (0xFFFFFFFF + 0x80000000)
(pc = 0x08) — bvf label_3 // label_3 should be 0x18, V = 1
label_1:
(pc = 0x0C) — nor $r1, $r2, $r3 // ~(r2 = 0x05 | r3 = 0x0A) → r1 = 0xFFFFFFF0
(pc = 0x10) — addi $r4, $r1, 0x0F // r4 = 0xFFFFFFFF, S = 1
(pc = 0x14) — ben label_2 // label_2 should be 0x04
label_3:
(pc = 0x18) — j exit // exit should be 0x40
….
….
….
exit:
(pc = 0x40) // we do not care the code after exit branch.
