-----------------------------------------------------------------------
-- matrix_pack.vhd
-- Package of functions used in project |Luminous Board| for IVH 2021
-- Author: Vojtech Kalis, xkalis03
-----------------------------------------------------------------------
-- Soubor deklaruje balicek matrix_pack obsahujici funkci GETID, ktera
-- bere na vstupu hodnoty X, Y, ROWS, COLS a vypocita z nich hodnotu
-- adresy pouzite pro indexaci vektoru o delce ROWS * COLS (neboli
-- mapovani souradnic 2D pole do souradnic 1D pole).
--
-- Balicek take obsahuje vypoctovy typ DIRECTION_T, obsahujici smer 
-- doleva (DIR_LEFT), doprava (DIR_RIGHT) a stav pro animaci (IDLE).
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package matrix_pack is

    type DIRECTION_T is (DIR_LEFT, DIR_RIGHT, IDLE);

    function GETID (X: integer; 
                    Y: integer;
                    ROWS: integer;
                    COLS: integer)
    return integer;

end matrix_pack;


-- X a Y indexovane od 0, COLS a ROWS od 1
package body matrix_pack is
    function GETID (X: integer;
                    Y: integer;
                    ROWS: integer;
                    COLS: integer)
    return integer is
		  variable x_var: integer := X;
		  variable y_var: integer := Y;
        begin
            -- if X is outside of scope
            if x_var < 0 then
                while x_var < 0 loop
                    x_var := COLS+x_var;
                end loop;
            else if x_var >= COLS then
                while x_var >= COLS loop
                    x_var := x_var-COLS;
                end loop;
            end if;
            end if;
        
            -- if Y is outside of scope
            if y_var < 0 then
                while y_var < 0 loop
                    y_var := ROWS+y_var;
                end loop;
            else if y_var >= ROWS then
                while y_var >= ROWS loop
                    y_var := y_var-ROWS;
                end loop;
            end if;
            end if;

            -- calculation of index

            return ((ROWS*x_var)+y_var);
    end GETID;
end matrix_pack;