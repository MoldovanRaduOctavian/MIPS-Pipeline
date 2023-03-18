----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2022 04:40:41 PM
-- Design Name: 
-- Module Name: Alu - Behavioral
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

entity Alu is
     Port ( 
     a : in std_logic_vector(15 downto 0);
     b : in std_logic_vector(15 downto 0);
     ctrl : in std_logic_vector(2 downto 0);
     zero : out std_logic;
     res : out std_logic_vector(15 downto 0)
     );
end Alu;

architecture Behavioral of Alu is

signal aux_sig : std_logic_vector(15 downto 0) := x"0000";

begin

process(a, b, ctrl, aux_sig)
begin
    case ctrl is
        when "000" => aux_sig <= a + b;
        when "001" => aux_sig <= a - b;
        when "010" => aux_sig <= a(14 downto 0) & '0';
        when "011" => aux_sig <= '0' & a(15 downto 1);
        when "100" => aux_sig <= a and b;
        when "101" => aux_sig <= a or b;
        when "110" =>
            if a >= b then
                aux_sig <= x"0000";
            else
                aux_sig <= x"0001";
            end if;
        when "111" => aux_sig <= a xor b;    
        when others => NULL;
    end case;
    
    if aux_sig = x"0000" then
        zero <= '1';
    else
        zero <= '0';
    end if;
    
end process;

res <= aux_sig;

end Behavioral;
