-----------------------------------------------------------------------
-- cell.vhd
-- Cell rotation logic declaration file of project |Luminous Board| for
--      VUTBR IVH 2021
-- Author: Vojtech Kalis, xkalis03
-----------------------------------------------------------------------
-- Soubor zpracovava jednotlive bunky a ridi jejich rotaci a vyslednou 
-- animaci
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.matrix_pack.all;

entity cell is 
    port (
        CLK   : in std_logic; 
        RESET : in std_logic;
        EN    : in std_logic;
        STATE : out std_logic;
        INIT_STATE : in std_logic;
        NEIGH_RIGHT : in std_logic;
        NEIGH_LEFT : in std_logic;
        DIRECTION  : in direction_t
    );
end entity cell;

architecture behav of cell is
    
    signal cnter    : integer range 0 to 47 := 0;
	 
begin

   cell: process(clk,reset)
   begin 
      if RESET = '1' then
         STATE <= INIT_STATE;
      elsif rising_edge(CLK) and EN = '1' then
         if DIRECTION = DIR_RIGHT then
            STATE <= NEIGH_RIGHT;
         elsif DIRECTION = DIR_LEFT then
            STATE <= NEIGH_LEFT;
         elsif DIRECTION = IDLE then
            STATE <= not INIT_STATE;
            cnter <= cnter + 1;
            if cnter = 47 then
               STATE <= INIT_STATE;
               cnter <= 0;
            end if;
         else 
            STATE <= INIT_STATE;
         end if;
      end if;     
   end process;
        
end behav;