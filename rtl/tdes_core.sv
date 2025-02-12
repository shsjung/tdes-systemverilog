// -----------------------------------------------------------------------------
// File Name: tdes_core.sv
// Description:
//     This module implements the TDES core functionality as specified in NIST
//     SP 800-67. It uses one instance of the DES core module to perform triple
//     encryption or decryption in accordance with the TDES algorithm.
//
// Author: shsjung (github.com/shsjung)
// Date Created: 02-11-2025
// -----------------------------------------------------------------------------

`define SIM_LOG

module tdes_core (
    input         clk_i,
    input         rst_ni,

    input         start_i,
    input         inv_i,     // 1: decryption, 0: encryption
    input  [63:0] key1_i,
    input  [63:0] key2_i,
    input  [63:0] key3_i,

    input         req_i,
    input  [63:0] in_i,

    output        res_o,
    output [63:0] out_o
);

    logic        start_des;
    logic        inv_des;
    logic [63:0] in_des;
    logic [63:0] key_des;

    logic        finish_des;
    logic [63:0] out_des;

    // FSM
    typedef enum logic [1:0] {
        ST_IDLE,
        ST_DES1,
        ST_DES2,
        ST_DES3
    } state_e;

    state_e state_cur, state_nxt;

    always_comb begin
        state_nxt = state_cur;
        unique case (state_cur)
            ST_IDLE:
                if (req_i) begin
                    state_nxt = ST_DES1;
                end
            ST_DES1:
                if (finish_des) begin
                    state_nxt = ST_DES2;
                end
            ST_DES2:
                if (finish_des) begin
                    state_nxt = ST_DES3;
                end
            ST_DES3:
                if (finish_des) begin
                    state_nxt = ST_IDLE;
                end
            default:
                state_nxt = ST_IDLE;
        endcase
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            state_cur <= ST_IDLE;
        end else begin
            state_cur <= state_nxt;
        end
    end

    // Setting at start_i signal
    logic        inv;
    logic [63:0] key1;
    logic [63:0] key2;
    logic [63:0] key3;
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            inv  <= 1'b0;
            key1 <= 64'h0;
            key2 <= 64'h0;
            key3 <= 64'h0;
        end else if (state_cur == ST_IDLE && start_i) begin
            inv  <= inv_i;
            key1 <= key1_i;
            key2 <= key2_i;
            key3 <= key3_i;
        end
    end

    assign start_des = ((state_cur == ST_IDLE && req_i) ||
                        (state_cur == ST_DES1 && finish_des) ||
                        (state_cur == ST_DES2 && finish_des)) ? 1'b1 : 1'b0;

    assign inv_des = (state_cur == ST_DES1) ?  inv :
                     (state_cur == ST_DES2) ? ~inv :
                     (state_cur == ST_DES3) ?  inv : 1'b0;

    assign in_des = (state_cur == ST_IDLE) ? in_i : out_des;

    assign key_des = (state_cur == ST_DES1) ? ((inv) ? key3 : key1) :
                     (state_cur == ST_DES2) ? key2 :
                     (state_cur == ST_DES3) ? ((inv) ? key1 : key3) : 64'h0;

    // Output

    assign res_o = (state_cur == ST_DES3 && finish_des) ? 1'b1 : 1'b0;

    assign out_o = out_des;

    des_core inst_des_core (
        .clk_i    (clk_i),
        .rst_ni   (rst_ni),

        .start_i  (start_des),
        .inv_i    (inv_des),
        .in_i     (in_des),
        .key_i    (key_des),

        .finish_o (finish_des),
        .out_o    (out_des)
    );

`ifdef SIM_LOG
    always_ff @(posedge start_i) begin
        if (start_i) begin
            $display("start in: inv  (%x)", inv_i);
            $display("          key1 (%x)", key1_i);
            $display("          key2 (%x)", key2_i);
            $display("          key3 (%x)", key3_i);
        end
    end

    always_ff @(posedge req_i) begin
        if (req_i)
            $display("req in : in  (%x)", in_i);
    end

    always_ff @(posedge res_o) begin
        if (res_o)
            $display("res out: out (%x)", out_des);
    end
`endif

endmodule
