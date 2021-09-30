LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;

-- todo: make generic from BIT_LENGTH

ENTITY memory IS
	GENERIC (
				ADDR_SPACE	: 	INTEGER := 5;
				BIT_LENGTH	:	INTEGER := 9
			);
	PORT (
				ADDR			: 	IN STD_LOGIC_VECTOR(ADDR_SPACE-1 DOWNTO 0);
				DATA_OUT		:	OUT STD_LOGIC_VECTOR(BIT_LENGTH-1 DOWNTO 0);
				CLK			:	IN STD_LOGIC
			);
END memory;

ARCHITECTURE memory_rtl OF memory IS
	
	TYPE rom IS ARRAY (0 to (ADDR_SPACE**2)-1) of std_logic_vector(0 TO BIT_LENGTH-1);
	
	-- 000 mv (in one, wait one)
	-- 001 mvi (in two, wait one)
	-- 010 add (in one, wait three)
	-- 011 sub (in one, wait three)
	
	CONSTANT mem: rom :=
		(
		-- "IIIXXXYYY"
		--	"YYYXXXIII"
			"000000001",
			"000000011",
			"000001001",
			"000000001",
			"001000011",
			"001000010",
			"001000011",
			OTHERS => "000000000"
		);

BEGIN

	clk_proc: PROCESS(CLK)
	BEGIN
		IF (CLK'EVENT AND CLK = '1') THEN
			DATA_OUT <= mem(conv_integer(unsigned(ADDR)));
		END IF;
	END PROCESS;
	
END memory_rtl;