# ReuPlus

This project implements an open source REU for the Commodore 64.

The hardware consists of two PCBs
* QmTech EP4CE15F23C8N development board
The board provides the FPGA and its configurator, 32MBi SDRAM,
two push buttons, one LED and the voltage converters for the
FPGA power supplies.

The board also provides a total of 114 3.3V TTL compatible
I/O pins.

* Custom carrier board
The main functions of the custom carrier board are to provide:
** A mechanical and electrical interface for the FPGA board.
** A card edge connector compatible with the C64
** The logic level shifters required to convert between the C64 5V signals and the FPGA 3.3V signal levels.
** Interfacing and power for the peripheral items on the PCB

# REU Functionality
As implemented on this device, the REU has access to 32MBi of
SDRAM storage. All logic for the REU is implemented in a FSM
programmed into the FPGA.

As of 30 May 2020, the REU has been tested using the software on the
1764-DEMO.D64 disk image. Note that all testing is performed on a
C64C using an SD2IEC interface.

The software that has been successfully
run is:
* "1764 RAMTEST.BAS"
* "POUND.BAS"
* "GLOBE.BAS"

So far, all programs have run successfully. Note however,
none of these programs tests all 32MBi of memory and none perform
what would be considered a proper memory test.

I am presently writing tests that will do that.

# Additional Peripherals

The peripherals used on the board are all off-the-shelf modules. This
was done for two reasons. The first is to speed development time. There
was enough to do in the FPGA development that I did not want to spend
time debugging both the peripheral design and the FPGA code for a particular
peripheral. The second reason was that using modules would allow the end
users to purchase only those modules they desired and so save some cost.

The downside is that the design is held hostage to the available modules.
The RTC modules have been a particular issue since they go in and out of stock
fairly regularly. This design has used two different modules, one of which
is obsolete and the other which was out of stock as of this writing.

All of this may require that the RTC (at a minimum) is incorporated into
the carrier board design.

The carrier board contains provision for the following peripherals:

* I2C battery backed RTC.
This is an ADA Fruit module and has been tested on the carrier board.
NOTE: I used a OTS board to hasten development - which worked.

* WIFI module with serial interface
This is a module that would allow connection of the C64 to the internet
via standard WIFI. These modules are relatively inexpensive and are readily
available. No testing has been done yet with this module.

* 128 byte I2C EEPROM
This chip contains 64 bytes of EEPROM for parameter storage. The other
128 bytes is used to store the MAC address required by the WIFI module.
The component is manufactured by Microchip Technologies and is inexpensive
and readily available.

* USB to serial module
This module provides up to 3M bits per second serial communications via
a USB connection. The C64 side uses a standard asynchronous protocol. It
is envisioned that this will be a packet based peripheral with the C64
communication with an FPGA buffer that holds up to 256 bytes. The C64
would then tell the FPGA to send or receive a packet. The C64 would
then go on its merry way until it was interrupted when the packet
operation was completed.

* 8MBi Serial Flash
This chip is designed to store code and data that can be loaded
into the onboard memory. So far this is still not well developed
but I am looking at adding something like EZFlash-like functionality.
This device will never be EZFlash compatible because of fundamental
incompatiblities in the address spaces.

* SD Card
The carrier board has a full size SD card connector. Presently there
are no specific plans for its use. This board will not attempt SD2IEC
functionality since there are many better alternatives.

# Future

This board also has provision for a second 32MBi SDRAM on board. It is
intended to be the main memory for a coprocessor resident in the FPGA.
There are many options here (Z80, 6502, 65C02, 65C816, 68000, etc).

This will need to wait until higher priority items have been addressed.

*** End of document ***


