LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

USE STD.env.stop;
USE STD.env.finish;

ENTITY register_parallel_tb IS
	GENERIC(	
		BIT_LENGTH	: 	INTEGER := 9
	);
END register_parallel_tb;

ARCHITECTURE register_parallel_tb_rtl OF register_parallel_tb IS

	COMPONENT register_parallel 
		GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9
		);
		PORT(		
				DATA_IN		:	IN STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
				CTRL			: 	IN STD_LOGIC;
				CLK			:	IN STD_LOGIC;
				DATA_OUT		:	OUT STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0)
		);
	END COMPONENT;
	
	SIGNAL DATA_IN		:	STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL CTRL			: 	STD_LOGIC := '0';
	SIGNAL CLK			:	STD_LOGIC := '0';
	SIGNAL DATA_OUT	:	STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0) := (OTHERS => '0');
	
	CONSTANT T: TIME := 50 ns;

BEGIN
	
	CLOCK:
		CLK <=  not CLK after T/2;
	
	DUT : register_parallel
		GENERIC MAP (	
				BIT_LENGTH	=> BIT_LENGTH
		)
		PORT MAP (		
				DATA_IN		=>	DATA_IN,
				CTRL			=> CTRL,
				CLK			=>	CLK,
				DATA_OUT		=>	DATA_OUT
		);
		
	tb_proc: PROCESS
	BEGIN
		WAIT FOR T;
		
		-- test for no control input
		DATA_IN <= (BIT_LENGTH - 1 DOWNTO 2 => '0') & "01";
		WAIT FOR T;
		
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 0 =>'0') REPORT "TEST 1 FAILED" SEVERITY NOTE;
	
		-- test for control input
		CTRL <= '1';
		WAIT FOR T;
		
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 2 => '0') & "01" REPORT "TEST 2 FAILED" SEVERITY NOTE;
		
		-- test for changing signal mid way through
		WAIT FOR T/2;
		DATA_IN <= (BIT_LENGTH - 1 DOWNTO 2 => '0') & "11";
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 2 => '0') & "01" REPORT "TEST 2 FAILED" SEVERITY NOTE;
		WAIT FOR 5*T/2;
		
		stop;
		finish;
	END PROCESS;
	
END register_parallel_tb_rtl;