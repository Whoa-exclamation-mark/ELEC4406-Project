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
	
	SIGNAL DATA_IN		:	STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
	SIGNAL CTRL			: 	STD_LOGIC;
	SIGNAL CLK			:	STD_LOGIC;
	SIGNAL DATA_OUT	:	STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
	
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
		
		stop;
		finish;
	END PROCESS;
	
END register_parallel_tb_rtl;