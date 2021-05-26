-----------------------------------------------------------------------
-- lumin_board_fsm.vhd
-- Finite State Machine of project |Luminous Board| for VUTBR IVH 2021
-- Author: Vojtech Kalis, xkalis03
-----------------------------------------------------------------------
-- Soubor obsahuje konecny stavovy automat ktery ridi stavy vysledne 
-- animace
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity FSM is
port(
   CLK        : in std_logic;
   RST        : in std_logic;
   EN         : in std_logic;
	MODE_RIGHT : out std_logic;
	MODE_LEFT  : out std_logic;
	MODE_ANIM  : out std_logic;
	DELAY_ROTR : in std_logic;
	DELAY_ROTL : in std_logic;
	DELAY_ANIM : in std_logic
   );
end entity FSM;


architecture behavioral of FSM is
   type pstates is (ROT_RIGHT, ROT_LEFT, ANIMATION);
   signal pstate, nstate : pstates := ROT_RIGHT;

begin

   --Present State register
   pstate_reg: process(RST, nstate)
   begin
      if (RST = '1') then
         pstate <= ROT_RIGHT;
      else
         pstate <= nstate;
      end if;
   end process;
	
   --Next State logic
   nstate_logic: process(pstate, nstate, DELAY_ROTR, DELAY_ROTL, DELAY_ANIM)
   begin
      case pstate is
         when ROT_RIGHT => 
            nstate <= ROT_RIGHT;
            if DELAY_ROTR = '1' then
               nstate <= ROT_LEFT;
            end if;
         when ROT_LEFT =>
            nstate <= ROT_LEFT;
            if DELAY_ROTL = '1' then
               nstate <= ANIMATION;
            end if;
         when ANIMATION =>
            nstate <= ANIMATION;
            if DELAY_ANIM = '1' then
               nstate <= ROT_RIGHT;
            end if;
         when others => null;
      end case;
   end process;
	
   --Output logic
	output_logic: process (pstate)
	begin
      case pstate is
         when ROT_RIGHT => MODE_RIGHT <= '1';
			                  MODE_ANIM <= '0';
         when ROT_LEFT => MODE_LEFT <= '1';
			                 MODE_RIGHT <= '0';
         when ANIMATION => MODE_ANIM <= '1';
			                  MODE_LEFT <= '0';
         when others => MODE_RIGHT <= '0';
			               MODE_LEFT <= '0';
							   MODE_ANIM <= '0';
      end case;
   end process;

end behavioral;