# Proccessor Desing

Required to extend the MIPS-lite single cycle implementation by implementing additional status registers and instructions. Develop and test your code using the ModelSim simulator. You should implement the following:

1) Sign/Minus Flag (S) - CPSR[2]:
Program status should be flagged as negative
If the calculation instructions lead to negative results, please register.

2) Overflow Flag (V) - CPSR[1]:
This flag also affects the result of signed arithmetic.

Large enough to fit in the appropriate 32-bit architecture for subsequent instructions. That is, input operands set to 1 must have the same sign, and results must have different signs. For example, overflow occurs when the sum of two positive numbers is negative. 

3) Zero flag (Z) - CPSR[0]:
This flag is already implemented in MIPS-Lite.

To keep the resulting zero-flag status for another cycle, we need to extend its use. The above result should be stored in the current program status register (CPSR) which is 3 bits in size. The order should match the visualization below.

3-bit current program status register. Also, the next command must recognize and execute the status bits of the previous command. Additionally, the CPSR should be cleared or updated every command execution cycle. If the current instruction is not controlled by a dependency on the CPSR register (one of the flags above), its only effect is to update the contents of the CPSR. On the other hand, if the current command is controlled by the contents of the CPSR register, the architecture should clear his CPSR. The updated architecture should correctly execute the following instructions: Some of them are 32-bit.

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

```1) add $t0, $s1, $s2
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

# Example test code as below: (convert it to binary format, embed to the relevant storage files, and test your architecture)
```
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
```
