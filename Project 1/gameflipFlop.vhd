----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2018 04:09:23 PM
-- Design Name: 
-- Module Name: flipFlop - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Refered from the lecture notes D Flip Flop
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity flipFlop is

Port (clock1 : in std_logic;
 
z: out std_logic);
end flipFlop;

architecture Behavioral of flipFlop is
signal c : std_logic_vector(1 downto 0);

begin 
process (clock1)

variable q : STD_LOGIC_VECTOR (17 downto 0);
    
begin
if rising_edge(clock1)  then
   q := q + 1;
    end if;
    c <= q(17 downto 16);
    z<= c(0);
    end process;
    end Behavioral;
