LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY rom IS
	GENERIC (
		ADDR_SPACE	: 	INTEGER := 5;
		BIT_LENGTH	:	INTEGER := 9
	);
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (ADDR_SPACE-1 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (BIT_LENGTH-1 DOWNTO 0)
	);
END rom;


ARCHITECTURE SYN OF rom IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (BIT_LENGTH-1 DOWNTO 0);

BEGIN

	q    <= sub_wire0(BIT_LENGTH-1 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "memory_data.mif",
		intended_device_family => "MAX 10",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 2**ADDR_SPACE,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		ram_block_type => "M9K",
		widthad_a => ADDR_SPACE,
		width_a => BIT_LENGTH,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => address,
		clock0 => clock,
		q_a => sub_wire0
	);
	
END SYN;