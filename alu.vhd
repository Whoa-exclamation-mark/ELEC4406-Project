
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY alu IS 
	GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9;
				REG_NUM		:	INTEGER := 8
		);
	PORT(		
				DIN							:	IN STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
				G_IN,G_OUT,A_IN,DIN_OUT	:	IN STD_LOGIC;
				R_IN							: 	IN STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0);
				R_OUT							:	IN NATURAL RANGE 0 to REG_NUM := 1;
				ADDSUB						:	IN STD_LOGIC;	
				CLK							:	IN STD_LOGIC;
				DATA_OUT						:	OUT STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0)
		);
END alu;

ARCHITECTURE alu_rlt OF alu IS
	
	COMPONENT register_block
		GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9;
				REG_NUM		:	INTEGER := 8
		);
		PORT(		
				DATA_IN		:	IN STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0);
				CTRL			: 	IN STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0);
				CLK			:	IN STD_LOGIC;
				SEL			:	IN NATURAL RANGE 0 to REG_NUM-1;
				DATA_OUT		:	OUT STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0)
		);
	END COMPONENT;
	
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
	
	SIGNAL DATA_BUS : STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL REG_OUT : STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ADDSUB_OUT : STD_LOGIC_VECTOR( BIT_LENGTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL R_OUT_SIG : NATURAL RANGE 0 to REG_NUM-1 := 0;
	
BEGIN
		
		R_OUT_SIG <= R_OUT-1 WHEN R_OUT > 0 AND R_OUT < REG_NUM ELSE 0;
		
		register_block_comp: register_block
			GENERIC MAP
				(
					BIT_LENGTH 	=> BIT_LENGTH,
					REG_NUM 		=> REG_NUM
				)
			PORT MAP
				(
					DATA_IN 		=> DATA_BUS,
					CTRL 			=> R_IN,
					CLK 			=> CLK,
					-- Minus one to start at index of 0 (0 in the ALU means no control)
					SEL 			=> R_OUT_SIG,
					DATA_OUT		=> REG_OUT
				);
		
		addsub_block_comp: addsub_block
			GENERIC MAP
				(
					BIT_LENGTH 	=> BIT_LENGTH
				)
			PORT MAP
				(
					DATA_IN	 	=> DATA_BUS,
					A_IN			=> A_IN,
					G_IN			=> G_IN,
					CLK			=> CLK,
					SEL			=> ADDSUB,
					DATA_OUT		=> ADDSUB_OUT
				);
				
		mux_proc:
			PROCESS (G_OUT,DIN_OUT,R_OUT, DIN, ADDSUB_OUT, REG_OUT) BEGIN
				IF (DIN_OUT = '1') THEN
					DATA_BUS <= DIN;
				ELSIF (G_OUT = '1') THEN 
					DATA_BUS <= ADDSUB_OUT;
				ELSIF (R_OUT >= 1) THEN
					DATA_BUS <= REG_OUT;
				ELSE
					-- Illegal state 
					DATA_BUS <= (OTHERS => '0');
				END IF;
			END PROCESS;
		
		DATA_OUT <= DATA_BUS;
		
END alu_rlt;