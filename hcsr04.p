// Define the entry point of the program
.origin 0
.entrypoint START

// Address of the io controllers for GPIO1, GPIO2 and GPIO3
#define GPIO0 0x44E07000
#define GPIO1 0x4804C000
// #define GPIO02 0x481AC000
// #define GPIO03 0x481AE000

// Address of the PRUn_CTRL registers
#define PRU0_CTRL 0x22000
#define PRU1_CTRL 0x24000

// Offset address for the output enable register of the gpio controller
#define GPIO_OE 0x134

// Offset address for the data in/out register of the gpio controller
#define GPIO_DATAIN 0x138
#define GPIO_CLEARDATAOUT 0x190
#define GPIO_SETDATAOUT 0x194

// Offset address for the CYCLE register of PRU controller
#define CYCLE 0xC

// Bit for enabling the cycle counter on PRU_CTRL register
#define CTR_EN 3

// TRIGGER PIN
// gpio1[12] P8_12 gpio44 0x030
#define BIT_TRIGGER44 0x0C

// ECHOS
// gpio1[15] P8_15 gpio47 0x
#define BIT_ECHO47 0x0F
//gpio1[14] P8_16 gpio46 0x
#define BIT_ECHO46 0x0E
//gpio0[2] P9_22 gpio2 0x
#define BIT_ECHO2 0x02
// gpio0[14] P9_26 gpio14 0x0
#define BIT_ECHO14 0x0E
// gpio0[15] P9_24 gpio15 0x0
#define BIT_ECHO15 0x0F

// PRU interrupt for PRU0
#define PRU0_ARM_INTERRUPT 19

START:

	// Clear the STANDBY_INIT bit in the SYSCFG register
	// otherwise the PRU will not be able to write outside the PRU memory space
	// and to the Beaglebone pins
	LBCO r0, C4, 4, 4
	CLR r0, r0, 4
	SBCO r0, C4, 4, 4
	
	// Make constant 24 (c24) point to the beginning of PRU0 data ram
        // 0x22000 is PRU_CTRL Registers. 0x20 is the offset for register that determines C24 address
        // SBBO copies 4 bytes of r0 to r1
	MOV r0, 0x00000000
	MOV r1, 0x22020
	SBBO r0, r1, 0, 4

        // Enable Cycle Counter. 0x2200 is address of PRU_CTRL register. CTR_EN is bit the enables the counter
        MOV r1, PRU0_CTRL
        LBBO r0, r1, 0, 4
        SET r0, CTR_EN
        SBBO r0, r1, 0, 4

	// Enable trigger as output and echo as input (clear BIT_TRIGGER and set BIT_ECHO of output enable)
	MOV r1, GPIO1 | GPIO_OE
	LBBO r0, r1, 0, 4
	CLR r0, BIT_TRIGGER
        SBBO r0, r1, 0, 4

        MOV r1, GPIO0 | GPIO_OE
        LBBO r0, r1, 0, 4
	SET r0, BIT_ECHO
        SET r0, BIT_ECHO1
	SBBO r0, r1, 0, 4
BEGIN:
        MOV r0, 8
        MOV r1, 40
        // Should write 47 to 0x04 address and 54 to 0x00 address then interrupt
LOOP:
        ADD r1, r1, 7
        SUB r0, r0, 4
        SBCO r1, c24, r0, 4
        QBNE LOOP, r0, 0

	MOV r31.b0, PRU0_ARM_INTERRUPT+16

        // 200 MHZ = 5ns per operation = 10ns per loop
        // 10 million loops = 10 ms delay
        MOV r0, 10000000
WAIT:
        SUB r0, r0, 1
        QBNE WAIT, r0, 0
	// Jump back to beginning
	JMP BEGIN

	HALT

