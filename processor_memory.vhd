LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY processor_memory IS
	PORT (	
		KEY		:	IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		SW			:	IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		LEDR		:	OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END processor_memory;

ARCHITECTURE processor_memory_rtl OF processor_memory IS

	COMPONENT processor
		GENERIC(	
			BIT_LENGTH	: 	INTEGER;
			REG_NUM		:	INTEGER
		);
		PORT(	
			CLK			:	IN STD_LOGIC;
			RUN			:	IN STD_LOGIC;
			RESETN		:	IN STD_LOGIC;
			DONE			: 	OUT STD_LOGIC;
			DIN			:	IN STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0);
			DATA_OUT		: 	OUT STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0)
		);
	END COMPONENT;
	
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
	
	SIGNAL DIN : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL KEY_NOT : STD_LOGIC_VECTOR(1 DOWNTO 0);
	
BEGIN
	
	KEY_NOT <= NOT(KEY);
	
	processor_comp: processor
		GENERIC MAP
				(
					BIT_LENGTH 	=> 9,
					REG_NUM 		=> 8
				)
		PORT MAP(
				CLK => KEY_NOT(1),
				RUN => SW(9),
				RESETN => SW(0),
				DONE => LEDR(9),
				DIN => DIN,
				DATA_OUT => LEDR(8 DOWNTO 0)
		);
		
	memory_comp: memory_block
		GENERIC MAP
				(
					ADDR_SPACE 	=> 5,
					BIT_LENGTH 	=> 9
				)
		PORT MAP(
				DATA_OUT => DIN,
				CLK => KEY_NOT(0), 
				RST => SW(0)
		);
	
END processor_memory_rtl;