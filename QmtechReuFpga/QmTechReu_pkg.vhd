
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

package QmTechReu_pkg is

	-- Type Declaration (optional)

	-- Subtype Declaration (optional)

	-- Constant Declaration (optional)

	-- Signal Declaration (optional)

	-- Component Declaration (optional)

	
constant DATA_TO_C64					: std_logic := '1';
constant DATA_FROM_C64				: std_logic := '0';
constant DATA_ENA						: std_logic := '0';
constant DATA_DIS						: std_logic := '1';

constant ADRS_TO_C64					: std_logic := '1';
constant ADRS_FROM_C64				: std_logic := '0';
constant ADRS_ENA						: std_logic := '0';
constant ADRS_DIS						: std_logic := '1';

constant ASSERT_WENA					: std_logic := '0';
constant ASSERT_DMA					: std_logic := '0';
constant ASSERT_WRGATE				: std_logic := '0';

constant ASSERT_NMI					: std_logic := '0';
constant ASSERT_INTR					: std_logic := '0';
constant ASSERT_GAME					: std_logic := '0';
constant ASSERT_XROM					: std_logic := '0';



-- signals that drive the C64 bus
type t_c64BusDrive is
record
-- outputs
	nmi_n			: std_logic;
	game_n		: std_logic;
	irq_n			: std_logic;
	exrom_n		: std_logic;
	dma_n			: std_logic;
	
	nwr1			: std_logic;
	rnw_drv		: std_logic;
	adr_dir		: std_logic;
	adr_oen		: std_logic;
	dat_dir		: std_logic;
	dat_oen		: std_logic;
	
-- inouts
	adr			: std_logic_vector(15 downto 0);
	dat			: std_logic_vector( 7 downto 0);
	
end record;

-- signals driven by the C64 bus
type t_c64BusInputs is
record
	rst_n			: std_logic;
	romh_n		: std_logic;
	phi2			: std_logic;
	rnw			: std_logic;
	dotClk		: std_logic;
	io1_n			: std_logic;
	io2_n			: std_logic;
	roml_n		: std_logic;
	ba				: std_logic;
	
	adrIn			: std_logic_vector(15 downto 0);
	datIn			: std_logic_vector( 7 downto 0);
end record;

-- set up the default values for the C64 bus driven
--		signals
constant C64DRV_DEFAULT	: t_c64BusDrive := (
	not ASSERT_NMI, 			-- nmi_n
	not ASSERT_GAME,			-- game_n
	not ASSERT_INTR, 			-- irq_n
	not ASSERT_XROM,			-- exrom_n
	not ASSERT_DMA,			-- dma_n
	
	not ASSERT_WRGATE,		-- nwr1
	not ASSERT_WENA,			-- rnw_drv
		 ADRS_FROM_C64,		-- adr_dir
		 ADRS_ENA,				-- adr_oen
		 DATA_FROM_C64,		-- dat_dir
		 DATA_ENA,				-- dat_oen
		 "ZZZZZZZZZZZZZZZZ",	-- adr
		 "ZZZZZZZZ"				-- dat
	);
	
	
	
	
-- Used by the module that generates the syncronized phi2 signals	
constant CNT_LATCPUDAT				: std_logic_vector(7 downto 0) := x"14";		-- 20
constant CNT_CTRMAX					: std_logic_vector(7 downto 0) := x"23";		-- 35
constant CNT_WAITVAL					: std_logic_vector(7 downto 0) := x"19";		-- 25

		
------------------------------------------------------------
-- Classic REU registers
--	
constant REU_STAT_REG				: std_logic_vector(7 downto 0)	:= x"00";
constant 	REU_BIT_INTR_PENDING		: integer := 7;
constant 	REU_BIT_EOB					: integer := 6;
constant 	REU_BIT_FAULT				: integer := 5;
constant 	REU_BIT_SIZE				: integer := 4;
constant 	REU_BIT_VER					: integer := 3;

constant REU_CTL_REG			: std_logic_vector(7 downto 0)	:= x"01";
constant		REU_BIT_EXECUTE			: integer := 7;
constant		REU_BIT_RSV6				: integer := 6;
constant		REU_BIT_LOAD				: integer := 5;
constant		REU_BIT_FF00				: integer := 4;
constant		REU_BIT_RSV3				: integer := 3;
constant		REU_BIT_RSV2				: integer := 2;
constant		REU_BIT_XFRTYPE			: integer := 1;
constant 		XFR_C64TORAM				: std_logic_vector(1 downto 0) := "00";
constant 		XFR_RAMTOC64				: std_logic_vector(1 downto 0) := "01";
constant 		XFR_SWAP						: std_logic_vector(1 downto 0) := "10";
constant 		XFR_VFY						: std_logic_vector(1 downto 0) := "11";

constant REU_64ADRL_REG		: std_logic_vector(7 downto 0)	:= x"02";
constant REU_64ADRH_REG		: std_logic_vector(7 downto 0)	:= x"03";
constant REU_XPADRL_REG		: std_logic_vector(7 downto 0)	:= x"04";
constant REU_XPADRM_REG		: std_logic_vector(7 downto 0)	:= x"05";
constant REU_XPADRH_REG		: std_logic_vector(7 downto 0)	:= x"06";
constant REU_XFRL_REG		: std_logic_vector(7 downto 0)	:= x"07";
constant REU_XFRH_REG		: std_logic_vector(7 downto 0)	:= x"08";

constant REU_IMR_REG			: std_logic_vector(7 downto 0)	:= x"09";
constant		REU_BIT_INTRENA_MSK		: integer := 7;
constant		REU_BIT_EOB_MSK			: integer := 6;
constant		REU_BIT_VFY_MSK			: integer := 5;

constant REU_ACR_REG			: std_logic_vector(7 downto 0)	:= x"0A";
constant 	REU_INCR_BOTH				: std_logic_vector(1 downto 0) := "00";
constant 	REU_FIX_XPAN				: std_logic_vector(1 downto 0) := "01";
constant 	REU_FIX_C64					: std_logic_vector(1 downto 0) := "10";
constant 	REU_FIX_BOTH				: std_logic_vector(1 downto 0) := "11";

constant REU_CTL2_REG		: std_logic_vector(7 downto 0)	:= x"1C";
constant REU_64SAL_REG		: std_logic_vector(7 downto 0)	:= x"1D";
constant REU_64SAH_REG		: std_logic_vector(7 downto 0)	:= x"1E";
constant REU_XPSA_REG		: std_logic_vector(7 downto 0)	:= x"1F";

------------------------------------------------------------
-- ROM address registers
--	
constant ROML_BASELOW	: std_logic_vector(7 downto 0)	:= x"20";
constant ROML_BASEHIGH	: std_logic_vector(7 downto 0)	:= x"21";
constant ROMH_BASELOW	: std_logic_vector(7 downto 0)	:= x"22";
constant ROMH_BASEHIGH	: std_logic_vector(7 downto 0)	:= x"23";
constant MEM_BASELOW		: std_logic_vector(7 downto 0)	:= x"24";
constant MEM_BASEHIGH	: std_logic_vector(7 downto 0)	:= x"25";

constant USB_TXD_REG			: std_logic_vector(7 downto 0)	:= x"40";
constant USB_RXD_REG			: std_logic_vector(7 downto 0)	:= x"41";
constant USB_STAT_REG		: std_logic_vector(7 downto 0)	:= x"42";
constant USB_BAUD_REG		: std_logic_vector(7 downto 0)	:= x"43";

constant WIFI_TXD_REG		: std_logic_vector(7 downto 0)	:= x"44";
constant WIFI_RXD_REG		: std_logic_vector(7 downto 0)	:= x"45";
constant WIFI_STAT_REG		: std_logic_vector(7 downto 0)	:= x"46";
constant WIFI_BAUD_REG		: std_logic_vector(7 downto 0)	:= x"47";



constant FPGA_REV_REG		: std_logic_vector(7 downto 0)	:= x"5F";

constant IOP_CTL_REG			: std_logic_vector(7 downto 0)	:= x"40";
constant BIT_SEL_IOPTOIO1		: integer := 0;
constant BIT_SEL_IOPMMEM		: integer := 1;
constant BIT_IOP_RESET			: integer := 7;

constant IOP_MEMBANK_REG	: std_logic_vector(7 downto 0)	:= x"41";


constant I2C_DATA_REG		: std_logic_vector(7 downto 0)	:= x"49";

constant FPGA_CTL4A_REG		: std_logic_vector(7 downto 0)	:= x"4A";
constant FPGA_CTL4B_REG		: std_logic_vector(7 downto 0)	:= x"4B";



--constant PFSM_USEC64			: std_logic := '0';
--constant PFSM_USECOPR		: std_logic := '1';
--
--
--constant PFSM_CMD				: std_logic_vector(7 downto 0) := X"50";
--constant PCMD_RDI2C				: std_logic_vector(7 downto 0) := X"80";
--constant PCMD_RDSDSECTOR		: std_logic_vector(7 downto 0) := X"84";
--constant PCMD_RDFLASH			: std_logic_vector(7 downto 0) := X"86";
--constant PCMD_SDINIT				: std_logic_vector(7 downto 0) := X"87";
--
--constant PCMD_WRI2C				: std_logic_vector(7 downto 0) := X"C0";
--constant PCMD_WRSDSECTOR		: std_logic_vector(7 downto 0) := X"C4";
--constant PCMD_WRFLASH			: std_logic_vector(7 downto 0) := X"C6";
--
--constant PFSM_STATUS			: std_logic_vector(7 downto 0) := X"51";
--constant PCMD_OK					: std_logic_vector(7 downto 0) := X"00";
--constant PCMD_I2CTIMEOUT		: std_logic_vector(7 downto 0) := X"80";
--constant PCMD_I2CFSMERR			: std_logic_vector(7 downto 0) := X"81";
--constant PCMD_BADCOMMAND		: std_logic_vector(7 downto 0) := X"82";
--
--
--
--constant PFSM_BANK			: std_logic_vector(7 downto 0) := X"52";
--constant PFSM_R0				: std_logic_vector(7 downto 0) := X"53";
--constant PFSM_R1				: std_logic_vector(7 downto 0) := X"54";
--constant PFSM_R2				: std_logic_vector(7 downto 0) := X"55";
--constant PFSM_R3				: std_logic_vector(7 downto 0) := X"56";
--constant PFSM_R4				: std_logic_vector(7 downto 0) := X"57";



------------------------------------------------------------
-- GeoRAM control registers
--	
constant GEOR_CTL_REG			: std_logic_vector(7 downto 0)	:= x"FD";
constant		GEOR_ENA					: integer := 0;
constant GEOR_PAGE_REG			: std_logic_vector(7 downto 0)	:= x"FE";
constant GEOR_BLOCK_REG			: std_logic_vector(7 downto 0)	:= x"FF";


constant CMD_FLASH_RD			: std_logic_vector(7 downto 0)	:= x"03";
constant CMD_FLASH_PGM			: std_logic_vector(7 downto 0)	:= x"02";
constant CMD_FLASH_WREN			: std_logic_vector(7 downto 0)	:= x"06";
constant CMD_FLASH_WRDIS		: std_logic_vector(7 downto 0)	:= x"04";
constant CMD_FLASH_ERASEC		: std_logic_vector(7 downto 0)	:= x"20";
constant CMD_FLASH_ERABLK		: std_logic_vector(7 downto 0)	:= x"53";
constant CMD_FLASH_ERACHIP		: std_logic_vector(7 downto 0)	:= x"60";
constant	CMD_FLASH_READSTAT2	: std_logic_vector(7 downto 0)	:= x"07";

	

component sdramSimple4Mx4x2
	port(
	-- Host side
		clk_100m0_i		: in std_logic;				-- Master clock
		reset_i			: in std_logic := '0';		-- Reset, active high
		refresh_i		: in std_logic := '0';		-- Initiate a refresh cycle, active high
		rw_i				: in std_logic := '0';		-- Initiate a read or write operation, active high
		we_i				: in std_logic := '0';		-- Write enable, active low
		addr_i			: in std_logic_vector(23 downto 0) := (others => '0');	-- Address from host to SDRAM
		data_i			: in std_logic_vector(15 downto 0) := (others => '0');	-- Data from host to SDRAM
		ub_i				: in std_logic;				-- Data upper byte enable, active low
		lb_i				: in std_logic;				-- Data lower byte enable, active low
		ready_o			: out std_logic := '0';		-- Set to '1' when the memory is ready
		done_o			: out std_logic := '0';		-- Read, write, or refresh, operation is done
		idle_o			: out std_logic;				-- the SDRAM FSM is idle
		data_o			: out std_logic_vector(15 downto 0);	-- Data from SDRAM to host

	-- SDRAM side
		sdCke_o			: out std_logic;				-- Clock-enable to SDRAM
		sdCe_bo			: out std_logic;				-- Chip-select to SDRAM
		sdRas_bo			: out std_logic;				-- SDRAM row address strobe
		sdCas_bo			: out std_logic;				-- SDRAM column address strobe
		sdWe_bo			: out std_logic;				-- SDRAM write enable
		sdBs_o			: out std_logic_vector(1 downto 0);		-- SDRAM bank address
		sdAddr_o			: out std_logic_vector(12 downto 0);	-- SDRAM row/column address
		sdData_io		: inout std_logic_vector(15 downto 0);	-- Data to/from SDRAM
		sdDqmh_o			: out std_logic;				-- Enable upper-byte of SDRAM databus if true
		sdDqml_o			: out std_logic				-- Enable lower-byte of SDRAM databus if true
     );
end component;


component sdram_simple
	 port(
	-- Host side
		clk_100m0_i		: in std_logic;									-- Master clock
		reset_i			: in std_logic := '0';							 -- Reset, active high
		refresh_i		: in std_logic := '0';							 -- Initiate a refresh cycle, active high
		rw_i				: in std_logic := '0';							 -- Initiate a read or write operation, active high
		we_i				: in std_logic := '0';							 -- Write enable, active low
		addr_i			: in std_logic_vector(23 downto 0) := (others => '0');	-- Address from host to SDRAM
		data_i			: in std_logic_vector(15 downto 0) := (others => '0');	-- Data from host to SDRAM
		ub_i				: in std_logic;									-- Data upper byte enable, active low
		lb_i				: in std_logic;									-- Data lower byte enable, active low
		ready_o			: out std_logic := '0';							-- Set to '1' when the memory is ready
		done_o			: out std_logic := '0';							-- Read, write, or refresh, operation is done
		idle_o			: out std_logic := '0';
		data_o			: out std_logic_vector(15 downto 0);		-- Data from SDRAM to host

	-- SDRAM side
		sdCke_o			: out std_logic;									-- Clock-enable to SDRAM
		sdCe_bo			: out std_logic;									-- Chip-select to SDRAM
		sdRas_bo			: out std_logic;									-- SDRAM row address strobe
		sdCas_bo			: out std_logic;									-- SDRAM column address strobe
		sdWe_bo			: out std_logic;									-- SDRAM write enable
		sdBs_o			: out std_logic_vector(1 downto 0);			-- SDRAM bank address
		sdAddr_o			: out std_logic_vector(12 downto 0);		-- SDRAM row/column address
		sdData_io		: inout std_logic_vector(15 downto 0); 	-- Data to/from SDRAM
		sdDqmh_o			: out std_logic;									-- Enable upper-byte of SDRAM databus if true
		sdDqml_o			: out std_logic									-- Enable lower-byte of SDRAM databus if true
		 );
end component;

component clkPll
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0				: OUT STD_LOGIC ;
		c1				: OUT STD_LOGIC ;
		c2				: OUT STD_LOGIC ;
		c3				: OUT STD_LOGIC ;
		c4				: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
end component;


component timingGen
port (
	rst_n				: in std_logic;
	clk100			: in std_logic;
	dotClk			: in std_logic;
	phi2				: in std_logic;
	
	cpuWr_n			: in std_logic;
	
	phi2Sync			: out std_logic;
	clk16M			: out std_logic;
	dlyCpuWr			: out std_logic;
	dlyCpuRd			: out std_logic;
	phi2PosEdge		: out std_logic;
	phi2NegEdge		: out std_logic;
	
	davPos			: out std_logic;
	davNeg			: out std_logic
);
end component;


component R8800R1 is
port(
	clk100			: in std_logic;								-- system level clock
	rst_n				: in std_logic;
	
-- C64 bus records
--		these records are defined in the QmTechREU_pkg
	c64BusDrv		: out t_c64BusDrive;			-- signals that drive the C64 bus
	c64BusInputs	: in t_c64BusInputs;			-- signals from the C64 bus
	
	
	reuHasBus		: out std_logic;
	reuActive		: out std_logic;
	phiPosEdge		: in std_logic;
	davPos			: in std_logic;
	davNeg			: in std_logic;
	reuRegSpace		: in std_logic;	
	
	syncPhi2			: in std_logic;
	
	debug				: out std_logic_vector(15 downto 0);
	
-- SDRAM signals
	sdramAdr			: out std_logic_vector(24 downto 0);
	sdramDatTo		: out std_logic_vector(15 downto 0);
	sdramRfshCmd	: out std_logic;
	sdramRWCmd		: out std_logic;
	sdramWe_n		: out std_logic;
	
	sdramDatFrom	: in std_logic_vector(15 downto 0);
	sdramOpDone		: in std_logic;
	sdramFsmIdle	: in std_logic
    );
end component;

component sd_controller
port (
	sdCS		: out std_logic;
	sdMOSI	: out std_logic;
	sdMISO	: in std_logic;
	sdSCLK	: out std_logic;
	
	n_reset	: in std_logic;
	n_rd		: in std_logic;
	n_wr		: in std_logic;
	dataIn	: in std_logic_vector(7 downto 0);
	dataOut	: out std_logic_vector(7 downto 0);
	regAddr	: in std_logic_vector(2 downto 0);
	
	sdcWp_i	: in std_logic;
	sdcCD_i	: in std_logic;	
	
	clk		: in std_logic;	-- twice the spi clk;
	driveLED : out std_logic := '1'
);
end component;


component TinySpi
port(
	rst_n				: in std_logic;

	cpuAdr			: in std_logic_vector(1 downto 0);
	cpuWr_n			: in std_logic;
	cpuMosi			: in std_logic_vector(7 downto 0);
	cpuMiso			: out std_logic_vector(7 downto 0);
	cpuCSel			: in std_logic;

	spiMasterClk	: in std_logic;
	
	spiCs_n			: out std_logic;
	spiMosi			: out std_logic;
	spiClk			: out std_logic;
	spiMiso			: in std_logic	
	
    );
end component;

component TinySpiV2
port(
	rst_n				: in std_logic;

	cpuAdr			: in std_logic_vector(1 downto 0);
	cpuWr_n			: in std_logic;
	cpuMosi			: in std_logic_vector(7 downto 0);
	cpuMiso			: out std_logic_vector(7 downto 0);
	cpuCSel			: in std_logic;

	spiMasterClk	: in std_logic;
	
	spiCs_n			: out std_logic_vector(7 downto 0);
	spiMosi			: out std_logic;
	spiClk			: out std_logic;
	spiMiso			: in std_logic;

	statNode			: out std_logic_vector(7 downto 0)	
    ); 
end component;



component i2c_master_v01
   GENERIC( 
      CLK_FREQ : natural := 25000000;
      BAUD     : natural := 100000
   );
   PORT( 
      --INPUTS
      sys_clk		: IN     std_logic;
      sys_rst		: IN     std_logic;
      start			: IN     std_logic;
      stop			: IN     std_logic;
      read_i		: IN     std_logic;
      write_i		: IN     std_logic;
      send_ack		: IN     std_logic;
      mstr_din		: IN     std_logic_vector (7 DOWNTO 0);
		
      --OUTPUTS
      sda			: INOUT  std_logic;
      scl			: INOUT  std_logic;
      free			: OUT    std_logic;
      rec_ack		: OUT    std_logic;
      ready			: OUT    std_logic;
		
		busyPulse	: out		std_logic;
		
      core_state	: OUT    std_logic_vector (5 DOWNTO 0);  --for debug purpose
      mstr_dout	: OUT    std_logic_vector (7 DOWNTO 0)
   );
end component;


component uart
generic(
		ADR_REG_TXD			: std_logic_vector(1 downto 0) := "00";
		ADR_REG_RXD			: std_logic_vector(1 downto 0) := "01";
		ADR_REG_STATUS		: std_logic_vector(1 downto 0) := "10";
		ADR_REG_BAUD		: std_logic_vector(1 downto 0) := "11";
		DEFAULT_RATE		: std_logic_vector(7 downto 0) := X"33"
	);
port (
	-- Control
	clk				: in	std_logic;						-- 50MHz Main clock
	rst				: in	std_logic;						-- Main reset
	-- External Interface
	rx				: in	std_logic;							-- RS232 received serial data
	tx				: out	std_logic;							-- RS232 transmitted serial data
	-- uPC Interface
	cpuClk		: in std_logic;
	cpuAdr		: in std_logic_vector(1 downto 0);
	cpuDatFrom	: in std_logic_vector(7 downto 0);
	cpuDatTo		: out std_logic_vector(7 downto 0);
	cpuReq		: in std_logic;							-- '1' when this peripheral should listen
	cpuWr			: in std_logic;							-- '1' when writing
	cpuRd			: in std_logic;							-- '1' when reading
	cpuIntr		: out std_logic;
	
	itsMe			: out std_logic;							-- '1' when this peripheral is selected
	
	bitsOut		: out std_logic_vector(1 downto 0);
	bitsIn		: in std_logic_vector(3 downto 0);
	
	tx_clk		: out std_logic;
	p_tx_end		: out std_logic;
	debug			: out std_logic_vector(7 downto 0)
	);
end component;


----------------------------------------------------------
-- spi_master signal definitions
--
-- clk				Peripheral clock not necessary to be core clock, the core clock can be different (input)
-- rst				Asynchronus reset, is mandatory to provide this signal, active on posedge (input) 
-- datain			data to be sent
-- dataout			data received
-- wr					Send data, asynchronus with 'clk' , active on posedge or negedge(input)
-- rd					Read data, , asynchronus with 'clk' , active on posedge or negedge (input)
-- buffempty		'1' if transmit buffer is empty (output)
-- prescaller		The prescaller divider is = (1 << prescaller) value between 0 and 7 for 
--							dividers by:1,2,4,8,16,32,64,128 and 256 (input)
-- sck				SPI 'sck' signal (output)
-- mosi				SPI 'mosi' signal (output)
-- miso				SPI 'miso' signal (input)
-- ss					SPI 'ss' signal (if send buffer is maintained full the ss signal will 
--							not go high between between transmit chars)(output)
-- lsbfirst			If '0' msb is send first, if '1' lsb is send first (input)
-- mode				All four modes is supported (input)
-- senderr			If you try to send a character if send buffer is full this bit is set to '1', 
--							this can be ignored and if is '1' does not affect the interface (output)
-- res_senderr		To reset 'senderr' signal write '1' wait minimum half core clock and 
--							and after '0' to this bit, is asynchronous with 'clk' (input)
-- charreceived	Is set to '1' if a character is received, if you read the receive buffer 
--							this bit will go '0', if you ignore it and continue to send data this 
--							bit will remain '1' until you read the read register (output)
--
component spi_master
	PORT
	(
		clk				: in std_logic;
		rst				: in std_logic;
		datain			: in std_logic_vector(7 downto 0);		
		wr					: in std_logic;
		rd					: in std_logic;
		prescaller		: in std_logic_vector(2 downto 0);
		mode				: in std_logic_vector(1 downto 0);		
		res_senderr		: in std_logic;
		lsbFirst			: in std_logic;
		
		dataout			: out std_logic_vector(7 downto 0);
		buffempty		: out std_logic;
		senderr			: out std_logic;
		charreceived	: out std_logic;
		
		sck				: out std_logic;
		mosi				: out std_logic;
		miso				: in std_logic;
		ss					: out std_logic	
	);
end component;


component MailBox
	PORT
	(
	
		clock_a		: IN STD_LOGIC  := '1';
		wren_a		: IN STD_LOGIC  := '0';
		address_a	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		data_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		q_a			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);

		clock_b		: IN STD_LOGIC ;
		wren_b		: IN STD_LOGIC  := '0';
		address_b	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		q_b			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;

component IoProcessor
	port(
	rst_n				: in std_logic;
	clk25				: in std_logic;
	clk12M5			: in std_logic;
	
	i2cSda			: inout std_logic;
	i2cScl			: inout std_logic;
	
	spiCs_n			: out std_logic_vector(7 downto 0);
	spiMosi			: out std_logic;
	spiClk			: out std_logic;
	spiMiso			: in std_logic;
	
	sdCS				: out std_logic;
	sdMOSI			: out std_logic;
	sdMISO			: in std_logic;
	sdSCLK			: out std_logic;
	sdcWp_i			: in std_logic;
	sdcCD_i			: in std_logic;

	
-- C64 mailbox signals
	mbC64Clk			: in std_logic;							-- must have at least one positive transition
																		--		during the active period
	mbC64Addr		: in std_logic_vector(15 downto 0);
	mbC64Wena		: in std_logic;							-- active high
	mbC64Din			: in std_logic_vector(7 downto 0);
	mbC64Dout		: out std_logic_vector(7 downto 0);

-- Coprocessor mailbox signals
	mbCopClk			: in std_logic;							-- must have at least one positive transition
																		--		during the active period
	mbCopAddr		: in std_logic_vector(15 downto 0);
	mbCopWena		: in std_logic;							-- active high
	mbCopDin			: in std_logic_vector(7 downto 0);
	mbCopDout		: out std_logic_vector(7 downto 0);

	mbMMClk			: in std_logic;							-- must have at least one positive transition
																		--		during the active period
	mbMMAddr			: in std_logic_vector(15 downto 0);
	mbMMWena			: in std_logic;							-- active high
	mbMMDin			: in std_logic_vector(7 downto 0);
	mbMMDout			: out std_logic_vector(7 downto 0);
	
	debug				: out std_logic_vector(15 downto 0)
    );	 
end component;


component TG68_fast
   port(
		clk			: in std_logic;
		reset			: in std_logic;			--low active
		clkena_in	: in std_logic:='1';
		data_in		: in std_logic_vector(15 downto 0);
		IPL			: in std_logic_vector(2 downto 0):="111";
		test_IPL		: in std_logic:='0';		--only for debugging
		address		: out std_logic_vector(31 downto 0);
		data_write	: out std_logic_vector(15 downto 0);
		state_out	: out std_logic_vector(1 downto 0);
		decodeOPC	: buffer std_logic;
		wr				: out std_logic;
		UDS			: out std_logic;
		LDS			: out std_logic
        );
end component;

component QmtechReu
	PORT
	(
		CLOCK_50			:	 IN STD_LOGIC;

		LEDR				:	 OUT STD_LOGIC;

		KEY				:	 IN STD_LOGIC_VECTOR(1 DOWNTO 0);

		DRAM_ADDR		:	 OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		DRAM_BA			:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		DRAM_CAS_N		:	 OUT STD_LOGIC;
		DRAM_CKE			:	 OUT STD_LOGIC;
		DRAM_CLK			:	 OUT STD_LOGIC;
		DRAM_CS_N		:	 OUT STD_LOGIC;
		DRAM_DQ			:	 INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		DRAM_RAS_N		:	 OUT STD_LOGIC;
		DRAM_WE_N		:	 OUT STD_LOGIC;
		DRAM_UDQM		:	 OUT STD_LOGIC;
		DRAM_LDQM		:	 OUT STD_LOGIC;

		EPCS_ASDO		:	 OUT STD_LOGIC;
		EPCS_DATA0		:	 IN STD_LOGIC;
		EPCS_DCLK		:	 OUT STD_LOGIC;
		EPCS_NCSO		:	 OUT STD_LOGIC;
		
		SER_FROM			: in std_logic;
		SER_TO			: out std_logic;
		
		CSEL0				: in std_logic;
		CSEL1				: in std_logic;
		
		I2C_CLK			: inout std_logic;
		I2C_DAT			: inout std_logic;
		
		DRAM2_ADR		: out std_logic_vector(12 downto 0);
		DRAM2_CSN		: out std_logic;
		DRAM2_RASN		: out std_logic;
		DRAM2_CASN		: out std_logic;
		DRAM2_WEN		: out std_logic;
		DRAM2_LDQM		: out std_logic;
		DRAM2_DQ			: inout std_logic_vector(15 downto 0);
		DRAM2_UDQM		: out std_logic;
		DRAM2_CLK		: out std_logic;
		DRAM2_CKE		: out std_logic;
		DRAM2_BA			: out std_logic_vector(1 downto 0);
		
		P7					: inout std_logic_vector(56 downto 52);
		
		WIFI_RST			: out std_logic;
		WIFI_ENA			: out std_logic;
		WIFI_FROM		: in std_logic;
		WIFI_TO			: out std_logic;

		ROM_CS_N			: out std_logic; 
		ROM_MISO			: in std_logic;
		ROM_SCLK			: out std_logic;
		ROM_MOSI			: out std_logic;
		
		SDDI				: out std_logic;
		SDCS_N			: out std_logic;
		SDDO				: in std_logic;
		SDSCLK			: out std_logic;
		SDCD				: in std_logic;
		SDWP				: in std_logic;

		F_NMI_N			: out std_logic;
		F_RST_N			: in std_logic;
		F_GAME_N			: out std_logic;
		F_IRQ_N			: out std_logic;
		F_EXROM_N		: out std_logic;
		F_DMA_N			: out std_logic;
		
		F_ROMH_N 		: in std_logic;
		F_PHI2			: in std_logic;
		F_RNW				: in std_logic;
		F_DOTCLK			: in std_logic;
		F_IO1_N			: in std_logic;
		F_IO2_N			: in std_logic;
		F_ROML_N			: in std_logic;
		F_BA				: in std_logic;
		F_ADR				: inout std_logic_vector(15 downto 0);
		F_DAT				: inout std_logic_vector(7 downto 0);

		F_NWR1			: out std_logic;
		F_RNWDRV			: out std_logic;
		ADR_DIR			: out std_logic;
		ADR_OE_N			: out std_logic;
		DAT_DIR			: out std_logic;
		DAT_NOE			: out std_logic

	);
end component;


component Sweet16
	PORT
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		ena			: in std_logic;
		
		addr			: out std_logic_vector(15 downto 0);
		wena			: out std_logic;
		datOut		: out std_logic_vector(7 downto 0);
		datIn			: in std_logic_vector(7 downto 0);
		intr			: in std_logic_vector(3 downto 0);
		
		instFetch	: out std_logic		
	);
end component;


	
end QmTechReu_pkg;


package body QmTechReu_pkg is

	-- Type Declaration (optional)

	-- Subtype Declaration (optional)

	-- Constant Declaration (optional)

	-- Function Declaration (optional)

	-- Function Body (optional)

	-- Procedure Declaration (optional)

	-- Procedure Body (optional)
	

end QmTechReu_pkg;
