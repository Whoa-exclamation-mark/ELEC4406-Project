
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY processor IS
	GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9;
				REG_NUM		:	INTEGER := 8
		);
	PORT(	
				CLK							:	IN STD_LOGIC;
				RUN							:	IN STD_LOGIC;
				RESETN						:	IN STD_LOGIC;
				DONE							: 	OUT STD_LOGIC;
				DIN							:	IN STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0);
				DATA_OUT						: 	OUT STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0)
		);
END processor;

ARCHITECTURE processor_rtl OF processor IS
	COMPONENT control_unit
		GENERIC(	
				BIT_LENGTH	: 	INTEGER := 9;
				REG_NUM		:	INTEGER := 8
		);
		PORT(		
				G_IN,G_OUT,A_IN,DIN_OUT	:	OUT STD_LOGIC;
				R_IN							: 	OUT STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0);
				R_OUT							:	OUT INTEGER;
				ADDSUB						:	OUT STD_LOGIC;	
				CLK							:	IN STD_LOGIC;
				RUN_SIG						:	IN STD_LOGIC;
				RESETN						:	IN STD_LOGIC;
				DONE							: 	OUT STD_LOGIC;
				DIN							:	IN STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT alu  
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
	
	SIGNAL G_IN,G_OUT,A_IN,DIN_OUT,ADDSUB : STD_LOGIC;
	SIGNAL R_OUT : INTEGER;
	SIGNAL R_IN : STD_LOGIC_VECTOR( REG_NUM - 1 DOWNTO 0);
BEGIN
	
	control_unit_comp: control_unit
		GENERIC MAP
				(
					BIT_LENGTH 	=> BIT_LENGTH,
					REG_NUM 		=> REG_NUM
				)
		PORT MAP(		
				G_IN			=> G_IN,
				G_OUT			=> G_OUT,
				A_IN			=> A_IN,
				DIN_OUT		=> DIN_OUT,
				R_IN			=> R_IN,
				R_OUT			=> R_OUT,
				ADDSUB		=> ADDSUB,
				CLK			=> CLK,
				RUN_SIG		=> RUN,
				RESETN		=> RESETN,
				DONE			=> DONE,
				DIN			=> DIN
		);
		
	alu_comp: alu
		GENERIC MAP
				(
					BIT_LENGTH 	=> BIT_LENGTH,
					REG_NUM 		=> REG_NUM
				)
		PORT MAP(		
				DIN			=> DIN,
				G_IN			=> G_IN,
				G_OUT			=> G_OUT,
				A_IN			=> A_IN,
				DIN_OUT		=> DIN_OUT,
				R_IN			=> R_IN,
				R_OUT			=> R_OUT,
				ADDSUB		=> ADDSUB,
				CLK			=> CLK,
				DATA_OUT		=> DATA_OUT
		);

END processor_rtl;