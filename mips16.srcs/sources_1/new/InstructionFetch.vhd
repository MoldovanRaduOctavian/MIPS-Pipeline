----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2022 06:41:35 PM
-- Design Name: 
-- Module Name: InstructionFetch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- programul calculeaza cmmdc dintre elementul minim si elementul maxim al unui sir de numere pozitive pe 16 biti
entity InstructionFetch is
    Port (
    clk : in std_logic; 
    JumpAddress : in std_logic_vector(15 downto 0);
    BranchAddress : in std_logic_vector(15 downto 0);
    Jump : in std_logic;
    ButtonEnn : in std_logic;
    PCSrc : in std_logic;
    PC : out std_logic_vector(15 downto 0);
    Instruction : out std_logic_vector(15 downto 0)
    );
end InstructionFetch;

architecture Behavioral of InstructionFetch is



type rom_array is array(0 to 255) of std_logic_vector(15 downto 0);
signal rom_file : rom_array := (
-- memory offset pt ram: v - 0, min - 5, max - 6, cmmdc, - 7
--b"001_000_111_0000000",   -- 0  2380 addi $7, $0, 0
--b"001_000_001_0000000",   -- 1  2080 addi $1, $0, 0
--b"010_111_001_0000000",   -- 2  5c80 lw $1, v($7)
--b"010_000_010_0000101",   -- 3  4105 lw $2, min($0)
--b"000_001_010_011_0_110", -- 4  0536 slt $3, $1, $2
--b"001_000_100_0000001",   -- 5  2201 addi $4, $0, 1
--b"100_100_011_0000001",   -- 6  9181 beq $3, $4, 1
--b"111_0000000001001",     -- 7  e009 j 9
--b"011_000_001_0000101",   -- 8  6085 sw $1, min($0)
--b"010_000_010_0000110",   -- 9  4106 lw $2, max($0)
--b"000_001_010_011_0_110", -- 10 0536 slt $3, $1, $2
--b"001_000_100_0000000",   -- 11 2200 addi $4, $0, 0
--b"100_100_011_0000001",   -- 12 9181 beq $3, $4, 1
--b"111_0000000001111",     -- 13 e00f j 15
--b"011_000_001_0000110",   -- 14 6086 sw $1, max($0)
--b"001_111_111_0000001",   -- 15 3f81 addi $7, $7, 1
--b"001_000_101_0000101",   -- 16 2285 addi $5, $0, 5
--b"100_111_101_0000001",   -- 17 9e81 beq $7, $5, 1
--b"111_0000000000001",     -- 18 e001 j 1
--b"010_000_001_0000101",   -- 19 4085 lw $1, min($0)
--b"010_000_010_0000110",   -- 20 4106 lw $2, max($0)
--b"100_001_010_0000100",   -- 21 8504 beq $1, $2, 4
--b"000_001_010_011_0_110", -- 22 0536 slt $3, $1, $2
--b"001_000_100_0000001",   -- 23 2201 addi $4, $0, 1
--b"100_011_100_0000010",   -- 24 8e02 beq $3 $4 2
--b"111_0000000011101",     -- 25 e01d j 29
--b"111_0000000011111",     -- 26 e01f j 31
--b"000_010_001_010_0_001", -- 27 08a1 sub $2, $2, $1
--b"111_0000000010101",     -- 28 e015 j 21
--b"000_001_010_001_0_001", -- 29 0511 sub $1, $1, $2
--b"111_0000000010101",     -- 30 e015 j 21
--b"011_000_001_0000111",   -- 31 6087 sw $1, cmmdc($0)
--b"010_000_001_0000111",   -- 32 4087 lw $1, cmmdc($0)
--others => x"0000");
b"001_000_111_0000000",     -- 0 addi $7, $0, 0
b"000_000_000_0000000",     -- 1 noop
b"001_000_001_0000000",     -- 2 addi $1, $0, 0
b"010_111_001_0000000",     -- 3 lw $1, v($7)
b"010_000_010_0000101",     -- 4 lw $2, min($0)
b"000_000_000_0000000",     -- 5 noop
b"000_000_000_0000000",     -- 6 noop
b"000_001_010_011_0_110",   -- 7 slt $3, $1, $2
b"001_000_100_0000001",     -- 8 addi $4, $0, 1
b"000_000_000_0000000",     -- 9 noop
b"000_000_000_0000000",     -- 10 noop
b"100_100_011_0000101",     -- 11 beq $3, $4, 5
b"000_000_000_0000000",     -- 12 noop
b"000_000_000_0000000",     -- 13 noop
b"000_000_000_0000000",     -- 14 noop
b"111_0000000010010",       -- 15 j 18
b"000_000_000_0000000",     -- 16 noop
b"011_000_001_0000101",     -- 17 sw $1, min($0)
b"010_000_010_0000110",     -- 18 lw $2, max($0)
b"000_000_000_0000000",     -- 19 noop
b"000_000_000_0000000",     -- 20 noop
b"000_001_010_011_0_110",   -- 21 slt $3, $1, $2
b"001_000_100_0000000",     -- 22 addi $4, $0, 0
b"000_000_000_0000000",     -- 23 noop
b"000_000_000_0000000",     -- 24 noop
b"100_100_011_0000101",     -- 25 beq $3, $4, 5
b"000_000_000_0000000",     -- 26 noop
b"000_000_000_0000000",     -- 27 noop
b"000_000_000_0000000",     -- 28 noop
b"111_0000000100000",       -- 29 j 32
b"000_000_000_0000000",     -- 30 noop
b"011_000_001_0000110",     -- 31 sw $1, max($0)
b"001_111_111_0000001",     -- 32 addi $7, $7, 1
b"001_000_101_0000101",     -- 33 addi $5, $0, 5
b"000_000_000_0000000",     -- 34 noop
b"000_000_000_0000000",     -- 35 noop
b"100_111_101_0000101",     -- 36 beq $7, $5, 5
b"000_000_000_0000000",     -- 37 noop 
b"000_000_000_0000000",     -- 38 noop
b"000_000_000_0000000",     -- 39 noop
b"111_0000000000010",       -- 40 j 2
b"000_000_000_0000000",     -- 41 noop
b"010_000_001_0000101",     -- 42 lw $1, min($0)
b"010_000_010_0000110",     -- 43 lw $2, max($0)
b"000_000_000_0000000",     -- 44 noop
b"000_000_000_0000000",     -- 45 noop
b"100_001_010_0001101",     -- 46 beq $1, $2, 13
b"000_000_000_0000000",     -- 47 noop
b"000_000_000_0000000",     -- 48 noop
b"000_000_000_0000000",     -- 49 noop
b"000_001_010_011_0_110",   -- 50 slt $3, $1, $2
b"001_000_100_0000001",     -- 51 addi $4, $0, 1
b"000_000_000_0000000",     -- 52 noop
b"000_000_000_0000000",     -- 53 noop
b"100_011_100_0000111",     -- 54 beq $3, $4, 7
b"000_000_000_0000000",     -- 55 noop
b"000_000_000_0000000",     -- 56 noop
b"000_000_000_0000000",     -- 57 noop
b"111_0000001000001",       -- 58 j 65
b"000_000_000_0000000",     -- 59 noop
b"111_0000001000100",       -- 60 j 68
b"000_000_000_0000000",     -- 61 noop
b"000_010_001_010_0_001",   -- 62 sub $2, $2, $1
b"111_0000000101110",       -- 63 j 46
b"000_000_000_0000000",     -- 64 noop
b"000_001_010_001_0_001",   -- 65 sub $1, $1, $2
b"111_0000000101110",       -- 66 j 46
b"000_0000000000000",       -- 67 noop
b"011_000_001_0000111",     -- 68 sw $1, cmmdc($0)
b"010_000_001_0000111",     -- 69 lw $1, cmmdc($0)
others => x"0000");

signal pc_sig, s_sig, b_mux, j_mux: std_logic_vector(15 downto 0) := x"0000";

begin

pc_ld : process(clk)
begin
    if clk'event and clk = '1' then
        if ButtonEnn = '1' then
            pc_sig <= j_mux;
        end if;
    end if;
end process;

Instruction <= rom_file(conv_integer(pc_sig(6 downto 0)));

s_sig <= pc_sig + 1;
PC <= s_sig;

branch_mux : process(s_sig, BranchAddress, PCSrc)
begin
    case PCSrc is
        when '0' => b_mux <= s_sig;
        when others => b_mux <= BranchAddress;
    end case;
end process;

jump_mux : process(b_mux, JumpAddress, Jump)
begin
    case Jump is
        when '0' => j_mux <= b_mux;
        when others => j_mux <= JumpAddress;
    end case;
end process;

end Behavioral;
