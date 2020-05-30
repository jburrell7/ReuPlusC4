
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.QmTechReu_pkg.all;


entity QmtechReu is
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
--		WIFI_FROM		: in std_logic;
		WIFI_FROM		: out std_logic;
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
END QmtechReu;


architecture behave of QmtechReu is

component testRam
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		byteena		: IN STD_LOGIC_VECTOR (1 DOWNTO 0) :=  (OTHERS => '1');
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end component;

-------------------------------------------
-- clock PLL signals
--
signal clk100				: std_logic;
signal clk100dly			: std_logic;
signal clk25				: std_logic;
signal clk50				: std_logic;
signal clk50dly			: std_logic;
signal clk12M5				: std_logic;
signal pllLocked			: std_logic;
-------------------------------------------
-- timing generator signals
--
signal phi2Sync			: std_logic;
signal clk16M				: std_logic;
signal dlyCpuWr			: std_logic;
signal dlyCpuRd			: std_logic;
signal phi2PosEdge		: std_logic;
signal phi2NegEdge		: std_logic;
signal davPos				: std_logic;
signal davNeg				: std_logic;
-------------------------------------------
-- C64 bus signals
--
signal c64BusDrive_node		: t_c64BusDrive;
signal c64BusInputs			: t_c64BusInputs;

signal reuC64Drive			: t_c64BusDrive;
signal cpuC64Drive			: t_c64BusDrive;
signal ezRomC64Drive			: t_c64BusDrive;
signal regsC64Drive			: t_c64BusDrive;

signal c64BusDrvIsReu		: std_logic;
signal c64BusDrvIsSCpu		: std_logic;
signal c64BusDrvIsRegs		: std_logic;

-------------------------------------------
-- QmTech SDRAM
--
signal dramCke				: std_logic;
signal dramCsn				: std_logic;
signal dramRasn			: std_logic;
signal dramCasn			: std_logic;
signal dramWen				: std_logic;
signal dramBa				: std_logic_vector( 1 downto 0);
signal dramAddr			: std_logic_vector(12 downto 0);
signal dramDq				: std_logic_vector(15 downto 0);
signal dramUdqm			: std_logic;
signal dramLdqm			: std_logic;
signal dramClkNode		: std_logic;


-------------------------------------------
-- REU SDRAM memory signals
--
signal reuRfrshCmd		: std_logic;
signal reuMemRwCmd		: std_logic;
signal reuMemRdy			: std_logic;
signal reuMemCmdDone		: std_logic;
signal reuMemWena_n		: std_logic;
signal reuMemDatOut		: std_logic_vector(15 downto 0);
signal reuMemDatIn		: std_logic_vector(15 downto 0);
signal reuMemAdr			: std_logic_vector(24 downto 0);
signal reuActive			: std_logic;
signal reuRst				: std_logic;
signal reuFsmIdle			: std_logic;

-------------------------------------------
-- misc signals
	
-------------------------------------------
-- signals to keep Modelsim happy
signal sdramRst			: std_logic;
signal sramUb				: std_logic;

signal reuDebug			: std_logic_vector(15 downto 0);
	
signal clkCtr			: std_logic_vector(31 downto 0);
signal ledNode			: std_logic;


signal rstNode				: std_logic;
signal syncReset_n		: std_logic;
signal syncReset			: std_logic;
signal syncResetSreg		: std_logic_vector(3 downto 0);
signal syncResetCtr		: integer range 0 to 524287;
signal syncResetState	: integer range 0 to 3;


signal key0Sync			: std_logic_vector(3 downto 0) := "0000";
signal c64RstSync			: std_logic_vector(3 downto 0) := "0000";

	
signal tramBena			: std_logic_vector(1 downto 0);
signal tramWena			: std_logic;
signal tramClk				: std_logic;

signal reuRegSpace		: std_logic;
signal tstNode				: std_logic;

signal adrNode				: std_logic_vector(15 downto 0);
signal adrDir				: std_logic;
signal datOutNode			: std_logic_vector(7 downto 0);
signal datDir				: std_logic;


begin

	SER_TO		<= '1';
	I2C_CLK		<= '0';
	I2C_DAT		<= '0';
	
	ROM_CS_N		<= '1';
	ROM_SCLK		<= '0';
	ROM_MOSI		<= '0';
	
	SDDI			<= '0';
	SDCS_N		<= '1';
	SDSCLK		<= '0';



process(CLOCK_50, KEY(0), ledNode)
begin

	if (KEY(0) = '0') then
		ledNode		<= '1';
		clkCtr		<= (others => '0');
	elsif rising_edge(CLOCK_50) then
		if (clkCtr = 49999999) then
			clkCtr		<= (others => '0');
			ledNode		<= not ledNode;
		else
			clkCtr	<= clkCtr + 1;
		end if;
	
	end if;
--	LEDR		<= ledNode;
	LEDR		<= not reuActive;

end process;

--	DRAM2_ADR(3)	<= reuDebug(8);	-- U7-13
--	DRAM2_ADR(2)	<= reuDebug(9);	-- U7-14
--	DRAM2_ADR(1)	<= reuDebug(10);	-- U7-15
--	DRAM2_ADR(0)	<= reuDebug(11);	-- U7-16
--	DRAM2_ADR(10)	<= reuDebug(12);	-- U7-17
--	DRAM2_BA(1)		<= reuDebug(13);	-- U7-18
--	DRAM2_BA(0)		<= reuDebug(14);	-- U7-19
--	DRAM2_CSN 		<= reuDebug(15);	-- U7-20
--	DRAM2_RASN		<= '0';			-- U7-21
--	DRAM2_CASN		<= '0';			-- U7-22
--	DRAM2_WEN		<= '0';			-- U7-23
--	DRAM2_LDQM		<= '0';			-- U7-24
--	DRAM2_DQ(7)		<= '0';			-- U7-25
--	DRAM2_DQ(6)		<= '0';			-- U7-26
--	DRAM2_DQ(5)		<= '0';			-- U7-27
--	DRAM2_DQ(4)		<= '0';			-- U7-28
--	DRAM2_DQ(3)		<= '0';			-- U7-29

	P7(52)		<= F_IO1_N and F_IO2_N;
	P7(53)		<= c64BusDrvIsReu;		--reuMemCmdDone;		--clk100dly;
	P7(54)		<= phi2Sync;
	P7(55)		<= F_RNW;
	P7(56)		<= reuActive;	
	
	c64BusDrvIsSCpu			<= '0';

--	F_NMI_N  	<= c64BusDrive_node.nmi_n;
--	F_IRQ_N  	<= c64BusDrive_node.irq_n;	
--	F_GAME_N 	<= c64BusDrive_node.game_n;
--	F_EXROM_N	<= c64BusDrive_node.exrom_n;
--	F_DMA_N  	<= c64BusDrive_node.dma_n;
--	F_NWR1   	<= c64BusDrive_node.nwr1;
--	F_RNWDRV 	<= c64BusDrive_node.rnw_drv;
--	ADR_DIR  	<= c64BusDrive_node.adr_dir;
--	ADR_OE_N 	<= c64BusDrive_node.adr_oen;
--	DAT_DIR  	<= c64BusDrive_node.dat_dir;
--	DAT_NOE  	<= c64BusDrive_node.dat_oen;
--	F_ADR			<= c64BusDrive_node.adr;
--	F_DAT			<= c64BusDrive_node.dat;
--

	F_ADR			<= adrNode		when (adrDir = ADRS_TO_C64) else
						"ZZZZZZZZZZZZZZZZ";
	F_DAT			<= datOutNode	when (datDir = DATA_TO_C64) else
						"ZZZZZZZZ";
---------------------------------------------	
-- C64 bus signal assignments
--	
c64Drv:process(c64BusDrive_node, c64BusDrvIsReu)
begin
----------- Outputs to the C64 -----------


	if (c64BusDrvIsReu = '1') then
		tstNode		<= '1';
	
		F_DMA_N  	<= c64BusDrive_node.dma_n;
		F_NWR1   	<= c64BusDrive_node.nwr1;
		F_RNWDRV 	<= c64BusDrive_node.rnw_drv;
		ADR_DIR  	<= c64BusDrive_node.adr_dir;
		ADR_OE_N 	<= c64BusDrive_node.adr_oen;
		DAT_DIR  	<= c64BusDrive_node.dat_dir;
		DAT_NOE  	<= c64BusDrive_node.dat_oen;
		
		adrDir		<= c64BusDrive_node.adr_dir;
		adrNode		<= c64BusDrive_node.adr;
		datDir		<= c64BusDrive_node.dat_dir;
		datOutNode	<= c64BusDrive_node.dat;				
	else
		tstNode		<= '0';
	
		F_DMA_N		<= '1';
		F_NWR1   	<= not ASSERT_WRGATE;		-- nwr1
		F_RNWDRV 	<=	not ASSERT_WENA;			-- rnw_drv
		ADR_DIR  	<= ADRS_FROM_C64;				-- adr_dir
		ADR_OE_N 	<= ADRS_ENA;					-- adr_oen
		DAT_DIR  	<= DATA_FROM_C64;				-- dat_dir
		DAT_NOE  	<= DATA_ENA;					-- dat_oen

		adrDir		<= ADRS_FROM_C64;
		adrNode		<= x"0000";
		datDir		<= DATA_FROM_C64; 
		datOutNode	<= x"00";
	end if;
	
	F_NMI_N  	<= c64BusDrive_node.nmi_n;
	F_IRQ_N  	<= c64BusDrive_node.irq_n;	
	F_GAME_N 	<= c64BusDrive_node.game_n;
	F_EXROM_N	<= c64BusDrive_node.exrom_n;
	
end process;

---------- Inputs from the C64 -----------
	c64BusInputs.rst_n		<= syncReset_n;
	c64BusInputs.romh_n		<= F_ROMH_N;
	c64BusInputs.phi2			<= F_PHI2;
	c64BusInputs.rnw			<= F_RNW;
	c64BusInputs.dotClk		<= F_DOTCLK;
	c64BusInputs.io1_n		<= F_IO1_N;
	c64BusInputs.io2_n		<= F_IO2_N;
	c64BusInputs.roml_n		<= F_ROML_N;
	c64BusInputs.ba			<= F_BA;
	c64BusInputs.adrIn		<= F_ADR;
	c64BusInputs.datIn		<= F_DAT;

	c64BusDrive_node		<= reuC64Drive		when (c64BusDrvIsReu   = '1') else
									cpuC64Drive		when (c64BusDrvIsSCpu  = '1') else
									regsC64Drive	when (c64BusDrvIsRegs  = '1') else
									C64DRV_DEFAULT;

									
									
	reuRegSpace	<= '1' when ((F_ADR(7 downto 0) >= x"00") and 
									 (F_ADR(7 downto 0) <= x"3F") and 
									 (F_IO2_N = '0')) else
						'0';
	
	reuRst		<= syncReset_n and reuMemRdy;									
reu88:R8800R1
	port map(
	clk100			=> clk100,
	rst_n				=> syncReset_n,		--F_RST_N,
	
	c64BusDrv		=> reuC64Drive,
	c64BusInputs	=> c64BusInputs,
	
	reuHasBus		=> c64BusDrvIsReu,
	reuActive		=> reuActive,
	phiPosEdge		=> phi2PosEdge,
	davPos			=> davPos,
	davNeg			=> davNeg,
	reuRegSpace		=> reuRegSpace,
	
	syncPhi2			=> phi2Sync,
	
	debug				=> reuDebug,

	sdramAdr			=> reuMemAdr,
	sdramDatTo		=> reuMemDatIn,
	sdramRfshCmd	=> reuRfrshCmd,
	sdramRWCmd		=> reuMemRwCmd,
	sdramWe_n		=> reuMemWena_n,
	
	sdramDatFrom	=> reuMemDatOut,
	sdramOpDone		=> reuMemCmdDone,
	sdramFsmIdle	=> reuFsmIdle
    );
	 
	sdramRst			<= (not pllLocked) or (not key0Sync(3)) or (not c64RstSync(3));
	sramUb			<= not reuMemAdr(0);	
--reuMem:sdram_simple
reuMem:sdramSimple4Mx4x2
	port map(
	-- Host side
		clk_100m0_i		=> clk50,		
		reset_i			=> sdramRst,
		
		refresh_i		=> reuRfrshCmd,					-- Initiate a refresh operation, active high
		rw_i				=> reuMemRwCmd,					-- Initiate a read or write operation, active high
		we_i				=> reuMemWena_n,					-- Write enable, active low
		addr_i			=> reuMemAdr(24 downto 1),
		data_i			=> reuMemDatIn,
		ub_i				=> sramUb,
		lb_i				=> reuMemAdr(0),
		ready_o			=> reuMemRdy,						--Set to '1' when the memory is ready
		done_o			=> reuMemCmdDone,					-- Read, write, or refresh, operation is done
		idle_o			=> reuFsmIdle,		
		data_o			=> reuMemDatOut,

	-- SDRAM side
		sdCke_o			=> DRAM_CKE,
		sdCe_bo			=> DRAM_CS_N,
		sdRas_bo			=> DRAM_RAS_N,
		sdCas_bo			=> DRAM_CAS_N,
		sdWe_bo			=> DRAM_WE_N,
		sdBs_o			=> DRAM_BA,
		sdAddr_o			=> DRAM_ADDR,
		sdData_io		=> DRAM_DQ,
		sdDqmh_o			=> DRAM_UDQM,
		sdDqml_o			=> DRAM_LDQM
		);
	DRAM_CLK			<= clk50dly;
		

----------------------------------------------------
-- DEBUG TESTING
----------------------------------------------------
--	tramClk			<= clk50;
--	tramBena(0)		<= not reuMemAdr(0);
--	tramBena(1)		<=     reuMemAdr(0);
--	
--tram:testRam
--	PORT map(
--		clock		=> tramClk,
--		
--		address	=> reuMemAdr(10 downto 1),
--		byteena	=> tramBena,
--
--		data		=> reuMemDatIn,
--		wren		=> tramWena,
--		q			=> reuMemDatOut
--	);
--
----	reuMemDatOut	<= x"AABB";
--	
--	
--tramFsm:process(tramClk, sdramRst)
--variable timer			: integer range 0 to 511;
--variable fsmState		: integer range 0 to 31;
--variable rfrshSync	: std_logic;
--variable rnwSync		: std_logic;
--variable wenaSyc		: std_logic;
--begin
--
--	if (sdramRst = '1') then
--		timer					:= 0;
--		fsmState				:= 0;
--		reuMemRdy			<= '0';
--		reuFsmIdle			<= '0';
--		reuMemCmdDone		<= '0';
--		tramWena				<= '0';
--	elsif rising_edge(tramClk) then
--		reuMemRdy			<= '1';
--		reuMemCmdDone		<= '0';
--		reuFsmIdle			<= '0';
--		tramWena				<= '0';
--		case fsmState is
--		when 0 =>
--		-- simulate the SDRAM reset time
--			reuMemRdy	<= '0';
--			timer		:= timer + 1;
--			if (timer = 500) then
--				fsmState		:= 1;
--			else
--				fsmState		:= 0;
--			end if;
--		when 1 =>
--			reuFsmIdle	<= '1';
--			timer			:= 0;
--			if 	(rfrshSync = '1') then
--				fsmState		:= 2;
--			elsif	(rnwSync = '1') then
--				if (wenaSyc = '1') then
--					fsmState		:= 2;
--				else
--					fsmState		:= 4;
--				end if;
--			else
--				fsmState		:= 1;
--			end if;
--		when 2 =>
--			timer			:= timer + 1;
--			if (timer = 4) then
--				fsmState		:= 3;
--			else
--				fsmState		:= 2;
--			end if;
--		when 3 =>
--			reuMemCmdDone	<= '1';
--			fsmState			:= 1;
--			
--	-- write to the test RAM
--		when 4 =>
--			tramWena			<= '1';
--			fsmState			:= 5;
--		when 5 =>
--			tramWena			<= '1';
--			fsmState			:= 6;
--		when 6 =>
--			tramWena			<= '1';
--			fsmState			:= 7;
--		when 7 =>
--			fsmState			:= 3;
--			
--		when others =>
--			fsmState		:= 0;
--		end case;
--	
--	end if;
--	
--	
--	if rising_edge(tramClk) then
--		rfrshSync	:= reuRfrshCmd;
--		rnwSync		:= reuMemRwCmd;
--		wenaSyc		:= reuMemWena_n;
--	end if;
--	
--	
--end process;

	
	
clkgen:clkPll
	PORT map(
		inclk0	=> CLOCK_50,
		c0			=> clk100,
		c1			=> clk100dly,
		c2			=> clk50,
		c3			=> clk50dly,
		c4			=> clk12M5,
		locked	=> pllLocked
	);

tgen:timingGen
	port map(
	rst_n				=> pllLocked,
	clk100			=> clk100,
	dotClk			=> c64BusInputs.dotClk,
	phi2				=> c64BusInputs.phi2,
	
	cpuWr_n			=> c64BusInputs.rnw,
	
	phi2Sync			=> phi2Sync,
	clk16M			=> clk16M,
	dlyCpuWr			=> dlyCpuWr,
	dlyCpuRd			=> dlyCpuRd,
	phi2PosEdge		=> phi2PosEdge,
	phi2NegEdge		=> phi2NegEdge,
	
	davPos			=> davPos,
	davNeg			=> davNeg
);	


rstKey:process(F_RST_N, clk100, pllLocked, KEY, 
					key0Sync, syncReset_n, rstNode, 
					c64RstSync, reuMemRdy)
begin

--
-- async reset
--
	rstNode		<= F_RST_N and KEY(0) and pllLocked and reuMemRdy;
	
	syncReset	<= not syncReset_n;

	
	if (rstNode = '0') then
		syncResetSreg		<= "1111";
	elsif rising_edge(clk100) then
		syncResetSreg		<= syncResetSreg(3 downto 1) & rstNode;
	end if;
	
	if (rstNode = '0') then
		syncReset_n			<= '0';
		syncResetCtr		<= 0;
		syncResetState		<= 0;
	elsif rising_edge(clk100) then
		syncReset_n			<= '1';
		case syncResetState is
		when 0 =>
			if	(syncResetSreg(3 downto 2) = "10") then
				syncResetState		<= 1;
			else
				syncResetState		<= 0;
			end if;
		when 1 =>
			syncReset_n				<= '0';
			syncResetCtr			<= syncResetCtr + 1;
			if (syncResetCtr = 500000) then
				syncResetState		<= 2;
			else
				syncResetState		<= 1;
			end if;
		when 2 =>
			syncReset_n				<= '0';
			if (syncResetSreg(3) = '1') then
				syncResetState		<= 0;
			else
				syncResetState		<= 2;
			end if;
		when others =>
			syncResetState		<= 0;
		end case;		
	end if;

-- syncronize the button input
	if rising_edge(clk100) then
		key0Sync		<= key0Sync(2 downto 0) & KEY(0);
	end if;
		
	if rising_edge(clk100) then
		c64RstSync	<= c64RstSync(2 downto 0) & F_RST_N;
	end if;
		
end process;


end behave;

