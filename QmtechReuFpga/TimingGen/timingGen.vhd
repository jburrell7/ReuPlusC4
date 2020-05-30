----------------------------------------------------------------------------------
-- Creation Date: 21:12:48 05/06/2010 
-- Module Name: RS232/UART Interface - Behavioral
-- Used TAB of 4 Spaces
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity timingGen is
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
end timingGen;

architecture Behavioral of timingGen is

component clk16MDrv
	PORT
	(
		inclk		: IN STD_LOGIC ;
		outclk		: OUT STD_LOGIC 
	);
end component;


signal clk8Sync		: std_logic_vector(1 downto 0);
signal clkPhiSync		: std_logic_vector(3 downto 0);
signal stateCtr		: integer range 0 to 15;
signal stateCtr2		: integer range 0 to 7;
signal waitCtr			: integer range 0 to 63;
signal stateCtr3		: integer range 0 to 7;
signal waitCtr1		: integer range 0 to 63;

signal clk16MNode		: std_logic;
	
begin


u1:clk16MDrv
	PORT map(
		inclk		=> clk16MNode,
		outclk	=> clk16M
	);


process(rst_n, clk100, dotClk, phi2)

begin

	if (rst_n = '0') then
		clk8Sync		<= "00";
		phi2Sync		<= '0';
	elsif rising_edge(clk100) then
		clk8Sync		<= clk8Sync(0) & dotClk;
		phi2Sync		<= phi2;
	end if;
	
	if (rst_n = '0') then
		clkPhiSync		<= "0000";
	elsif rising_edge(clk100) then
		clkPhiSync		<= clkPhiSync(2 downto 0) & phi2;
	end if;
	

	
	
	if (rst_n = '0') then
		stateCtr			<= 0;
		clk16MNode		<= '0';
	elsif rising_edge(clk100) then
		case stateCtr is
		when 0 =>
			clk16MNode		<= '0';
			if (clk8Sync(1) = '1') then
				clk16MNode	<= '1';
				stateCtr		<= 1;
			else
				stateCtr		<= 0;
			end if;
		when 1 =>
			clk16MNode		<= '1';
			stateCtr			<= 2;
		when 2 =>
			clk16MNode		<= '1';
			stateCtr			<= 3;
		when 3 =>
			clk16MNode		<= '0';
			stateCtr			<= 4;		
		when 4 =>
			clk16MNode		<= '0';
			stateCtr			<= 5;
		when 5 =>
			clk16MNode		<= '0';
			stateCtr			<= 6;
		when 6 =>
			clk16MNode		<= '1';
			stateCtr			<= 7;
		when 7 =>
			clk16MNode		<= '1';
			stateCtr			<= 8;
		when 8 =>
			clk16MNode		<= '1';
			stateCtr			<= 9;
		when others =>
			clk16MNode		<= '0';
			stateCtr			<= 0;			
		end case;
	end if;
	
	
	
	if (rst_n = '0') then
		stateCtr2		<= 0;
		dlyCpuWr			<= '0';
		dlyCpuRd			<= '0';
		waitCtr			<= 0;
	elsif rising_edge(clk100) then
		dlyCpuWr			<= '0';
		dlyCpuRd			<= '0';
		case stateCtr2 is
		when 0 =>
			if (clkPhiSync(2 downto 1) = "01") then
				stateCtr2	<= 1;
			else
				stateCtr2	<= 0;
			end if;
			waitCtr			<= 0;
		when 1 =>
			waitCtr			<= waitCtr + 1;
			if (waitCtr = 10) then
				stateCtr2	<= 2;
			else
				stateCtr2	<= 1;
			end if;
		when 2 =>
			waitCtr			<= 0;
			stateCtr2		<= 3;
		when 3 =>
			dlyCpuWr			<= not cpuWr_n;
			dlyCpuRd			<= cpuWr_n;
			waitCtr			<= waitCtr + 1;
			if (waitCtr = 10) then
				stateCtr2	<= 4;
			else
				stateCtr2	<= 3;
			end if;
		when 4 =>
			if (clkPhiSync(2 downto 1) = "10") then
				stateCtr2	<= 0;
			else
				stateCtr2	<= 4;
			end if;
		when others =>
			stateCtr2		<= 0;
			waitCtr			<= 0;
		end case;
	end if;


	if (rst_n = '0') then
		stateCtr3		<= 0;
		waitCtr1			<= 0;
		phi2PosEdge		<= '0';
		phi2NegEdge		<= '0';
		davPos			<= '0';
		davNeg			<= '0';
		
	elsif rising_edge(clk100) then
		phi2PosEdge		<= '0';
		phi2NegEdge		<= '0';
		davPos			<= '0';
		davNeg			<= '0';
		case stateCtr3 is
		when 0 =>
			phi2PosEdge		<= '0';
			phi2NegEdge		<= '0';
			waitCtr1			<= 0;
			if (clkPhiSync(1 downto 1) = "01") then
				stateCtr3	<= 1;
			else
				stateCtr3	<= 0;
			end if;
		when 1 =>
			waitCtr1			<= waitCtr1 + 1;
			if (waitCtr1 = 40) then
				stateCtr3	<= 2;
			else
				stateCtr3	<= 1;
			end if;			
			if (waitCtr1 > 30) then
				davPos		<= '1';
			end if;	
			if (waitCtr1 < 11) then
				phi2PosEdge		<= '1';
			end if;	
	
		when 2 =>
			waitCtr1			<= 0;
			if (clkPhiSync(2 downto 1) = "10") then
				stateCtr3	<= 3;
			else
				stateCtr3	<= 2;
			end if;
		when 3 =>
			waitCtr1			<= waitCtr1 + 1;
			if (waitCtr1 = 40) then
				stateCtr3	<= 0;
			else
				stateCtr3	<= 3;
			end if;			
			if (waitCtr1 > 30) then
				davNeg		<= '1';
			end if;	
			if (waitCtr1 < 10) then
				phi2NegEdge		<= '1';
			end if;				
		when others =>
			stateCtr3		<= 0;
		end case;
	end if;

end process;



end Behavioral;
