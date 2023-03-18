----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2022 07:32:40 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
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

entity RAM is
  Port ( 
  clk : in std_logic;
  we : in std_logic;
  address : in std_logic_vector(5 downto 0);
  wd : in std_logic_vector(15 downto 0);
  rd : out std_logic_vector(15 downto 0);
  ButtonEnn : in std_logic
  );
end RAM;

architecture Behavioral of RAM is

type ram_array is array(0 to 63) of std_logic_vector(15 downto 0);
signal ram_file : ram_array := (
x"0032",
x"0037",
x"004b",
x"0044",
x"0040",
x"ffff",
x"0000",
others => x"0000");


begin

process(clk, address)
begin

    if clk'event and clk = '1' then
      if we = '1' and ButtonEnn = '1' then
        ram_file(conv_integer(address)) <= wd;
      end if;
    end if;  

rd <= ram_file(conv_integer(address));

end process;

end Behavioral;
