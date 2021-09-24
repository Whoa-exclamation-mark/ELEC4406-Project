-- TODO Create testbench

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY register_parallel IS
	GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9
		);
	PORT(		
				DATA_IN		:	IN STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
				CTRL			: 	IN STD_LOGIC;
				CLK			:	IN STD_LOGIC;
				DATA_OUT		:	OUT STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0)
		);
END register_parallel;

ARCHITECTURE register_parallel_rtl OF register_parallel IS

	SIGNAL Q : STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN

	CLK_PROCESS:
		PROCESS (CLK) BEGIN
			IF(CLK'EVENT AND CLK = '1' AND CTRL = '1') THEN
				Q <= DATA_IN;
			END IF;
		END PROCESS;
	
	DATA_OUT <= Q;

END;