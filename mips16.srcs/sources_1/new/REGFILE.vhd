----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2022 06:33:42 PM
-- Design Name: 
-- Module Name: REGFILE - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity REGFILE is
    Port ( 
    clk : in std_logic;
    ra1 : in std_logic_vector(2 downto 0);
    ra2 : in std_logic_vector(2 downto 0);
    wa : in std_logic_vector(2 downto 0);
    wd : in std_logic_vector(15 downto 0);
    wen : in std_logic;
    rd1 : out std_logic_vector(15 downto 0);
    rd2 : out std_logic_vector(15 downto 0);
    ButtonEnn : in std_logic;
    debug5 : out std_logic_vector(15 downto 0);
    debug1 : out std_logic_vector(15 downto 0);
    debug2 : out std_logic_vector(15 downto 0)
    );
end REGFILE;

architecture Behavioral of REGFILE is

type reg_array is array(0 to 7) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (others => x"0000");

begin

process(clk)
begin
    if clk'event and clk = '0' then
        if wen = '1' and ButtonEnn = '1' then
            reg_file(conv_integer(wa)) <= wd;
        end if;
    end if;
end process;

rd1 <= reg_file(conv_integer(ra1));
rd2 <= reg_file(conv_integer(ra2));
debug5 <= reg_file(5);
debug1 <= reg_file(1);
debug2 <= reg_file(2);

end Behavioral;
