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
	
	SIGNAL DATA_OUT	: STD_LOGIC_VECTOR(BIT_LENGTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL CLK			: STD_LOGIC := '0';
	SIGNAL RST			: STD_LOGIC := '0';

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
		WAIT FOR 1 ps;
		-- Starts at blank
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 0 => '0') REPORT "TEST 1 FAILED" SEVERITY NOTE;
		
		-- Test first memory cell
		WAIT FOR T;
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 2 => '0') & "01" REPORT "TEST 2 FAILED" SEVERITY NOTE;
		
		-- Test second memory cell
		WAIT FOR T;
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 2 => '0') & "11" REPORT "TEST 3 FAILED" SEVERITY NOTE;
		
		-- Test reset memory cell
		WAIT FOR T;
		RST <= '1';
		WAIT FOR 1 ps;
		RST <= '0';
		WAIT FOR 1 ps;
		-- it is sync from the memory def
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 4 => '0') & "1001" REPORT "TEST 4 FAILED" SEVERITY NOTE;
		
		-- Test reset memory cell / 1st memory cell
		WAIT FOR T;
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 2 => '0') & "01" REPORT "TEST 5 FAILED" SEVERITY NOTE;
		
		-- Test reset memory cell / 2nd memory cell
		WAIT FOR T;
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 2 => '0') & "11" REPORT "TEST 5 FAILED" SEVERITY NOTE;
		
		stop;
		finish;
	END PROCESS;

END memory_block_tb_rtl;