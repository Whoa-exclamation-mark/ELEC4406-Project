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
		R_OUT							:	OUT NATURAL RANGE 0 to REG_NUM  := 1;
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
	
	TYPE STATE IS (T0, T1, T2, T3);
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
		PROCESS (CLK, RESETN) 
		BEGIN
			IF (RESETN = '1') THEN
				LS <= T0;
			-- TODO check if this is okay
			ELSIF (CLK'EVENT AND CLK = '1' AND RUN_SIG = '1') THEN
				LS <= NS;
			END IF;
		END PROCESS;
	
	comb_proc:
		PROCESS(LS, NS) 
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
			CASE (LS) IS 
				WHEN T0 =>
					IR_IN <= '1';
					NS <= T1;
				WHEN T1 =>
					CASE (IR_DATA(2 DOWNTO 0)) IS
						WHEN "000" => --mv
							R_OUT <= to_integer(unsigned(IR_DATA(8 DOWNTO 6)))+1;
							FOR I IN 0 TO REG_NUM-1 LOOP
								IF (I = to_integer(unsigned(IR_DATA(5 DOWNTO 3)))) THEN
									R_IN(I) <= '1';
								ELSE 
									R_IN(I) <= '0';
								END IF;
							END LOOP;
							DONE <= '1';
							NS <= T0;
						WHEN "001" => --mvi
							DIN_OUT <= '1';
							FOR I IN 0 TO REG_NUM-1 LOOP
								IF (I = to_integer(unsigned(IR_DATA(5 DOWNTO 3)))) THEN
									R_IN(I) <= '1';
								ELSE 
									R_IN(I) <= '0';
								END IF;
							END LOOP;
							DONE <= '1';
							NS <= T0;
						WHEN "010" => --add
							R_OUT <= to_integer(unsigned(IR_DATA(5 DOWNTO 3)))+1;
							A_IN <= '1';
							NS <= T2;
						WHEN "011" => --mv
							R_OUT <= to_integer(unsigned(IR_DATA(5 DOWNTO 3)))+1;
							A_IN <= '1';
							NS <= T2;
						WHEN OTHERS => --invalid state
							DONE <= '1';
							NS <= T0;
					END CASE;
				WHEN T2 =>
					CASE (IR_DATA(2 DOWNTO 0)) IS
						WHEN "010" =>
							R_OUT <= to_integer(unsigned(IR_DATA(8 DOWNTO 6)))+1;
							G_IN <= '1';
							NS <= T3;
						WHEN "011" =>
							R_OUT <= to_integer(unsigned(IR_DATA(8 DOWNTO 6)))+1;
							G_IN <= '1';
							ADDSUB <= '1';
							NS <= T3;
						WHEN OTHERS =>
							DONE <= '1';
							NS <= T0;
					END CASE;
				WHEN T3 =>
					IF (IR_DATA(2 DOWNTO 0) = "010" OR IR_DATA(2 DOWNTO 0) = "011") THEN
						G_OUT <= '1';
						FOR I IN 0 TO REG_NUM-1 LOOP
							IF (I = to_integer(unsigned(IR_DATA(5 DOWNTO 3)))) THEN
								R_IN(I) <= '1';
							ELSE 
								R_IN(I) <= '0';
							END IF;
						END LOOP;
						DONE <= '1';
						NS <= T0;
					ELSE 
						DONE <= '1';
						NS <= T0;
					END IF;
				WHEN OTHERS =>
					NS <= T0;
			END CASE;
		END PROCESS;
		
END control_unit_rtl;