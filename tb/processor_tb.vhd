LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

USE STD.env.stop;
USE STD.env.finish;

ENTITY processor_tb IS
	GENERIC (
		BIT_LENGTH	: 	INTEGER := 9;
		REG_NUM		:	INTEGER := 8
	);
END processor_tb;

ARCHITECTURE processor_tb_rtl OF processor_tb IS

	COMPONENT processor IS
		GENERIC (	
			BIT_LENGTH	: 	INTEGER := 9;
			REG_NUM		:	INTEGER := 8
		);
		PORT (	
			CLK			:	IN STD_LOGIC;
			RUN			:	IN STD_LOGIC;
			RESETN		:	IN STD_LOGIC;
			DONE			: 	OUT STD_LOGIC;
			DIN			:	IN STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0);
			DATA_OUT		: 	OUT STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL CLK			:	STD_LOGIC := '0';
	SIGNAL RUN			:	STD_LOGIC := '0';
	SIGNAL RESETN		:	STD_LOGIC := '0';
	SIGNAL DONE			: 	STD_LOGIC := '0';
	SIGNAL DIN			:	STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DATA_OUT	: 	STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0) := (OTHERS => '0');
	
	CONSTANT T: TIME := 50 ns;
	
BEGIN

	CLOCK:
		CLK <=  not CLK after T/2;
	
	DUT: processor
		GENERIC MAP (	
				BIT_LENGTH	=> BIT_LENGTH,
				REG_NUM		=> REG_NUM
		)
		PORT MAP (		
				CLK			=> CLK,	
				RUN			=> RUN,	
				RESETN		=> RESETN,
				DONE			=> DONE,		
				DIN			=> DIN,	
				DATA_OUT		=> DATA_OUT
		);
		
	tb_proc: PROCESS
	BEGIN
		RUN <= '1';
		
		-- Test MVI
		DIN <= "000000001";
		WAIT FOR T;
		DIN <= "000100011";
		WAIT FOR T;
		-- See if invalid y effects results
		DIN <= "011010001";
		WAIT FOR T;
		DIN <= "000001001";
		WAIT FOR T;
		
		-- Test MV
		DIN <= "001000000";
		WAIT FOR 2*T;
		DIN <= "100001000";
		WAIT FOR 2*T;
		
		-- Test ADD
		DIN <= "000100010";
		WAIT FOR 4*T;
		DIN <= "100010010";
		WAIT FOR 4*T;
		
		-- Test ADD
		DIN <= "000100011";
		WAIT FOR 4*T;
		DIN <= "100010011";
		WAIT FOR 4*T;
		
		stop;
		finish;
	END PROCESS;

END processor_tb_rtl;