-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Wed Mar  2 10:36:31 2022
-- Host        : DESKTOP-DSD2UUK running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/GitHub/ESDII-Lab4/blink/src/ip/design_1_blink_0_0/design_1_blink_0_0_stub.vhdl
-- Design      : design_1_blink_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-3
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_blink_0_0 is
  Port ( 
    clk : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    blink_out : out STD_LOGIC
  );

end design_1_blink_0_0;

architecture stub of design_1_blink_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,reset_n,blink_out";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blink,Vivado 2019.1";
begin
end;
