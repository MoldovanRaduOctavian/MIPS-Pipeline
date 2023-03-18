----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2022 04:54:10 PM
-- Design Name: 
-- Module Name: Execution - Behavioral
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

entity Execution is
    Port (
     Rd1 : in std_logic_vector(15 downto 0);
     AluSrc : in std_logic;
     reg_dst : in std_logic;
     rt : in std_logic_vector(2 downto 0);
     rd : in std_logic_vector(2 downto 0);
     Rd2 : in std_logic_vector(15 downto 0);
     ExtImm : in std_logic_vector(15 downto 0);
     Func : in std_logic_vector(2 downto 0);
     AluOp : in std_logic_vector(2 downto 0);
     Zero : out std_logic;
     AluRes : out std_logic_vector(15 downto 0);
     rwa : out std_logic_vector(2 downto 0);
     debug_control : out std_logic_vector(2 downto 0)
     );
end Execution;

architecture Behavioral of Execution is

component Alu is
     Port ( 
     a : in std_logic_vector(15 downto 0);
     b : in std_logic_vector(15 downto 0);
     ctrl : in std_logic_vector(2 downto 0);
     zero : out std_logic;
     res : out std_logic_vector(15 downto 0)
     );
end component;

component AluControl is
    Port (
    Func : in std_logic_vector(2 downto 0);
    AluOp : in std_logic_vector(2 downto 0);
    Control : out std_logic_vector(2 downto 0)
    );
end component;

signal mux_sig : std_logic_vector(15 downto 0) := x"0000";
signal control_out : std_logic_vector(2 downto 0) := "000";

begin

alu_comp : Alu port map (Rd1, mux_sig, control_out, Zero, AluRes);
control_comp : AluControl port map(Func, AluOp, control_out);

process (Rd2, ExtImm, AluSrc)
begin
    
    case AluSrc is
        when '0' => mux_sig <= Rd2;
        when others => mux_sig <= ExtImm;
    end case;

end process;

debug_control <= control_out;

process (reg_dst, rt, rd)
begin
    case reg_dst is
        when '0' => rwa <= rt;
        when others => rwa <= rd;
    end case;
end process;

end Behavioral;
