LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

USE STD.env.stop;
USE STD.env.finish;

ENTITY alu_tb IS
	GENERIC(	
		BIT_LENGTH	: 	INTEGER := 9;
		REG_NUM		:	INTEGER := 8
	);
END alu_tb;

ARCHITECTURE alu_tb_rtl OF alu_tb IS

	COMPONENT alu IS 
		GENERIC(	
			BIT_LENGTH	: 	INTEGER := 9;
			REG_NUM		:	INTEGER := 8
		);
		PORT(		
			DIN							:	IN STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
			G_IN,G_OUT,A_IN,DIN_OUT	:	IN STD_LOGIC;
			R_IN							: 	IN STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0);
			R_OUT							:	IN INTEGER;
			ADDSUB						:	IN STD_LOGIC;	
			CLK							:	IN STD_LOGIC;
			DATA_OUT						:	OUT STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0)
		);
	END COMPONENT;
	
	SIGNAL DIN			:	STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL G_IN			:	STD_LOGIC := '0';
	SIGNAL G_OUT		:	STD_LOGIC := '0';
	SIGNAL A_IN			:	STD_LOGIC := '0';
	SIGNAL DIN_OUT		:	STD_LOGIC := '0';
	SIGNAL R_IN			:	STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL R_OUT		:	INTEGER := 0;
	SIGNAL ADDSUB		:	STD_LOGIC := '0';	
	SIGNAL CLK			:	STD_LOGIC := '0';
	SIGNAL DATA_OUT	:	STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0) := (OTHERS => '0');
	
	CONSTANT T: TIME := 50 ns;
	
BEGIN

	CLOCK:
		CLK <=  not CLK after T/2;
	
	DUT: alu
		GENERIC MAP (	
				BIT_LENGTH	=> BIT_LENGTH,
				REG_NUM		=> REG_NUM
		)
		PORT MAP (		
				DIN			=>	DIN,
				G_IN			=>	G_IN,
				G_OUT			=> G_OUT,
				A_IN			=>	A_IN,
				DIN_OUT		=>	DIN_OUT,
				R_IN			=>	R_IN,
				R_OUT			=> R_OUT,
				ADDSUB		=>	ADDSUB,
				CLK			=>	CLK,
				DATA_OUT		=> DATA_OUT
		);
		
	tb_proc: PROCESS
	BEGIN
		WAIT FOR T;
		
		-- Load data into register from DIN
		DIN <= "000000011";
		R_IN <= "00000001";
		DIN_OUT <= '1';
		WAIT FOR T;
		DIN <= "000000000";
		R_IN <= "00000000";
		DIN_OUT <= '0';
		R_OUT <= 1;
		WAIT FOR T;
		ASSERT DATA_OUT = "000000011" REPORT "Moving data from DIN to R0 not working" SEVERITY NOTE;
		
		DIN <= "000000001";
		R_IN <= "00000010";
		DIN_OUT <= '1';
		WAIT FOR T;
		DIN <= "000000000";
		R_IN <= "00000000";
		DIN_OUT <= '0';
		R_OUT <= 2;
		WAIT FOR T;
		ASSERT DATA_OUT = "000000001" REPORT "Moving data from DIN to R1 not working" SEVERITY NOTE;
		
		-- Move data around
		R_OUT <= 2;
		R_IN <= "00000100";
		WAIT FOR T;
		DIN <= "000000000";
		R_IN <= "00000000";
		DIN_OUT <= '0';
		R_OUT <= 3;
		WAIT FOR T;
		ASSERT DATA_OUT = "000000001" REPORT "Moving data from R1 to R2 not working" SEVERITY NOTE;
		
		R_OUT <= 1;
		R_IN <= "00001000";
		WAIT FOR T;
		DIN <= "000000000";
		R_IN <= "00000000";
		DIN_OUT <= '0';
		R_OUT <= 4;
		WAIT FOR T;
		ASSERT DATA_OUT = "000000011" REPORT "Moving data from R0 to R3 not working" SEVERITY NOTE;
		
		R_OUT <= 1;
		A_IN <= '1';
		WAIT FOR T;
		R_OUT <= 2;
		G_IN <= '1';
		ADDSUB <= '1';
		WAIT FOR T;
		R_OUT <= 0;
		G_IN <= '0';
		ADDSUB <= '0';
		G_OUT <= '1';
		WAIT FOR T;
		ASSERT DATA_OUT = "000000010" REPORT "Subtraction not working" SEVERITY NOTE;
		G_OUT <= '0';
		
		R_OUT <= 1;
		A_IN <= '1';
		WAIT FOR T;
		R_OUT <= 2;
		G_IN <= '1';
		WAIT FOR T;
		R_OUT <= 0;
		G_IN <= '0';
		G_OUT <= '1';
		WAIT FOR T;
		ASSERT DATA_OUT = "000000100" REPORT "Addition not working" SEVERITY NOTE;
		G_OUT <= '0';
		
		R_OUT <= 2;
		A_IN <= '1';
		WAIT FOR T;
		R_OUT <= 1;
		G_IN <= '1';
		ADDSUB <= '1';
		WAIT FOR T;
		R_OUT <= 0;
		G_IN <= '0';
		ADDSUB <= '0';
		G_OUT <= '1';
		WAIT FOR T;
		ASSERT DATA_OUT = "111111110" REPORT "Subtraction not working with roll over" SEVERITY NOTE;
		
		A_IN <= '1';
		WAIT FOR T;
		G_OUT <= '0';
		DIN_OUT <= '1';
		DIN <= "000000010";
		G_IN <= '1';
		ADDSUB <= '1';
		WAIT FOR T;
		R_OUT <= 0;
		G_IN <= '0';
		DIN_OUT <= '0';
		ADDSUB <= '0';
		G_OUT <= '1';
		WAIT FOR T;
		ASSERT DATA_OUT = "111111100" REPORT "Subtraction not working with roll over" SEVERITY NOTE;
		
		
		stop;
		finish;
	END PROCESS;

END alu_tb_rtl;