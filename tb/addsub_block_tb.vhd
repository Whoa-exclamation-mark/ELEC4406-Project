LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

USE STD.env.stop;
USE STD.env.finish;

ENTITY addsub_block_tb IS
	GENERIC(	
		BIT_LENGTH	: 	INTEGER := 9
	);
END addsub_block_tb;

ARCHITECTURE addsub_block_tb_rtl OF addsub_block_tb IS

	COMPONENT addsub_block 
		GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9
		);
		PORT(
				DATA_IN					:	IN STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
				A_IN,G_IN				:	IN STD_LOGIC;
				CLK						:	IN STD_LOGIC;
				SEL						:	IN STD_LOGIC;		
				DATA_OUT					:	OUT STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0)
		);
	END COMPONENT;
	
	SIGNAL DATA_IN, DATA_OUT : STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL A_IN, G_IN, CLK, SEL : STD_LOGIC := '0';
	
	CONSTANT T: TIME := 50 ns;
	
BEGIN

	CLOCK:
		CLK <=  not CLK after T/2;
	
	DUT: addsub_block 
		GENERIC MAP
			(
				BIT_LENGTH 	=> BIT_LENGTH
			)
		PORT MAP
			(
				DATA_IN 		=> DATA_IN,
				A_IN			=> A_IN,
				G_IN			=> G_IN,
				CLK			=> CLK,
				SEL			=> SEL,
				DATA_OUT		=> DATA_OUT
			);
	
	tb_proc: PROCESS 
	BEGIN
		WAIT FOR T;
		
		DATA_IN <= (BIT_LENGTH-1 DOWNTO 3 => '0') & "001";
		A_IN <= '1';
		
		WAIT FOR T;
		
		A_IN <= '0';
		DATA_IN <= (BIT_LENGTH-1 DOWNTO 3 => '0') & "010";
		G_IN <= '1';		
		
		WAIT FOR T;
		G_IN <= '0';
		
		ASSERT DATA_OUT = (BIT_LENGTH-1 DOWNTO 3 => '0') & "011" REPORT "TEST 1 FAILED" SEVERITY NOTE;
		
		WAIT FOR T;
		
		DATA_IN <= (BIT_LENGTH-1 DOWNTO 3 => '0') & "011";
		A_IN <= '1';
		
		WAIT FOR T;
		
		A_IN <= '0';
		DATA_IN <= (BIT_LENGTH-1 DOWNTO 3 => '0') & "001";
		SEL <= '1';
		G_IN <= '1';		
		
		WAIT FOR T;
		G_IN <= '0';
		
		ASSERT DATA_OUT = (BIT_LENGTH-1 DOWNTO 3 => '0') & "010" REPORT "TEST 1 FAILED" SEVERITY NOTE;
		
		stop;
		finish;
	END PROCESS;
	
END addsub_block_tb_rtl;