LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


ENTITY memory_block IS
	GENERIC (
		ADDR_SPACE	: 	INTEGER := 5;
		BIT_LENGTH	:	INTEGER := 9
	);
	PORT (
		DATA_OUT		:	OUT STD_LOGIC_VECTOR(BIT_LENGTH-1 DOWNTO 0);
		CLK,RST		:	IN STD_LOGIC
	);
END memory_block;

ARCHITECTURE memory_block_rtl OF memory_block IS
	
	COMPONENT rom
		GENERIC (
			ADDR_SPACE	: 	INTEGER := 5;
			BIT_LENGTH	:	INTEGER := 9
		);
		PORT
		(
			address	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			q			: OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT counter IS
		GENERIC (
			ADDR_SPACE	: 	INTEGER := 5
		);
		PORT (
			ADDR			:	OUT STD_LOGIC_VECTOR(ADDR_SPACE-1 DOWNTO 0);
			CLK,RST		:	IN STD_LOGIC
		);
	END COMPONENT;

	SIGNAL address : STD_LOGIC_VECTOR(ADDR_SPACE-1 DOWNTO 0);
	
BEGIN

	memory_comp: rom
		GENERIC MAP(
			ADDR_SPACE 	=> ADDR_SPACE,
			BIT_LENGTH 	=> BIT_LENGTH
		)
		PORT MAP(
			address => address,
			q => DATA_OUT,
			clock => CLK
		);
	
	counter_comp: counter
		GENERIC MAP(
			ADDR_SPACE 	=> ADDR_SPACE
		)
		PORT MAP(
			ADDR => address,
			CLK => CLK,
			RST => RST
		);

END memory_block_rtl;