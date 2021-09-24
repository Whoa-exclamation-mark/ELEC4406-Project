
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY addsub_block IS 
	GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9
		);
	PORT(		
				DATA_IN_1,DATA_IN_2	:	IN STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
				A_IN,G_IN				:	IN STD_LOGIC;
				CLK						:	IN STD_LOGIC;
				SEL						:	IN STD_LOGIC;		
				DATA_OUT					:	OUT STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0)
		);
END addsub_block;

ARCHITECTURE addsub_block_rlt OF addsub_block IS

	COMPONENT addsub
		GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9
		);
		PORT(		
				A,B			:	IN STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
				SEL			:	IN STD_LOGIC;
				DATA_OUT		:	OUT STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT register_parallel 
		GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9
		);
		PORT(		
				DATA_IN		:	IN STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
				CTRL			: 	IN STD_LOGIC;
				CLK			:	IN STD_LOGIC;
				DATA_OUT		:	OUT STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0)
		);
	END COMPONENT;
	
	SIGNAL A : STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
	SIGNAL G : STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
	
BEGIN

	A_reg: register_parallel
		GENERIC MAP
			(
				BIT_LENGTH => BIT_LENGTH
			)
		PORT MAP
			(
				DATA_IN		=>		DATA_IN_1,
				CTRL			=>		A_IN,
				CLK			=> 	CLK,
				DATA_OUT		=>		A
			);
		
	AddSub_Comp: addsub
		GENERIC MAP
			(
				BIT_LENGTH => BIT_LENGTH
			)
		PORT MAP
			(
				A => A,
				B => DATA_IN_2,
				SEL => SEL,
				DATA_OUT => G
			);
	
	G_reg: register_parallel
		GENERIC MAP
			(
				BIT_LENGTH => BIT_LENGTH
			)
		PORT MAP
			(
				DATA_IN		=>		G,
				CTRL			=>		G_IN,
				CLK			=> 	CLK,
				DATA_OUT		=>		DATA_OUT
			);
						
END addsub_block_rlt;