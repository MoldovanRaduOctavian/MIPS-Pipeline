----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2022 03:04:35 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
    Port(
        digit0 : in STD_LOGIC_VECTOR(3 downto 0);
        digit1 : in STD_LOGIC_VECTOR(3 downto 0);
        digit2 : in STD_LOGIC_VECTOR(3 downto 0);
        digit3 : in STD_LOGIC_VECTOR(3 downto 0);
        clk : in STD_LOGIC;
        cat : out STD_LOGIC_VECTOR(6 downto 0);
        an : out STD_LOGIC_VECTOR(3 downto 0)
    );
end SSD;

architecture Behavioral of SSD is
    signal ret_m1 : std_logic_vector(3 downto 0) := "0000";
    signal ret_m2 : std_logic_vector(3 downto 0) := "0000";
    signal biti_s : std_logic_vector(1 downto 0) := "00";
    signal biti_counter : std_logic_vector(15 downto 0) := "0000000000000000";
    signal sel : std_logic_vector(1 downto 0) := "00";
    signal seg7 : std_logic_vector(6 downto 0) := "0000000";
    
begin

count : process(clk)
begin
    
    if clk'event and clk = '1' then
        if biti_counter = "1111111111111111" then
            biti_counter <= "0000000000000000";
        else
            biti_counter <= biti_counter + 1;
            
        end if;
    end if;

end process;

mux1 : process(digit0, digit1, digit2, digit3, biti_counter)
begin
    sel(1) <= biti_counter(15);
    sel(0) <= biti_counter(14);
    
    case sel is
        when "00" => ret_m1 <= digit0;
        when "01" => ret_m1 <= digit1;
        when "10" => ret_m1 <= digit2;
        when "11" => ret_m1 <= digit3;
        when others => NULL;
    end case;
    
end process;

mux2 : process(biti_counter)
begin
    sel(1) <= biti_counter(15);
    sel(0) <= biti_counter(14);
    
    case sel is
        when "00" => ret_m2 <= "1110";
        when "01" => ret_m2 <= "1101";
        when "10" => ret_m2 <= "1011";
        when "11" => ret_m2 <= "0111";
        when others => NULL;
    end case;
    
    an <= ret_m2;
    
end process;

h7seg : process(ret_m1)
begin
    
    case ret_m1 is
        when "0000"=> seg7 <="0000001";  -- '0'
            when "0001"=> seg7 <="1001111";  -- '1'
            when "0010"=> seg7 <="0010010";  -- '2'
            when "0011"=> seg7 <="0000110";  -- '3'
            when "0100"=> seg7 <="1001100";  -- '4' 
            when "0101"=> seg7 <="0100100";  -- '5'
            when "0110"=> seg7 <="0100000";  -- '6'
            when "0111"=> seg7 <="0001111";  -- '7'
            when "1000"=> seg7 <="0000000";  -- '8'
            when "1001"=> seg7 <="0000100";  -- '9'
            when "1010"=> seg7 <="0001000";  -- 'A'
            when "1011"=> seg7 <="1100000";  -- 'b'
            when "1100"=> seg7 <="0110001";  -- 'C'
            when "1101"=> seg7 <="1000010";  -- 'd'
            when "1110"=> seg7 <="0110000";  -- 'E'
            when "1111"=> seg7 <="0111000";  -- 'F'
            when others =>  NULL;
    end case;

    cat <= seg7;

end process;

end Behavioral;
