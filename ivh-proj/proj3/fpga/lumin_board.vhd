-----------------------------------------------------------------------
-- lumin_board.vhd
-- Main file of project |Luminous Board| for VUTBR IVH 2021
-- Author: Vojtech Kalis, xkalis03
-----------------------------------------------------------------------
-- Soubor deklaruje entitu cell (bunka), jez je implementovana jako
-- soustava 128 navzajem propojenych bunek schopnych vzajemne lokalni
-- komunikace
--
-- Kazda bunka ma na starosti rizeni svitu jedne LED diody maticoveho
-- displeje, jenz je rizen v souboru 'display.vhd', ktery je importovan
--
-- Cely proces ridi Finite State Machine (FSM), implementovan v souboru
-- 'lumin_board_fsm.vhd', a dale procesy 'modedelay' a 'processor'
-- obsazeny v tomhle souboru
--
-- Citac je take implementovan primo v tomhle souboru.
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.matrix_pack.all;

architecture main of tlv_gp_ifc is
    
   component cell 
      port( CLK : in std_logic;
            RESET : in std_logic;
            EN : in std_logic;
            STATE : out std_logic;
            INIT_STATE : in std_logic;
            NEIGH_RIGHT : in std_logic;
            NEIGH_LEFT : in std_logic;
            DIRECTION : in direction_t
       );
   end component;

   constant CLK_FREQ : positive := 25000000;
   constant OUT_FREQ : positive := 25; --pocet snimku za sekundu
   signal A : std_logic_vector(3 downto 0) := (others => '0');
   signal R : std_logic_vector(7 downto 0); 

   signal DATA_INIT : std_logic_vector(127 downto 0) :=
         "0000000001100000" &
         "0000000110000000" &
         "0000000100000000" &
         "0000001110000000" &
         "0000011011000000" &
         "0000011101000000" &
         "0000011111000000" &
         "0000001110000000";
   signal DATA : std_logic_vector(127 downto 0) := DATA_INIT;

   signal EN : std_logic := '0';
   signal DIRECTION : direction_t := dir_right;

   signal mov_cnt : integer range 0 to 143 := 0;

   signal mode_r : std_logic := '0';
   signal mode_l : std_logic := '0';
   signal mode_a : std_logic := '0';

   signal delay_rotr : std_logic := '0';
   signal delay_rotl : std_logic := '0';
   signal delay_anim : std_logic := '0';

   signal counter : integer := 0;
begin
   ------------------------------------------------
   --               CELLS GENERATOR              --
   ------------------------------------------------
   gen1: for R in 0 to 7 generate
      gen2: for C in 0 to 15 generate
         cell_gen: cell port map(
            CLK => CLK,
            RESET => RESET,
            EN => EN,
            STATE => DATA(R*16+C),
            INIT_STATE => DATA_INIT(R*16+C),
            NEIGH_RIGHT => DATA(GETID(R,C+1,16,8)),
            NEIGH_LEFT => DATA(GETID(R,C-1,16,8)),
            DIRECTION => DIRECTION
         );
      end generate;
   end generate;

   ------------------------------------------------
   --             IMPORTING FSM UNIT             --
   ------------------------------------------------
   FSM: entity work.FSM(behavioral)
   port map(
      CLK => CLK,
      RST => RESET,
      EN => EN,
      MODE_RIGHT => mode_r,
      MODE_LEFT => mode_l,
      MODE_ANIM => mode_a,
      DELAY_ROTR => delay_rotr,
      DELAY_ROTL => delay_rotl,
      DELAY_ANIM => delay_anim
   );

   ------------------------------------------------
   --           IMPORTING DISPLAY UNIT           --
   ------------------------------------------------
   dis : entity work.display 
   port map (
      CLK => CLK,
      RESET => RESET,
      DATA => DATA,
      A => A,
      R => R
   );

   ------------------------------------------------
   --           COUNTER FOR ROTATIONS            --
   ------------------------------------------------
   cnter: process(RESET, CLK, counter)
   begin
      if (RESET = '1') then
         counter <= 0;
         EN <= '0';	
      elsif (CLK'event) and (CLK = '1') then
         counter <= counter + 1;
         if (counter = ((CLK_FREQ/OUT_FREQ)-1)) then
            EN <= '1';
            counter <= 0;
         else
            EN <= '0';
         end if;
      end if;
   end process cnter;

   ------------------------------------------------
   --              MODE DELAY LOGIC              --
   ------------------------------------------------
   modedelay: process(CLK, RESET, EN, mov_cnt)
   begin
      if RESET = '1' then
         delay_rotr <= '0';
         delay_rotl <= '0';
         delay_anim <= '0';
         mov_cnt <= 0;
      elsif EN = '1' and rising_edge(CLK) then
         mov_cnt <= mov_cnt + 1;
         if mov_cnt = 47 then
            delay_rotr <= '1';
				delay_rotl <= '0';
				delay_anim <= '0';
			elsif mov_cnt = 95 then
				delay_rotr <= '0';
				delay_rotl <= '1';
				delay_anim <= '0';
			elsif mov_cnt = 143 then
			   delay_rotr <= '0';
				delay_rotl <= '0';
				delay_anim <= '1';
				mov_cnt <= 0;
			else
			   delay_rotr <= '0';
				delay_rotl <= '0';
				delay_anim <= '0';
			end if;
		end if;
	end process modedelay;
	
	------------------------------------------------
   --               MODE SWITCHER                --
   ------------------------------------------------
	processor: process(CLK, RESET, mode_r, mode_l, mode_a)
	begin
		if RESET = '1' then
			DIRECTION <= idle;
		elsif rising_edge(CLK) then
			if mode_r = '1' then
				DIRECTION <= dir_right;
			elsif mode_l = '1' then
				DIRECTION <= dir_left;
			elsif mode_a = '1' then
				DIRECTION <= idle;
			end if;
		end if;
	end process processor;

   ------------------------------------------------
   --              MAPPING OF OUTPUT             --
   ------------------------------------------------
    X(6) <= A(3);
    X(8) <= A(1);
    X(10) <= A(0);
    X(7) <= '0'; -- en_n
    X(9) <= A(2);

    X(16) <= R(1);
    X(18) <= R(0);
    X(20) <= R(7);
    X(22) <= R(2);
  
    X(17) <= R(4);
    X(19) <= R(3);
    X(21) <= R(6);
    X(23) <= R(5);
	 
end main;