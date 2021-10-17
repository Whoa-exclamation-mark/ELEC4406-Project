
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
-- TODO check if we can use this library
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY addsub IS 
	GENERIC(	
		BIT_LENGTH	: 	INTEGER := 9
	);
	PORT(		
		A,B			:	IN STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
		SEL			:	IN STD_LOGIC;
		DATA_OUT		:	OUT STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0)
	);
END addsub;

ARCHITECTURE addsub_con OF addsub IS

BEGIN
	
	WITH SEL SELECT DATA_OUT <=
		A + B WHEN '0',
		A - B WHEN '1',
		A + B WHEN OTHERS;
	
END addsub_con;