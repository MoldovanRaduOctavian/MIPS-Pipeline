----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2022 05:51:15 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
     Port (
     clk : in std_logic;
     buton : in std_logic;
     btn : in std_logic_vector(4 downto 0);
     sw : in std_logic_vector(15 downto 0);
     switch : in std_logic;
     led : out std_logic_vector(15 downto 0);
     an : out std_logic_vector(3 downto 0);
     cat : out std_logic_vector(6 downto 0) 
     );
end test_env;

architecture Behavioral of test_env is

component MPG is  
    Port ( clk : in STD_LOGIC;
           buton: in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           enn: out std_logic;
           sw : in STD_LOGIC_VECTOR (15 downto 0));       
end component;

component SSD is
    Port(
        digit0 : in STD_LOGIC_VECTOR(3 downto 0);
        digit1 : in STD_LOGIC_VECTOR(3 downto 0);
        digit2 : in STD_LOGIC_VECTOR(3 downto 0);
        digit3 : in STD_LOGIC_VECTOR(3 downto 0);
        clk : in STD_LOGIC;
        cat : out STD_LOGIC_VECTOR(6 downto 0);
        an : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

component InstructionFetch is
    Port (
    clk : in std_logic; 
    JumpAddress : in std_logic_vector(15 downto 0);
    BranchAddress : in std_logic_vector(15 downto 0);
    Jump : in std_logic;
    ButtonEnn : in std_logic;
    PCSrc : in std_logic;
    PC : out std_logic_vector(15 downto 0);
    Instruction : out std_logic_vector(15 downto 0)
    );
end component;

component InstructionDecode is
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
end component;

component MainControl is
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
end component;

component Execution is
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
end component;

component Mem is
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
end component;

signal ja_sig, ba_sig, pc_sig, instruction_sig, out_sig, wd_sig: std_logic_vector(15 downto 0) := x"0000";
signal pc_enn, j_enn, pc_src, rw_sig, reg_dst_sig, ext_op_sig, sa_sig: std_logic := '0';
signal rd1_sig, rd2_sig, ext_imm_sig : std_logic_vector(15 downto 0) := x"0000";
signal func_sig, alu_op_sig: std_logic_vector(2 downto 0) := "000";
signal rt, rd, rwa : std_logic_vector(2 downto 0) := "000";
signal alu_src_sig, br_sig, j_sig, mw_sig, mtg_sig : std_logic := '0';
signal aux_adr : std_logic_vector(15 downto 0) := x"0000";
signal alu_res_sig : std_logic_vector(15 downto 0) := x"0000";
signal zero_sig : std_logic := '0';
signal mem_out_sig : std_logic_vector(15 downto 0) := x"0000";
signal WD : std_logic_vector(15 downto 0) := x"0000";
signal mem_data_sig, alu_res1 : std_logic_vector(15 downto 0) := x"0000";

signal debug5_sig, debug1_sig, debug2_sig : std_logic_vector(15 downto 0) := x"0000";
signal debug_control : std_logic_vector(2 downto 0) := "000";

-- Pipeline regs
-- IF ID
signal pc_if_id, instruction_if_id : std_logic_vector(15 downto 0) := x"0000";
-- ID EX
signal pc_id_ex, rd1_id_ex, rd2_id_ex, ext_imm_id_ex : std_logic_vector(15 downto 0) := x"0000";
signal func_id_ex, rt_id_ex, rd_id_ex, alu_op_id_ex : std_logic_vector(2 downto 0) := "000";
signal mtr_id_ex, rw_id_ex, mw_id_ex, br_id_ex, alu_src_id_ex, reg_dst_id_ex, sa_id_ex : std_logic := '0';
-- EX MEM
signal branch_address_ex_mem, alu_res_ex_mem, rd2_ex_mem : std_logic_vector(15 downto 0);
signal reg_dst_ex_mem : std_logic;
signal rd_ex_mem : std_logic_vector(2 downto 0);
signal zero_ex_mem, mtg_ex_mem, rw_ex_mem, mw_ex_mem, branch_ex_mem : std_logic;
-- MEM WB
signal mem_data_mem_wb, alu_res_mem_wb : std_logic_vector(15 downto 0) := x"0000";
signal rd_mem_wb : std_logic_vector(2 downto 0);
signal mtg_mem_wb, rw_mem_wb : std_logic := '0';

begin

aux_adr <= "000" & instruction_if_id(12 downto 0);
--wd_sig <= mem_out_sig;
ba_sig <= pc_id_ex + ext_imm_id_ex;
pc_src <= branch_ex_mem and zero_ex_mem;

--ex : Execution port map (rd1_sig, alu_src_sig, rd2_sig, ext_imm_sig, 
--instruction_sig(2 downto 0), alu_op_sig, zero_sig, alu_res_sig, debug_control);

--me : Mem port map (clk, mw_sig, 
--alu_res_sig, rd2_sig, mtg_sig, mem_out_sig, pc_enn);

--mc : MainControl port map (instruction_sig(15 downto 13), 
--reg_dst_sig, ext_op_sig, alu_src_sig, br_sig, j_sig, alu_op_sig, mw_sig, mtg_sig, rw_sig);

deb1 : MPG port map (clk, btn(0), btn, pc_enn, sw);
--inf : InstructionFetch port map (clk, aux_adr, ba_sig, j_sig, pc_enn, pc_src, pc_sig, instruction_sig);

--ind : InstructionDecode port map (clk, rw_sig, 
--instruction_sig, reg_dst_sig, ext_op_sig, wd_sig, rd1_sig, rd2_sig, ext_imm_sig, func_sig, sa_sig, pc_enn, debug5_sig, debug1_sig, debug2_sig);

--inf: InstructionFetch port map (clk, aux_adr, branch_address_ex_mem, j_sig, pc_enn, pc_src, pc_sig, instruction_sig);

--ind: InstructionDecode port map (clk, rw_mem_wb, instruction_if_id, reg_dst_sig, ext_op_sig, wd_sig, rd1_sig, rd2_sig, ext_imm_sig, func_sig, sa_sig, pc_enn, debug5_sig, debug1_sig, debug2_sig);

--mc: MainControl port map (instruction_if_id(15 downto 13), reg_dst_sig, ext_op_sig, alu_src_sig, br_sig, j_sig, alu_op_sig, mw_sig, mtg_sig, rw_sig);

--ex: Execution port map (rd1_id_ex, alu_src_id_ex, rd2_id_ex, ext_imm_id_ex, func_id_ex, alu_op_id_ex, zero_sig, alu_res_sig, debug_control);


--me: Mem port map (clk, mw_ex_mem, alu_res_ex_mem, rd2_ex_mem, mtg_ex_mem, mem_out_sig, pc_enn);

inf: InstructionFetch port map (clk, aux_adr, branch_address_ex_mem, j_sig, pc_enn, pc_src, pc_sig, instruction_sig);

ind: InstructionDecode port map (clk, rw_mem_wb, instruction_if_id, rd_mem_wb, ext_op_sig, WD, rd1_sig, rd2_sig, ext_imm_sig, func_sig, sa_sig, rt, rd, pc_enn, debug5_sig, debug1_sig, debug2_sig);

mc: MainControl port map (instruction_if_id(15 downto 13), reg_dst_sig, ext_op_sig, alu_src_sig, br_sig, j_sig, alu_op_sig, mw_sig, mtg_sig, rw_sig);

ex: Execution port map (rd1_id_ex, alu_src_id_ex, reg_dst_id_ex, rt_id_ex, rd_id_ex, rd2_id_ex, ext_imm_id_ex, func_id_ex, alu_op_id_ex, zero_sig, alu_res_sig, rwa, debug_control);

me: Mem port map (clk, mw_ex_mem, alu_res_ex_mem, rd2_ex_mem, mtg_ex_mem, mem_data_sig, alu_res1, pc_enn);

display : SSD port map (out_sig(3 downto 0),
out_sig(7 downto 4),
out_sig(11 downto 8),
out_sig(15 downto 12), clk, cat, an
);

process (mtg_mem_wb, mem_data_mem_wb, alu_res_mem_wb)
begin
    case mtg_mem_wb is
        when '1' => WD <= mem_data_mem_wb;
        when others => WD <= alu_res_mem_wb;
    end case;
end process;

process (clk)
begin
    if clk'event and clk = '1' then
        if pc_enn = '1' then
           -- if id
           pc_if_id <= pc_sig;
           instruction_if_id <= instruction_sig;
           -- id ex
           pc_id_ex <= pc_if_id;
           rd1_id_ex <= rd1_sig;
           rd2_id_ex <= rd2_sig;
           ext_imm_id_ex <= ext_imm_sig;
           func_id_ex <= func_sig;
           rt_id_ex <= rt;
           rd_id_ex <= rd;
           mtr_id_ex <= mtg_sig;
           rw_id_ex <= rw_sig;
           mw_id_ex <= mw_sig;
           br_id_ex <= br_sig;
           alu_src_id_ex <= alu_src_sig;
           alu_op_id_ex <= alu_op_sig;
           reg_dst_id_ex <= reg_dst_sig;
           -- ex mem
           branch_address_ex_mem <= ba_sig;
           zero_ex_mem <= zero_sig;
           alu_res_ex_mem <= alu_res_sig;
           rd2_ex_mem <= rd2_id_ex;
           rd_ex_mem <= rwa;
           mtg_ex_mem <= mtr_id_ex;
           rw_ex_mem <= rw_id_ex;
           mw_ex_mem <= mw_id_ex;
           branch_ex_mem <= br_id_ex;
           -- mem wb
           mem_data_mem_wb <= mem_data_sig;
           alu_res_mem_wb <= alu_res1;
           rd_mem_wb <= rd_ex_mem;
           mtg_mem_wb <= mtg_ex_mem;
           rw_mem_wb <= rw_ex_mem;
        end if;
    end if;

end process;

process(sw, instruction_sig, pc_sig, rd1_sig, rd2_sig, wd_sig, debug5_sig, debug1_sig, debug2_sig)
begin
    
    case sw(7 downto 4) is
        when "0000" => out_sig <= instruction_sig;
        when "0001" => out_sig <= pc_sig;
        when "0010" => out_sig <= rd1_sig;
        when "0011" => out_sig <= rd2_sig;
        when "0100" => out_sig <= wd_sig;
        when "0101" => out_sig <= debug5_sig;
        when "0110" => out_sig <= debug1_sig;
        when "0111" => out_sig <= debug2_sig;
        when "1000" => out_sig <= "0000000000000" & debug_control;
        when others => NULL;
    end case;

end process;

led <= x"00" & reg_dst_sig & rw_sig & alu_src_sig & ext_op_sig & mw_sig &mtg_sig & br_sig &j_sig;

end Behavioral;
