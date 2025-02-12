// -----------------------------------------------------------------------------
// File Name: tdes_top.sv
//
// Author: shsjung (github.com/shsjung)
// Date Created: 02-11-2025
// -----------------------------------------------------------------------------

module tdes_top (
    input           clk_i,
    input           rst_ni,

    input           start_i,    // start signal of new encryption or decryption
                                // enable of inv_i, key1_i, key2_i, key3_i
    input           inv_i,      // 1: decryption, 0: encryption
    input   [63:0]  key1_i,
    input   [63:0]  key2_i,
    input   [63:0]  key3_i,

    input           req_i,      // enable signal of in_i
    input   [63:0]  in_i,       // 64-bit input block

    output          res_o,      // enable signal of out_o
    output  [63:0]  out_o       // 64-bit output block
);

    logic        start_des;
    logic        inv_des;
    logic [63:0] in_des;
    logic [63:0] key_des;

    logic        finish_des;
    logic [63:0] out_des;

    tdes_core inst_tdes_core (
        .clk_i        (clk_i),
        .rst_ni       (rst_ni),

        .start_i      (start_i),
        .inv_i        (inv_i),
        .key1_i       (key1_i),
        .key2_i       (key2_i),
        .key3_i       (key3_i),

        .req_i        (req_i),
        .in_i         (in_i),

        .res_o        (res_o),
        .out_o        (out_o)
    );

endmodule
