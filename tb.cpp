#include "Vtdes_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#define CLOCK_POS \
    top->clk_i = !top->clk_i; \
    top->eval()
#define CLOCK_NEG \
    top->eval(); \
    tfp->dump(local_time++); \
    top->clk_i = !top->clk_i; \
    top->eval(); \
    tfp->dump(local_time++)
#define CLOCK_DELAY(x) \
    for (int xx=0; xx < x; xx++) { \
        top->clk_i = !top->clk_i; \
        CLOCK_NEG; \
    }

int main(int argc, char **argv) {
    int i, local_time = 0;

    Verilated::commandArgs(argc, argv);
    Vtdes_top* top = new Vtdes_top;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("tdes_top.vcd");

    CLOCK_DELAY(5);

    CLOCK_POS;
    top->rst_ni = 1;
    CLOCK_NEG;

    CLOCK_DELAY(10);

    printf("Test case 1 start\n");
    CLOCK_POS;
    top->inv_i = 0;
    top->key1_i = 0x0123456789abcdef;
    top->key2_i = 0x23456789abcdef01;
    top->key3_i = 0x456789abcdef0123;
    CLOCK_NEG;

    CLOCK_POS;
    top->start_i = 1;
    CLOCK_NEG;

    CLOCK_POS;
    top->start_i = 0;
    CLOCK_NEG;

    CLOCK_POS;
    top->req_i = 1;
    top->in_i = 0x6bc1bee22e409f96;
    CLOCK_NEG;

    CLOCK_POS;
    top->req_i = 0;
    CLOCK_NEG;

    CLOCK_DELAY(60);

    printf("Test case 2 start\n");
    CLOCK_POS;
    top->inv_i = 1;
    top->key1_i = 0x0123456789abcdef;
    top->key2_i = 0x23456789abcdef01;
    top->key3_i = 0x456789abcdef0123;
    CLOCK_NEG;

    CLOCK_POS;
    top->start_i = 1;
    CLOCK_NEG;

    CLOCK_POS;
    top->start_i = 0;
    CLOCK_NEG;

    CLOCK_POS;
    top->req_i = 1;
    top->in_i = 0x714772f339841d34;
    CLOCK_NEG;

    CLOCK_POS;
    top->req_i = 0;
    CLOCK_NEG;

    CLOCK_DELAY(60);

    printf("Test finished\n");

    tfp->close();
    delete top;
    delete tfp;
    return 0;

}
