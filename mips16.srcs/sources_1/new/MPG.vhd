library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MPG is  
    Port ( clk : in STD_LOGIC;
           buton: in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           enn: out std_logic;
           sw : in STD_LOGIC_VECTOR (15 downto 0));       
end MPG;

architecture Behavioral of MPG is
signal count_int : std_logic_vector(31 downto 0) :=x"00000000";
signal Q1 : std_logic := '0';
signal Q2 : std_logic := '0';
signal Q3 : std_logic := '0';

begin

enn <= Q2 AND (not Q3);
process (clk) 
    begin
         if clk'event and clk='1' then
        count_int <= count_int + 1;
        end if;
    end process;
    
process (clk)
    begin
    if clk'event and clk='1' then 
        if count_int(15 downto 0) = "1111111111111111" then 
            Q1 <= buton;
        end if; 
    end if;
end process;

process (clk)
begin
 if clk'event and clk='1' then 
    Q2 <= Q1;
    Q3 <= Q2;
 end if;
end process;


end Behavioral;