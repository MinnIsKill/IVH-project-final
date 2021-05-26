-------------------------------------------------------------------------
-- counter.vhd
-- Counter for project |Luminous Board| for IVH 2021
-- Author: Vojtech Kalis, xkalis03
-------------------------------------------------------------------------
-- Implementace casovace (citac s volitelnou frekvenci)
-- Citac ma 2 genericke param.: - frekvenci hodinoveho signalu (CLK_FREQ) 
-- 								- vystupni frekvekvenci (OUT_FREQ) 
-- 										(obe dve zadane v Hz).
-- Citac s frekvenci odpovidajici OUT_FREQ (t.j., napr 2x za sekundu) 
-- aktivuje na jeden hodinovy cyklus signal EN.
--
-- NOTE: do hlavniho souboru 'lumin_board.vhd' neni tenhle citac 
-- importovan, pouze samotny proces byl primo presunut (zkopirovan), pro
-- lepsi prehlednost
-------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- v pripade nutnosti muzete nacist dalsi knihovny
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity counter is
	Generic (
			CLK_FREQ : positive := 100000;	-- tady kdyztak prenastavit
			OUT_FREQ : positive := 1000);		-- tady kdyztak prenastavit
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           EN : out  STD_LOGIC);
end counter;

architecture Behavioral of counter is

-- zde je funkce log2 z prednasek, pravdepodobne se vam bude hodit.
	function log2(A: integer) return integer is
		variable bits : integer := 0;
		variable b : integer := 1;
	begin
		while (b <= a) loop
			b := b * 2;
			bits := bits + 1;
		end loop;
		return bits;
	end function;

	-- dalsi vase signaly

	signal counter : integer := 0;
	
begin
	
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
		--elsif (CLK'event) and (CLK = '0') then		-- puleni EN jeste na polovinu, myslel jsem ze ze zadani to je takhle spravne ale
														-- pak jsem zjistil ze se to ma nastavit na jeden hodinovy cyklus = jednu periodu CLK
		--	EN <= '0';
		end if;
	end process cnter;

end Behavioral;
