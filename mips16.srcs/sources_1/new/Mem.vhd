----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2022 07:45:07 PM
-- Design Name: 
-- Module Name: Mem - Behavioral
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

entity Mem is
    Port (
    clk : in std_logic;
    MemWrite : in std_logic;
    ALURes : in std_logic_vector(15 downto 0);
    RD2 : in std_logic_vector(15 downto 0);
    MemToReg : in std_logic;
    mem_data : out std_logic_vector(15 downto 0);
    alu1 : out std_logic_vector(15 downto 0);
    ButtonEnn : in std_logic
    );
end Mem;

architecture Behavioral of Mem is

component RAM is
    Port ( 
  clk : in std_logic;
  we : in std_logic;
  address : in std_logic_vector(5 downto 0);
  wd : in std_logic_vector(15 downto 0);
  rd : out std_logic_vector(15 downto 0);
  ButtonEnn : in std_logic
  );
end component;

signal rd_sig, out_sig : std_logic_vector(15 downto 0) := x"0000";

begin

ram_memory : RAM port map (clk, MemWrite, ALURes(5 downto 0), RD2, rd_sig, ButtonEnn);

--mux : process(ALURes, MemToReg, rd_sig)
--begin
--    case MemToReg is
--        when '0' => out_sig <= ALURes;
--        when others => out_sig <= rd_sig;
--    end case;
-- end process;

-- MemOut <= out_sig;
mem_data <= rd_sig;
alu1 <= ALURes;

end Behavioral;
