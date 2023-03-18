----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2022 04:19:00 PM
-- Design Name: 
-- Module Name: AluControl - Behavioral
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

entity AluControl is
    Port (
    Func : in std_logic_vector(2 downto 0);
    AluOp : in std_logic_vector(2 downto 0);
    Control : out std_logic_vector(2 downto 0)
    );
end AluControl;

architecture Behavioral of AluControl is

begin

process (Func, AluOp)
begin
    case AluOp is
        when "000" => Control <= "000";
        when "001" => Control <= "001";
        when "111" =>
            case Func is
                when "000" => Control <= "000";
                when "001" => Control <= "001";
                when "010" => Control <= "010";
                when "011" => Control <= "011";
                when "100" => Control <= "100";
                when "101" => Control <= "101";
                when "110" => Control <= "110";
                when "111" => Control <= "111";
                when others => NULL;
            end case;
        when others => NULL;
    end case;
end process;

end Behavioral;
