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
		RUN_SIG <= '1';
		
		-- Test MV
		DIN <= "011001000";
		WAIT FOR 2*T;
		DIN <= "001010000";
		WAIT FOR 2*T;
		
		-- Test MVI
		DIN <= "000000001";
		WAIT FOR 2*T;
		-- See if invalid y effects results
		DIN <= "011010001";
		WAIT FOR 2*T;
		
		-- Test ADD
		DIN <= "011001010";
		WAIT FOR 4*T;
		DIN <= "011010010";
		WAIT FOR 4*T;
		
		-- Test SUB
		DIN <= "011001011";
		WAIT FOR 4*T;
		DIN <= "011000011";
		WAIT FOR 4*T;
		
		stop;
		finish;
	END PROCESS;

END control_unit_tb_rtl;