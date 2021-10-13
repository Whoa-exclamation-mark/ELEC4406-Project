LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY processor_manual IS
	PORT (	
				KEY		:	IN STD_LOGIC_VECTOR(1 DOWNTO 0);
				SW			:	IN STD_LOGIC_VECTOR(9 DOWNTO 0);
				LEDR		:	OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
				HEX0		:  OUT STD_LOGIC_VECTOR( 6 DOWNTO 0)
		);
END processor_manual;

ARCHITECTURE processor_manual_rtl OF processor_manual IS

	COMPONENT processor
		GENERIC(	
				BIT_LENGTH	: 	INTEGER;
				REG_NUM		:	INTEGER
		);
		PORT(	
				CLK							:	IN STD_LOGIC;
				RUN							:	IN STD_LOGIC;
				RESETN						:	IN STD_LOGIC;
				DONE							: 	OUT STD_LOGIC;
				DIN							:	IN STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0);
				DATA_OUT						: 	OUT STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0);
				STATE_VAL					:  OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)
				
		);
	END COMPONENT;
	
	COMPONENT seven_segment_decoder 
		PORT (SW				: in std_logic_vector (3 downto 0);
				HEX			: out std_logic_vector (6 downto 0));
	END COMPONENT;
	
	SIGNAL STATE_SIG : STD_LOGIC_VECTOR( 3 DOWNTO 0);
	
BEGIN

	processor_comp: processor
		GENERIC MAP
			(
				BIT_LENGTH 	=> 9,
				REG_NUM 		=> 8
			)
		PORT MAP
			(
				CLK => KEY(1),
				RUN => SW(9),
				RESETN => NOT KEY(0),
				DONE => LEDR(9),
				DIN => SW(8 DOWNTO 0),
				DATA_OUT => LEDR(8 DOWNTO 0),
				STATE_VAL => STATE_SIG
			);
		
	hex0_disp: seven_segment_decoder
		PORT MAP 
			(
				SW => STATE_SIG,
				HEX => HEX0
			);
	
END processor_manual_rtl;