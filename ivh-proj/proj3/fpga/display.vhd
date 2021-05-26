-------------------------------------------------------------------------
-- display.vhd
-- Display unit used in project |Luminous Board| for IVH 2021
-- Author: Vojtech Kalis, xkalis03
-------------------------------------------------------------------------
-- Soubor obsahuje jednotku ktera ridi zosvecovani displeje, avsak 
-- samotne nastaveni vystupu zde neprobiha
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity display is
   port (
      data : in std_logic_vector(127 downto 0); -- data k zobrazeni, format je na popsany dole
      reset : in std_logic;
      clk : in std_logic; -- hodiny 25 MHz
      A : out std_logic_vector(3 downto 0); -- adresa sloupce (0000 -> 0001 -> 0010 -> 0011 -> ..... -> 1111)
      R : out std_logic_vector(7 downto 0) -- row (ale tady to je jako sloupec, jako ze udava to ktery radek v danem sloupci ma svitit)
   );
end entity display;


architecture behv of display is
   
   signal A_temp : std_logic_vector(3 downto 0) := (others => '1');
   signal R_temp : std_logic_vector(7 downto 0); 

   constant delay1 : natural := 3999; -- = KOLIK CLK NAVIC TO DRZI SLOUPCE (0 = drzi pouze 1 CLK)

   signal increm : integer := 0;
   signal EN : std_logic := '1';
   signal delayy : integer := 0;
   signal flag : std_logic;

begin

   --cnter ktery dela delay mezi prechazenim mezi sloupcema
   cnter2: process(RESET, CLK)
   begin
      if (RESET = '1') then
         EN <= '0';
         delayy <= delay1;
      elsif (CLK'event) and (CLK = '1') then					
         delayy <= delayy + 1;
         if (delayy >= delay1) then
            EN <= '1';
            delayy <= 0;
         else
            EN <= '0';
         end if;
      end if;
   end process cnter2;

   -- display
   displayy: process(A_temp, data, CLK, reset, EN, flag)
   begin
      if (reset = '1') then
         A_temp <= (others => '1');
         R_temp <= (others => '0');
         flag <= '1';
      elsif (CLK = '1' and clk'event and EN = '1') then
         if (A_temp /= "1111") then
            A_temp <= A_temp + 1;
         else
            A_temp <= (others => '0');
         end if;

         case A_temp is
            when "0000" => increm <= 2; -- z nejakeho duvodu to musim loadit takhle (o 2 dopredu) aby to na FitKitu i v simulaci zobrazovalo spravne
            when "0001" => increm <= 3;
            when "0010" => increm <= 4;
            when "0011" => increm <= 5;
            when "0100" => increm <= 6;
            when "0101" => increm <= 7;
            when "0110" => increm <= 8;
            when "0111" => increm <= 9;
            --
            when "1000" => increm <= 10;
            when "1001" => increm <= 11;
            when "1010" => increm <= 12;
            when "1011" => increm <= 13;
            when "1100" => increm <= 14;
            when "1101" => increm <= 15;
            when "1110" => increm <= 0;
            when "1111" => increm <= 1;
            when others => null;
         end case;

         if (flag = '1') then
            flag <= '0';
            R_temp <= data(127-(2+112)) & data(127-(0+96)) & data(127-(0+80)) & data(127-(0+64)) & data(127-(0+48)) & data(127-(0+32)) & data(127-(0+16)) & data(127-(0+0));
         else
            R_temp <= data(127-(increm+112)) & data(127-(increm+96)) & data(127-(increm+80)) & data(127-(increm+64)) & data(127-(increm+48)) & data(127-(increm+32)) & data(127-(increm+16)) & data(127-(increm+0));
         end if;

      end if;
      A <= A_temp;
      R <= R_temp;
   end process;
	

end behv;
