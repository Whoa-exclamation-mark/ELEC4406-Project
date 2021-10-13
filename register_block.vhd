-- TODO: talk to Farid about Int
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY register_block IS
	GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9;
				REG_NUM		:	INTEGER := 8
		);
	PORT(		
				DATA_IN		:	IN STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
				CTRL			: 	IN STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0);
				CLK			:	IN STD_LOGIC;
				SEL			:	IN NATURAL RANGE 0 to REG_NUM-1 := 0;
				--SEL			:	IN STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0); 
				DATA_OUT		:	OUT STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0)
		);
END register_block;

ARCHITECTURE register_block_rtl OF register_block IS
	
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
	
	-- TODO: Think about a better way of doing this...
	TYPE Q_OUT IS ARRAY (0 to REG_NUM-1) of std_logic_vector(BIT_LENGTH-1 DOWNTO 0);
	SIGNAL DATA_OUT_INT : Q_OUT;
	SIGNAL SEL_INT : NATURAL RANGE 0 to REG_NUM-1 := 0;
	
BEGIN
	
	GEN_REG:
		FOR I IN 0 TO REG_NUM-1 GENERATE

		BEGIN
			register_parallel_comp:
				register_parallel 
				GENERIC MAP
					(
						BIT_LENGTH => BIT_LENGTH
					)
				PORT MAP
					(
						DATA_IN		=>	DATA_IN,
						CTRL			=>	CTRL(I),
						CLK			=> CLK,
						DATA_OUT		=>	DATA_OUT_INT(I)(BIT_LENGTH-1 DOWNTO 0)
					);
		END GENERATE 
	GEN_REG;
	
	DATA_OUT <= DATA_OUT_INT(SEL)(BIT_LENGTH-1 DOWNTO 0);
	
	
	--MUX:
	--	PROCESS (SEL) 
	--		VARIABLE CURR_SEL : STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0) := (OTHERS => '0');
	--	BEGIN
	--		FOR I IN 0 TO REG_NUM-1 LOOP
	--			CURR_SEL := (OTHERS => '0');
	--			CURR_SEL(I) := '1';
	--			IF (CURR_SEL = SEL) THEN
	--				DATA_OUT <= DATA_OUT_INT((I+1) * BIT_LENGTH - 1 DOWNTO I * BIT_LENGTH);
	--			END IF;
	--		END LOOP;
	--	END PROCESS;
	
END register_block_rtl;