LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

USE STD.env.stop;
USE STD.env.finish;

ENTITY control_unit_tb IS
	GENERIC(	
		BIT_LENGTH	: 	INTEGER := 9;
		REG_NUM		:	INTEGER := 8
	);
END control_unit_tb;

ARCHITECTURE control_unit_tb_rtl OF control_unit_tb IS

	
	COMPONENT control_unit IS
		GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9;
				REG_NUM		:	INTEGER := 8
		);
		PORT(		
				G_IN,G_OUT,A_IN,DIN_OUT	:	OUT STD_LOGIC;
				R_IN							: 	OUT STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0);
				R_OUT							:	OUT INTEGER;
				ADDSUB						:	OUT STD_LOGIC;	
				CLK							:	IN STD_LOGIC;
				RUN_SIG						:	IN STD_LOGIC;
				RESETN						:	IN STD_LOGIC;
				DONE							: 	OUT STD_LOGIC;
				DIN							:	IN STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0)
		);
	END COMPONENT;
	
	SIGNAL G_IN			:	STD_LOGIC := '0';
	SIGNAL G_OUT		:	STD_LOGIC := '0';
	SIGNAL A_IN			:	STD_LOGIC := '0';
	SIGNAL DIN_OUT		:	STD_LOGIC := '0';
	SIGNAL R_IN			: 	STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL R_OUT		:	INTEGER := 0;
	SIGNAL ADDSUB		:	STD_LOGIC := '0';	
	SIGNAL CLK			:	STD_LOGIC := '0';
	SIGNAL RUN_SIG		:	STD_LOGIC := '0';
	SIGNAL RESETN		:	STD_LOGIC := '0';
	SIGNAL DONE			: 	STD_LOGIC := '0';
	SIGNAL DIN			:	STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0) := (OTHERS => '0');
	
	CONSTANT T: TIME := 50 ns;
	
BEGIN

	CLOCK:
		CLK <=  not CLK after T/2;
	
	DUT : control_unit
		GENERIC MAP (	
				BIT_LENGTH	=> 9
		)
		PORT MAP (		
				G_IN			=> G_IN,
				G_OUT			=> G_OUT,
				A_IN			=> A_IN,
				DIN_OUT		=> DIN_OUT,
				R_IN			=> R_IN,
				R_OUT			=> R_OUT,
				ADDSUB		=> ADDSUB,
				CLK			=> CLK,
				RUN_SIG		=> RUN_SIG,
				RESETN		=> RESETN,
				DONE			=> DONE,
				DIN			=> DIN
		);
		
	tb_proc: PROCESS
	BEGIN
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is operating at a blank state" SEVERITY NOTE;
		RUN_SIG <= '1';
		
		-- Test MV
		DIN <= "011001000";
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000010" AND
			R_OUT = 4 AND
			ADDSUB = '0' AND
			DONE = '1'
			REPORT "CU is not performing move correctly" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not resetting" SEVERITY NOTE;
		
		DIN <= "001010000";
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000100" AND
			R_OUT = 2 AND
			ADDSUB = '0' AND
			DONE = '1'
			REPORT "CU is not performing move correctly" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not resetting" SEVERITY NOTE;
		
		-- Test MVI
		DIN <= "000000001";
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '1' AND 
			R_IN = "00000001" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '1'
			REPORT "CU is not performing mvi correctly" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not resetting" SEVERITY NOTE;
		
		-- See if invalid y effects results
		DIN <= "011010001";
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '1' AND 
			R_IN = "00000100" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '1'
			REPORT "CU is not performing mvi correctly" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not resetting" SEVERITY NOTE;
		
		-- Test ADD
		DIN <= "011001010";
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '1' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 2 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not moving into adder REG A" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '1' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 4 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not moving into adder REG G" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '1' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000010" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '1'
			REPORT "CU is not moving result of adder into register" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not resetting" SEVERITY NOTE;
		
			
		DIN <= "011010010";
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '1' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 3 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not moving into adder REG A" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '1' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 4 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not moving into adder REG G" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '1' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000100" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '1'
			REPORT "CU is not moving result of adder into register" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not resetting" SEVERITY NOTE;
		
		-- Test SUB
		DIN <= "011001011";
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '1' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 2 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not moving into sub REG A" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '1' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 4 AND
			ADDSUB = '1' AND
			DONE = '0'
			REPORT "CU is not moving into sub REG G" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '1' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000010" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '1'
			REPORT "CU is not moving result of adder into register" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not resetting" SEVERITY NOTE;
		
		DIN <= "011000011";
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '1' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 1 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not moving into sub REG A" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '1' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 4 AND
			ADDSUB = '1' AND
			DONE = '0'
			REPORT "CU is not moving into sub REG G" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '1' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000001" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '1'
			REPORT "CU is not moving result of adder into register" SEVERITY NOTE;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000000" AND
			R_OUT = 0 AND
			ADDSUB = '0' AND
			DONE = '0'
			REPORT "CU is not resetting" SEVERITY NOTE;
		
		DIN <= "011001000";
		WAIT FOR T/2;
		RESETN <= '1';
		WAIT FOR T/4;
		RESETN <= '0';
		WAIT FOR T/4;
		WAIT FOR T;
		ASSERT 
			G_IN = '0' AND
			G_OUT = '0' AND
			A_IN = '0' AND
			DIN_OUT = '0' AND 
			R_IN = "00000010" AND
			R_OUT = 4 AND
			ADDSUB = '0' AND
			DONE = '1'
			REPORT "Reset not performed" SEVERITY NOTE;
		
		stop;
		finish;
	END PROCESS;

END control_unit_tb_rtl;