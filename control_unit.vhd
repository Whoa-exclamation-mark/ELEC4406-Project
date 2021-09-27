

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;

ENTITY control_unit IS
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
END control_unit;


ARCHITECTURE control_unit_rtl OF control_unit IS

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

	TYPE STATE IS (RUN, MV_T1, MVI_T1, ADD_T1, ADD_T2, ADD_T3, SUB_T1, SUB_T2, SUB_T3);
	SIGNAL LS, NS : STATE;
	SIGNAL IR_IN : STD_LOGIC;
	SIGNAL IR_DATA : STD_LOGIC_VECTOR( BIT_LENGTH-1 DOWNTO 0);
BEGIN

	ir_reg: register_parallel
		GENERIC MAP
			(
				BIT_LENGTH => BIT_LENGTH
			)
		PORT MAP
			(
				DATA_IN		=>		DIN,
				CTRL			=>		IR_IN,
				CLK			=> 	CLK,
				DATA_OUT		=>		IR_DATA
			);
		
	clk_proc: 
		PROCESS (CLK, RESETN) BEGIN
			IF (RESETN = '1') THEN
				LS <= RUN;
			ELSIF (CLK'EVENT AND CLK = '1') THEN
				LS <= NS;
			END IF;
		END PROCESS;
	
	comb_proc:
		PROCESS(LS, NS) 
			VARIABLE instruction : STD_LOGIC_VECTOR( 2 DOWNTO 0);
			VARIABLE x : STD_LOGIC_VECTOR(2 DOWNTO 0);
			VARIABLE y : STD_LOGIC_VECTOR(2 DOWNTO 0);
		BEGIN
			G_IN <= '0';
			G_OUT <= '0';
			A_IN <= '0';
			DIN_OUT <= '0';
			ADDSUB <= '0';
			DONE <= '0';
			IR_IN <= '0';
			R_OUT <= 0;
			R_IN <= (OTHERS => '0');
			x := IR_DATA(5 DOWNTO 3);
			y := IR_DATA(8 DOWNTO 6);
			CASE (LS) IS 
				WHEN RUN =>
					IR_IN <= '1';
					instruction := IR_DATA(2 DOWNTO 0);
					IF (RUN_SIG = '1') THEN
						CASE (instruction) IS
							WHEN "000" => --mv
								NS <= MV_T1;
							WHEN "001" => --mvi
								NS <= MVI_T1;
							WHEN "010" => --add
								NS <= ADD_T1;
							WHEN "011" => --mv
								NS <= SUB_T1;
							WHEN OTHERS => --invalid state
								NS <= RUN;
						END CASE;
					ELSE
						NS <= RUN;
					END IF;
				WHEN MV_T1 =>
					R_OUT <= to_integer(unsigned(y))+1;
					R_IN <= (OTHERS => '0');
					FOR I IN 0 TO REG_NUM-1 LOOP
						IF (I = to_integer(unsigned(x))) THEN
							R_IN(I) <= '1';
						ELSE 
							R_IN(I) <= '0';
						END IF;
					END LOOP;
					DONE <= '1';
					NS <= RUN;
				WHEN MVI_T1 =>
					DIN_OUT <= '1';
					FOR I IN 0 TO REG_NUM-1 LOOP
						IF (I = to_integer(unsigned(x))) THEN
							R_IN(I) <= '1';
						ELSE 
							R_IN(I) <= '0';
						END IF;
					END LOOP;
					DONE <= '1';
					NS <= RUN;
				WHEN ADD_T1 =>
					R_OUT <= to_integer(unsigned(x))+1;
					A_IN <= '1';
					NS <= ADD_T2;
				WHEN ADD_T2 =>
					R_OUT <= to_integer(unsigned(y))+1;
					G_IN <= '1';
					NS <= ADD_T3;
				WHEN ADD_T3 =>
					G_OUT <= '1';
					FOR I IN 0 TO REG_NUM-1 LOOP
						IF (I = to_integer(unsigned(x))) THEN
							R_IN(I) <= '1';
						ELSE 
							R_IN(I) <= '0';
						END IF;
					END LOOP;
					DONE <= '1';
					NS <= RUN;
				WHEN SUB_T1 =>
					R_OUT <= to_integer(unsigned(x))+1;
					A_IN <= '1';
					NS <= SUB_T2;
				WHEN SUB_T2 =>
					R_OUT <= to_integer(unsigned(y))+1;
					G_IN <= '1';
					ADDSUB <= '1';
					NS <= SUB_T3;
				WHEN SUB_T3 =>
					G_OUT <= '1';
					FOR I IN 0 TO REG_NUM-1 LOOP
						IF (I = to_integer(unsigned(x))) THEN
							R_IN(I) <= '1';
						ELSE 
							R_IN(I) <= '0';
						END IF;
					END LOOP;
					DONE <= '1';
					NS <= RUN;
				WHEN OTHERS =>
					NS <= RUN;
			END CASE;
		END PROCESS;
END control_unit_rtl;