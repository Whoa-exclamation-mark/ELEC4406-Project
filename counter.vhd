LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;


ENTITY counter IS
	GENERIC (
				ADDR_SPACE	: 	INTEGER := 5
			);
	PORT (
				ADDR			:	OUT STD_LOGIC_VECTOR(ADDR_SPACE-1 DOWNTO 0);
				CLK,RST		:	IN STD_LOGIC
			);
END counter;

ARCHITECTURE counter_rtl OF counter IS

	SIGNAL count : INTEGER := 0;

BEGIN
	
	clk_proc: 
		PROCESS (CLK, RST)
		BEGIN
			IF (CLK'EVENT AND CLK = '1') THEN 
				IF (count < 2**ADDR_SPACE) THEN
					count <= count+1;
				ELSE 
					count <= 0;
				END IF;
			END IF;
			
			IF (RST = '1') THEN
				count <= 0;
			END IF;
		END PROCESS;
	
	ADDR <= std_logic_vector(to_unsigned(count, ADDR_SPACE));
	
END counter_rtl;