LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

USE STD.env.stop;
USE STD.env.finish;

ENTITY memory_block_tb IS
	GENERIC (
		ADDR_SPACE	: 	INTEGER := 5;
		BIT_LENGTH	:	INTEGER := 9
	);
END memory_block_tb;

ARCHITECTURE memory_block_tb_rtl OF memory_block_tb IS
	
	COMPONENT memory_block 
		GENERIC (
				ADDR_SPACE	: 	INTEGER := 5;
				BIT_LENGTH	:	INTEGER := 9
			);
		PORT (
				DATA_OUT		:	OUT STD_LOGIC_VECTOR(BIT_LENGTH-1 DOWNTO 0);
				CLK,RST		:	IN STD_LOGIC
			);
	END COMPONENT;
	
	SIGNAL DATA_OUT	: STD_LOGIC_VECTOR(BIT_LENGTH-1 DOWNTO 0);
	SIGNAL CLK			: STD_LOGIC;
	SIGNAL RST			: STD_LOGIC;

	CONSTANT T: TIME := 50 ns;
	
BEGIN

	CLOCK:
		CLK <=  not CLK after T/2;
	
	DUT: memory_block
		GENERIC MAP (	
				ADDR_SPACE	=> ADDR_SPACE,
				BIT_LENGTH	=> BIT_LENGTH
		)
		PORT MAP (		
				DATA_OUT		=>	DATA_OUT,
				CLK			=> CLK,
				RST			=>	RST
		);
		
	tb_proc: PROCESS
	BEGIN
		WAIT FOR T;
		
		stop;
		finish;
	END PROCESS;

END memory_block_tb_rtl;