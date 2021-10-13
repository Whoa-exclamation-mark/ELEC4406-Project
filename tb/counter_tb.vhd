LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

USE STD.env.stop;
USE STD.env.finish;

ENTITY counter_tb IS
	GENERIC (
		ADDR_SPACE	: 	INTEGER := 4
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
	SIGNAL CLK		: STD_LOGIC := '0';
	SIGNAL RST		: STD_LOGIC := '0';
	
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
		WAIT FOR 3*T;
		
		-- Check if increments correctly
		ASSERT ADDR = (ADDR_SPACE-1 DOWNTO 2 => '0') & "11" REPORT "TEST 1 FAILED" SEVERITY NOTE;
		
		-- Check reset
		RST <= '1';
		WAIT FOR 5 ps;
		RST <= '0';
		ASSERT ADDR = (ADDR_SPACE-1 DOWNTO 2 => '0') & "00" REPORT "TEST 2 FAILED" SEVERITY NOTE;
		
		-- Check roll over
		WAIT FOR (2**ADDR_SPACE+1)*T;
		ASSERT ADDR = (ADDR_SPACE-1 DOWNTO 2 => '0') & "01" REPORT "TEST 3 FAILED" SEVERITY NOTE;
		
		stop;
		finish;
	END PROCESS;

END counter_tb_rtl;