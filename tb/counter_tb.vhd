LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

USE STD.env.stop;
USE STD.env.finish;

ENTITY counter_tb IS
	GENERIC (
		ADDR_SPACE	: 	INTEGER := 5
	);
END counter_tb;

ARCHITECTURE counter_tb_rtl OF counter_tb IS

	COMPONENT counter IS
		GENERIC (
			ADDR_SPACE	: 	INTEGER := 5
		);
		PORT (
			ADDR			:	OUT STD_LOGIC_VECTOR(ADDR_SPACE-1 DOWNTO 0);
			CLK,RST		:	IN STD_LOGIC
		);
	END COMPONENT;
	
	SIGNAL ADDR		: STD_LOGIC_VECTOR(ADDR_SPACE-1 DOWNTO 0);
	SIGNAL CLK		: STD_LOGIC;
	SIGNAL RST		: STD_LOGIC;
	
	CONSTANT T: TIME := 50 ns;
	
BEGIN

	CLOCK:
		CLK <=  not CLK after T/2;
	
	DUT: counter
		GENERIC MAP (	
				ADDR_SPACE	=> ADDR_SPACE
		)
		PORT MAP (		
				ADDR		=>	ADDR,
				CLK		=> CLK,
				RST		=>	RST
		);
		
	tb_proc: PROCESS
	BEGIN
		WAIT FOR T;
		
		stop;
		finish;
	END PROCESS;

END counter_tb_rtl;