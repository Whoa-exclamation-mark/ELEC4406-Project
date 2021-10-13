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
	
	SIGNAL DATA_IN		:	STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL CTRL			: 	STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL CLK			:	STD_LOGIC := '0';
	SIGNAL SEL			:	INTEGER := 0;
	SIGNAL DATA_OUT	:	STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0) := (OTHERS => '0');
	
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
		
		-- test for no control input
		DATA_IN <= (BIT_LENGTH - 1 DOWNTO 2 => '0') & "01";
		WAIT FOR T;
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 0 =>'0') REPORT "TEST 1 FAILED" SEVERITY NOTE;
		
		-- test for control input (and also setup a later test)
		CTRL <= (REG_NUM - 1 DOWNTO 3 => '0') & "101";
		WAIT FOR T;
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 2 => '0') & "01" REPORT "TEST 2 FAILED" SEVERITY NOTE;
		CTRL <= (REG_NUM - 1 DOWNTO 3 => '0') & "000";
		
		-- switch to different register
		SEL <= 1;
		DATA_IN <= (BIT_LENGTH - 1 DOWNTO 2 => '0') & "00";
		WAIT FOR T;
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 0 =>'0') REPORT "TEST 3 FAILED" SEVERITY NOTE;
		
		-- test different register
		DATA_IN <= (BIT_LENGTH - 1 DOWNTO 2 => '0') & "10";
		WAIT FOR T;
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 0 =>'0') REPORT "TEST 4 FAILED" SEVERITY NOTE;
		
		-- try new register with control bit
		CTRL <= (REG_NUM - 1 DOWNTO 3 => '0') & "010";
		WAIT FOR T;
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 2 =>'0') & "10" REPORT "TEST 6 FAILED" SEVERITY NOTE;
		WAIT FOR T;
		
		-- switch back to orginal register (should be instant)
		SEL <= 0;
		WAIT FOR 1 ps; 
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 2 =>'0') & "01" REPORT "TEST 7 FAILED" SEVERITY NOTE;
		WAIT FOR T/2;
		
		-- switch to another set register
		SEL <= 2;
		WAIT FOR 1 ps; 
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 2 =>'0') & "01" REPORT "TEST 8 FAILED" SEVERITY NOTE;
		WAIT FOR T/2;
		
		-- test for changing signal mid way through
		WAIT FOR T/2;
		DATA_IN <= (BIT_LENGTH - 1 DOWNTO 2 => '0') & "11";
		ASSERT DATA_OUT = (BIT_LENGTH - 1 DOWNTO 2 => '0') & "01" REPORT "TEST 9 FAILED" SEVERITY NOTE;
		WAIT FOR 5*T/2;
		
		stop;
		finish;
	END PROCESS;

END register_block_tb_rtl;