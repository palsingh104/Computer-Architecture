-- Engineer:
--
-- Create Date: 03/28/2018 04:13:13 PM
-- Design Name:
-- Module Name: game - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
entity game is
Port (
sevenSeg: out std_logic_vector(6 downto 0);
switches: in std_logic_vector(3 downto 0);
led: out std_logic_vector(15 downto 0):="0000000000000000";--when board is switched on LEDS off
centerButton: in std_logic;
downButton: in std_logic;
lowerButton: in std_logic;
rightButton: in std_logic;
upperButton: in std_logic;
an: out std_logic_vector(3 downto 0);
basys_clk: in std_logic
);
end game;

architecture Behavioral of game is

shared variable temppp: integer:=0;
signal clockSlow: std_logic;
shared variable SCENARIO:integer:=1;

begin
div: entity work.flipFlop port map(clock1=>basys_clk,z=>clockSlow);

process (clockSlow, switches)

variable DIG1: std_logic_vector(3 downto 0);
variable DIG2: std_logic_vector(3 downto 0);
variable DIG3: std_logic_vector(3 downto 0);
variable DIG4: std_logic_vector(3 downto 0);
variable DIG: std_logic_vector(15 downto 0);
variable answitcheser:integer:=0;
variable PL1: std_logic_vector(15 downto 0);
variable PL2: std_logic_vector(15 downto 0);
variable guesses:integer:=0;
variable guessesBinary:std_logic_vector(15 downto 0);
variable in_val: std_logic_vector(15 downto 0);
variable i:integer:=0;
variable temp:integer:=0;

begin
if rising_edge(clockSlow) then
temppp := temppp + 1;

if downButton = '1' then DIG(3 downto 0) := switches(3 downto 0);
end if;
if rightButton = '1' then DIG(7 downto 4) := switches(3 downto 0);
end if;
if upperButton = '1' then DIG(11 downto 8) := switches(3 downto 0);
end if;
if lowerButton = '1' then DIG(15 downto 12) := switches(3 downto 0);
end if;

if i=0 then in_val:=DIG; end if;
i:=i+1;

if DIG/= in_val then
in_val:=DIG;
DIG1 := DIG(3 downto 0);
DIG2 := DIG(7 downto 4);
DIG3 := DIG(11 downto 8);
DIG4 := DIG(15 downto 12);
if (SCENARIO = 1 or SCENARIO = 6) then
SCENARIO:=1;
elsif SCENARIO = 2 or SCENARIO = 3 or SCENARIO = 4 or SCENARIO = 7 then
SCENARIO:=2;
end if;
end if;

if centerButton = '1' and temppp>360 then

if SCENARIO = 1 or SCENARIO = 6 then

PL1 := DIG;

SCENARIO := 2;
temppp:=0;

case answitcheser is
when 0=> sevenSeg <= "0100100"; an <= "1110"; answitcheser := answitcheser + 1; 
when 1=> sevenSeg <= "0111111"; an <= "1101"; answitcheser := answitcheser + 1;
when 2=> sevenSeg <= "1000111"; an <= "1011"; answitcheser := answitcheser + 1;
when 3=> sevenSeg <= "0001100"; an <= "0111"; answitcheser := 0;
when others=>null;
end case;

elsif SCENARIO = 2 or SCENARIO = 3 or SCENARIO = 4 or SCENARIO = 7 then

guesses:=guesses + 1;

PL2 := DIG;
if PL2 > PL1 then
SCENARIO:=3;   --HIGHHHHHHHHHHHHH
temppp:=0;

elsif PL2 < PL1 then

SCENARIO:=4;   --LOWWWWWWWWWWWWWW
temppp:=0;
else
SCENARIO:=5;   --WINNNIINGGGGGGGGG
temppp:=0;
end if;
end if;
end if;

if SCENARIO = 1 then 
case answitcheser is
when 0=> sevenSeg <= "1111001"; an <= "1110"; answitcheser := answitcheser + 1; 
when 1=> sevenSeg <= "0111111"; an <= "1101"; answitcheser := answitcheser + 1;
when 2=> sevenSeg <= "1000111"; an <= "1011"; answitcheser := answitcheser + 1;
when 3=> sevenSeg <= "0001100"; an <= "0111"; answitcheser := 0;
when others=>null;
end case;

elsif SCENARIO = 2 then 
case answitcheser is
when 0=> sevenSeg <= "0100100"; an <= "1110"; answitcheser := answitcheser + 1; 
when 1=> sevenSeg <= "0111111"; an <= "1101"; answitcheser := answitcheser + 1;
when 2=> sevenSeg <= "1000111"; an <= "1011"; answitcheser := answitcheser + 1;
when 3=> sevenSeg <= "0001100"; an <= "0111"; answitcheser := 0;
when others=>null;
end case;

elsif SCENARIO = 3 then --2-HI
case answitcheser is
when 0=> sevenSeg <= "1001111"; an <= "1110"; answitcheser := answitcheser + 1; 
when 1=> sevenSeg <= "0001001"; an <= "1101"; answitcheser := answitcheser + 1;
when 2=> sevenSeg <= "1111111"; an <= "1011"; answitcheser := answitcheser + 1;
when 3=> sevenSeg <= "0100100"; an <= "0111"; answitcheser := 0;
when others=>null;
end case;

elsif SCENARIO = 4 then--2-LO
case answitcheser is
when 0=> sevenSeg <= "1000000"; an <= "1110"; answitcheser := answitcheser + 1; 
when 1=> sevenSeg <= "1000111"; an <= "1101"; answitcheser := answitcheser + 1;
when 2=> sevenSeg <= "1111111"; an <= "1011"; answitcheser := answitcheser + 1;
when 3=> sevenSeg <= "0100100"; an <= "0111"; answitcheser := 0;
when others=>null;
end case;

elsif SCENARIO = 5 then 

guessesBinary := std_logic_vector(to_unsigned(guesses, guessesBinary'length));
DIG1 := guessesBinary(3 downto 0);
DIG2 := guessesBinary(7 downto 4);
DIG3 := guessesBinary(11 downto 8);
DIG4 := guessesBinary(15 downto 12);

case answitcheser is

when 0=>
an<="1110";
case DIG1 is
when "0000" => sevenSeg<="1000000";
when "0001" => sevenSeg<="1111001";
when "0010" => sevenSeg<="0100100";
when "0011" => sevenSeg<="0110000";
when "0100" => sevenSeg<="0011001";
when "0101" => sevenSeg<="0010010";
when "0110" => sevenSeg<="0000010";
when "0111" => sevenSeg<="1111000";
when "1000" => sevenSeg<="0000000";
when "1001" => sevenSeg<="0011000";
when "1010" => sevenSeg<="0001000";
when "1011" => sevenSeg<="0000011";
when "1100" => sevenSeg<="1000110";
when "1101" => sevenSeg<="0100001";
when "1110" => sevenSeg<="0000110";
when "1111" => sevenSeg<="0001110";
when others=>null;
end case;
answitcheser := answitcheser + 1; 
when 1=>
an<="1101";
case DIG2 is
when "0000" => sevenSeg<="1000000";
when "0001" => sevenSeg<="1111001";
when "0010" => sevenSeg<="0100100";
when "0011" => sevenSeg<="0110000";
when "0100" => sevenSeg<="0011001";
when "0101" => sevenSeg<="0010010";
when "0110" => sevenSeg<="0000010";
when "0111" => sevenSeg<="1111000";
when "1000" => sevenSeg<="0000000";
when "1001" => sevenSeg<="0011000";
when "1010" => sevenSeg<="0001000";
when "1011" => sevenSeg<="0000011";
when "1100" => sevenSeg<="1000110";
when "1101" => sevenSeg<="0100001";
when "1110" => sevenSeg<="0000110";
when "1111" => sevenSeg<="0001110";
when others=>null;
end case;
answitcheser := answitcheser + 1;

when 2=>
an<="1011";
case DIG3 is
when "0000" => sevenSeg<="1000000";
when "0001" => sevenSeg<="1111001";
when "0010" => sevenSeg<="0100100";
when "0011" => sevenSeg<="0110000";
when "0100" => sevenSeg<="0011001";
when "0101" => sevenSeg<="0010010";
when "0110" => sevenSeg<="0000010";
when "0111" => sevenSeg<="1111000";
when "1000" => sevenSeg<="0000000";
when "1001" => sevenSeg<="0011000";
when "1010" => sevenSeg<="0001000";
when "1011" => sevenSeg<="0000011";
when "1100" => sevenSeg<="1000110";
when "1101" => sevenSeg<="0100001";
when "1110" => sevenSeg<="0000110";
when "1111" => sevenSeg<="0001110";

when others=>null;
end case;
answitcheser := answitcheser + 1;
when 3=>
an<="0111";
case DIG4 is
when "0000" => sevenSeg<="1000000";
when "0001" => sevenSeg<="1111001";
when "0010" => sevenSeg<="0100100";
when "0011" => sevenSeg<="0110000";
when "0100" => sevenSeg<="0011001";
when "0101" => sevenSeg<="0010010";
when "0110" => sevenSeg<="0000010";
when "0111" => sevenSeg<="1111000";
when "1000" => sevenSeg<="0000000";
when "1001" => sevenSeg<="0011000";
when "1010" => sevenSeg<="0001000";
when "1011" => sevenSeg<="0000011";
when "1100" => sevenSeg<="1000110";
when "1101" => sevenSeg<="0100001";
when "1110" => sevenSeg<="0000110";
when "1111" => sevenSeg<="0001110";
when others=>null;
end case;
answitcheser := 0;
when others=>null;
end case;
elsif SCENARIO = 6 then

case answitcheser is
when 0=>
an<="1110";
case DIG1 is
when "0000" => sevenSeg<="1000000";
when "0001" => sevenSeg<="1111001";
when "0010" => sevenSeg<="0100100";
when "0011" => sevenSeg<="0110000";
when "0100" => sevenSeg<="0011001";
when "0101" => sevenSeg<="0010010";
when "0110" => sevenSeg<="0000010";
when "0111" => sevenSeg<="1111000";
when "1000" => sevenSeg<="0000000";
when "1001" => sevenSeg<="0011000";
when "1010" => sevenSeg<="0001000";
when "1011" => sevenSeg<="0000011";
when "1100" => sevenSeg<="1000110";
when "1101" => sevenSeg<="0100001";
when "1110" => sevenSeg<="0000110";
when "1111" => sevenSeg<="0001110";
when others=>null;
end case;
answitcheser := answitcheser + 1; 
when 1=>
an<="1101";
case DIG2 is
when "0000" => sevenSeg<="1000000";
when "0001" => sevenSeg<="1111001";
when "0010" => sevenSeg<="0100100";
when "0011" => sevenSeg<="0110000";
when "0100" => sevenSeg<="0011001";
when "0101" => sevenSeg<="0010010";
when "0110" => sevenSeg<="0000010";
when "0111" => sevenSeg<="1111000";
when "1000" => sevenSeg<="0000000";
when "1001" => sevenSeg<="0011000";
when "1010" => sevenSeg<="0001000";
when "1011" => sevenSeg<="0000011";
when "1100" => sevenSeg<="1000110";
when "1101" => sevenSeg<="0100001";
when "1110" => sevenSeg<="0000110";
when "1111" => sevenSeg<="0001110";
when others=>null;
end case;
answitcheser := answitcheser + 1;
when 2=>
an<="1011";
case DIG3 is
when "0000" => sevenSeg<="1000000";
when "0001" => sevenSeg<="1111001";
when "0010" => sevenSeg<="0100100";
when "0011" => sevenSeg<="0110000";
when "0100" => sevenSeg<="0011001";
when "0101" => sevenSeg<="0010010";
when "0110" => sevenSeg<="0000010";
when "0111" => sevenSeg<="1111000";
when "1000" => sevenSeg<="0000000";
when "1001" => sevenSeg<="0011000";
when "1010" => sevenSeg<="0001000";
when "1011" => sevenSeg<="0000011";
when "1100" => sevenSeg<="1000110";
when "1101" => sevenSeg<="0100001";
when "1110" => sevenSeg<="0000110";
when "1111" => sevenSeg<="0001110";
when others=>null;
end case;
answitcheser := answitcheser + 1;
when 3=>
an<="0111";
case DIG4 is
when "0000" => sevenSeg<="1000000";
when "0001" => sevenSeg<="1111001";
when "0010" => sevenSeg<="0100100";
when "0011" => sevenSeg<="0110000";
when "0100" => sevenSeg<="0011001";
when "0101" => sevenSeg<="0010010";
when "0110" => sevenSeg<="0000010";
when "0111" => sevenSeg<="1111000";
when "1000" => sevenSeg<="0000000";
when "1001" => sevenSeg<="0011000";
when "1010" => sevenSeg<="0001000";
when "1011" => sevenSeg<="0000011";
when "1100" => sevenSeg<="1000110";
when "1101" => sevenSeg<="0100001";
when "1110" => sevenSeg<="0000110";
when "1111" => sevenSeg<="0001110";
when others=>null;
end case;
answitcheser := 0;
when others=>null;
end case;
elsif SCENARIO = 7 then
case answitcheser is
when 0=>
an<="1110";
case DIG1 is
when "0000" => sevenSeg<="1000000";
when "0001" => sevenSeg<="1111001";
when "0010" => sevenSeg<="0100100";
when "0011" => sevenSeg<="0110000";
when "0100" => sevenSeg<="0011001";
when "0101" => sevenSeg<="0010010";
when "0110" => sevenSeg<="0000010";
when "0111" => sevenSeg<="1111000";
when "1000" => sevenSeg<="0000000";
when "1001" => sevenSeg<="0011000";
when "1010" => sevenSeg<="0001000";
when "1011" => sevenSeg<="0000011";
when "1100" => sevenSeg<="1000110";
when "1101" => sevenSeg<="0100001";
when "1110" => sevenSeg<="0000110";
when "1111" => sevenSeg<="0001110";

when others=>null;
end case;
answitcheser := answitcheser + 1; 

when 1=>
an<="1101";
case DIG2 is
when "0000" => sevenSeg<="1000000";
when "0001" => sevenSeg<="1111001";
when "0010" => sevenSeg<="0100100";
when "0011" => sevenSeg<="0110000";
when "0100" => sevenSeg<="0011001";
when "0101" => sevenSeg<="0010010";
when "0110" => sevenSeg<="0000010";
when "0111" => sevenSeg<="1111000";
when "1000" => sevenSeg<="0000000";
when "1001" => sevenSeg<="0011000";
when "1010" => sevenSeg<="0001000";
when "1011" => sevenSeg<="0000011";
when "1100" => sevenSeg<="1000110";
when "1101" => sevenSeg<="0100001";
when "1110" => sevenSeg<="0000110";
when "1111" => sevenSeg<="0001110";

when others=>null;
end case;
answitcheser := answitcheser + 1;

when 2=>
an<="1011";
case DIG3 is
when "0000" => sevenSeg<="1000000";
when "0001" => sevenSeg<="1111001";
when "0010" => sevenSeg<="0100100";
when "0011" => sevenSeg<="0110000";
when "0100" => sevenSeg<="0011001";
when "0101" => sevenSeg<="0010010";
when "0110" => sevenSeg<="0000010";
when "0111" => sevenSeg<="1111000";
when "1000" => sevenSeg<="0000000";
when "1001" => sevenSeg<="0011000";
when "1010" => sevenSeg<="0001000";
when "1011" => sevenSeg<="0000011";
when "1100" => sevenSeg<="1000110";
when "1101" => sevenSeg<="0100001";
when "1110" => sevenSeg<="0000110";
when "1111" => sevenSeg<="0001110";

when others=>null;
end case;
answitcheser := answitcheser + 1;

when 3=>
an<="0111";
case DIG4 is
when "0000" => sevenSeg<="1000000";
when "0001" => sevenSeg<="1111001";
when "0010" => sevenSeg<="0100100";
when "0011" => sevenSeg<="0110000";
when "0100" => sevenSeg<="0011001";
when "0101" => sevenSeg<="0010010";
when "0110" => sevenSeg<="0000010";
when "0111" => sevenSeg<="1111000";
when "1000" => sevenSeg<="0000000";
when "1001" => sevenSeg<="0011000";
when "1010" => sevenSeg<="0001000";
when "1011" => sevenSeg<="0000011";
when "1100" => sevenSeg<="1000110";
when "1101" => sevenSeg<="0100001";
when "1110" => sevenSeg<="0000110";
when "1111" => sevenSeg<="0001110";
when others=>null;
end case;
answitcheser := 0;
when others=>null;
end case;
end if;
end if;
end process;
--FLASHHHHHHHHHHHHHHHHHHHHHH
process (clockSlow)
variable val_LED:integer:=1;
variable temppp: integer:=0;

begin
if rising_edge(clockSlow) then
temppp := temppp + 1;
if SCENARIO = 5 and temppp>190 then
if val_LED = 1 then
led <= "1111111111111111";
val_LED := 0;
else
led <= "0000000000000000";
val_LED := 1;
end if;
temppp:=0;
end if;
end if;
end process;
end Behavioral;