----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2022 07:01:50 PM
-- Design Name: 
-- Module Name: InstructionDecode - Behavioral
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

entity InstructionDecode is
    Port ( 
    clk : in std_logic;
    RegWrite : in std_logic;
    Instr : in std_logic_vector(15 downto 0);
    raddress : in std_logic_vector(2 downto 0);
    ExtOp : in std_logic;
    WD : in std_logic_vector(15 downto 0);
    rd1 : out std_logic_vector(15 downto 0);
    rd2 : out std_logic_vector(15 downto 0);
    ExtImm : out std_logic_vector(15 downto 0);
    func : out std_logic_vector(2 downto 0);
    sa : out std_logic;
    rt : out std_logic_vector(2 downto 0);
    rd : out std_logic_vector(2 downto 0);
    ButtonEnn : in std_logic;
    debug5 : out std_logic_vector(15 downto 0);
    debug1 : out std_logic_vector(15 downto 0);
    debug2 : out std_logic_vector(15 downto 0)
    );
end InstructionDecode;

architecture Behavioral of InstructionDecode is

component REGFILE is
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
end component;

signal reg_mux : std_logic_vector(2 downto 0) := "000";
signal ext_sig : std_logic_vector(15 downto 0) := x"0000";

begin

reg : REGFILE port map (clk, Instr(12 downto 10), Instr(9 downto 7), reg_mux, WD, RegWrite, rd1, rd2, ButtonEnn, debug5, debug1, debug2);

-- asta trebuie modificata sa mearga si pentru negative
ex : process(ExtOp, Instr)
begin
    case ExtOp is
        when '0' => ext_sig <= "000000000" & Instr(6 downto 0);
        when others =>
            case Instr(7) is
                when '0' => ext_sig <= "000000000" & Instr(6 downto 0);
                when others => ext_sig <= "111111111" & Instr(6 downto 0);
            end case;
    end case;
end process;

--mux : process(RegDst, Instr)
--begin
--    case RegDst is
--        when '0' => reg_mux <= Instr(9 downto 7);
--        when others => reg_mux <= Instr(6 downto 4);
--    end case;
--end process;
reg_mux <= raddress;

ExtImm <= ext_sig;
sa <= Instr(3);
func <= Instr(2 downto 0);

rt <= Instr(9 downto 7);
rd <= Instr(6 downto 4);

end Behavioral;
