----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2022 04:03:25 PM
-- Design Name: 
-- Module Name: MainControl - Behavioral
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

entity MainControl is
     Port ( 
     Opcode : in std_logic_vector(2 downto 0);
     RegDst : out std_logic;
     ExtOp : out std_logic;
     ALUSrc : out std_logic;
     Branch : out std_logic;
     Jump : out std_logic;
     ALUOp : out std_logic_vector(2 downto 0);
     MemWrite : out std_logic;
     MemToReg : out std_logic;
     RegWrite : out std_logic
     );
end MainControl;

architecture Behavioral of MainControl is

begin

process(Opcode)
begin
    
    case Opcode is
        when "000" => RegDst <= '1'; RegWrite <= '1'; ALUSrc <= '0'; ExtOp <= '0'; ALUOp <= "111"; MemWrite <= '0'; MemToReg <= '0'; Branch <= '0'; Jump <= '0';
        when "001" => RegDst <= '0'; RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '0'; ALUOp <= "000"; MemWrite <= '0'; MemToReg <= '0'; Branch <= '0'; Jump <= '0';
        when "010" => RegDst <= '0'; RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '0'; ALUOp <= "000"; MemWrite <= '0'; MemToReg <= '1'; Branch <= '0'; Jump <= '0';
        when "011" => RegDst <= '0'; RegWrite <= '0'; ALUSrc <= '1'; ExtOp <= '0'; ALUOp <= "000"; MemWrite <= '1'; MemToReg <= '0'; Branch <= '0'; Jump <= '0';
        when "100" => RegDst <= '0'; RegWrite <= '0'; ALUSrc <= '0'; ExtOp <= '0'; ALUOp <= "001"; MemWrite <= '0'; MemToReg <= '0'; Branch <= '1'; Jump <= '0';
        when "101" => RegDst <= '0'; RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '0'; ALUOp <= "001"; MemWrite <= '0'; MemToReg <= '0'; Branch <= '0'; Jump <= '0'; -- subi
        when "110" => RegDst <= '0'; RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '0'; ALUOp <= "100"; MemWrite <= '0'; MemToReg <= '0'; Branch <= '0'; Jump <= '0'; -- andi
        when "111" => RegDst <= '0'; RegWrite <= '0'; ALUSrc <= '0'; ExtOp <= '0'; ALUOp <= "000"; MemWrite <= '0'; MemToReg <= '0'; Branch <= '0'; Jump <= '1';
        when others => NULL;
    end case;
    
end process;


end Behavioral;
