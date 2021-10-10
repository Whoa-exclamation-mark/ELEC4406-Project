LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

USE STD.env.stop;
USE STD.env.finish;

ENTITY register_block_tb IS
	GENERIC(	
		BIT_LENGTH	: 	INTEGER := 9;
		REG_NUM		:	INTEGER := 8
	);
END register_block_tb;

ARCHITECTURE register_block_tb_rtl OF register_block_tb IS

	COMPONENT register_block IS
		GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9;
				REG_NUM		:	INTEGER := 8
		);
		PORT(		
				DATA_IN		:	IN STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
				CTRL			: 	IN STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0);
				CLK			:	IN STD_LOGIC;
				SEL			:	IN INTEGER;
				DATA_OUT		:	OUT STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0)
		);
	END COMPONENT;
	
	SIGNAL DATA_IN		:	STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
	SIGNAL CTRL			: 	STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0);
	SIGNAL CLK			:	STD_LOGIC;
	SIGNAL SEL			:	INTEGER;
	SIGNAL DATA_OUT	:	STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
	
	CONSTANT T: TIME := 50 ns;
	
BEGIN

	CLOCK:
		CLK <=  not CLK after T/2;
	
	DUT : register_block
		GENERIC MAP (	
				BIT_LENGTH	=> BIT_LENGTH,
				REG_NUM		=> REG_NUM
		)
		PORT MAP (		
				DATA_IN		=>	DATA_IN,
				CTRL			=> CTRL,
				CLK			=>	CLK,
				SEL			=>	SEL,
				DATA_OUT		=>	DATA_OUT
		);
		
	tb_proc: PROCESS
	BEGIN
		WAIT FOR T;
		
		stop;
		finish;
	END PROCESS;

END register_block_tb_rtl;