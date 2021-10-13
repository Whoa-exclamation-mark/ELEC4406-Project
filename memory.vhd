-- Quartus Prime VHDL Template
-- Single-Port ROM

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;

entity memory is

	generic 
	(
		ADDR_WIDTH : INTEGER := 5;
		BIT_LENGTH : INTEGER := 9
	);

	port 
	(
		clk	: in std_logic;
		addr	: in STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
		q		: out std_logic_vector(BIT_LENGTH-1 DOWNTO 0)
	);

end entity;

architecture memory_rtl of memory is

	-- Build a 2-D array type for the ROM
	subtype word_t is std_logic_vector((BIT_LENGTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;	 

	-- Declare the ROM signal and specify a default value.	Quartus Prime
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal rom : memory_t;
	attribute ram_init_file : string;
	attribute ram_init_file of rom:
	signal is "memory_data.mif";

begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		q <= rom(conv_integer(unsigned(addr)));
	end if;
	end process;

end memory_rtl;