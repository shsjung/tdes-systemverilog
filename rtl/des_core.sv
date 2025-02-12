// -----------------------------------------------------------------------------
// File Name: des_core.sv
// Description:
//     This module implements DEA transformation as defined Section 2.1 and 2.2
//     of NIST SP 800-67. The detailed steps of this function are described in
//     Figure 1 of the document.
//
// Author: shsjung (github.com/shsjung)
// Date Created: 02-10-2025
// -----------------------------------------------------------------------------

module des_core (
    input           clk_i,
    input           rst_ni,

    input           start_i,
    input           inv_i,     // 0: encryption, 1: decryption
    input   [1:64]  in_i,
    input   [1:64]  key_i,

    output          finish_o,
    output  [1:64]  out_o
);
    genvar i1, i2;

    logic       running;
    logic [3:0] round;
    logic [3:0] round_key;
    logic       finish;

    logic [1:48] k;
    logic [31:0] l, r;
    logic [31:0] z;

    logic [1:64] perm1;
    logic [1:64] perm2;

    // 1. Initial permutation
    // 2. k = KS(n, KEY)
    // 3. z = f(r, k)
    // 4. L_(n+1) = r
    //    R_(n+1) = l ^ z
    // 5. Inverse initial permutation

    // Round
    // DES takes 16 clocks.
    // round runs from 0 to 15.

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            running <= 1'b0;
        end else if (start_i) begin
            running <= 1'b1;
        end else if (round == 4'd15) begin
            running <= 1'b0;
        end
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            round <= 4'd0;
        end else if (running) begin
            round <= round + 1'd1;
        end
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            finish <= 1'b0;
        end else if (round == 4'd15) begin
            finish <= 1'b1;
        end else if (finish) begin
            finish <= 1'b0;
        end
    end

    // 1. Initial permutation

    localparam int IP[1:64] = '{58, 50, 42, 34, 26, 18, 10,  2,
                                60, 52, 44, 36, 28, 20, 12,  4,
                                62, 54, 46, 38, 30, 22, 14,  6,
                                64, 56, 48, 40, 32, 24, 16,  8,
                                57, 49, 41, 33, 25, 17,  9,  1,
                                59, 51, 43, 35, 27, 19, 11,  3,
                                61, 53, 45, 37, 29, 21, 13,  5,
                                63, 55, 47, 39, 31, 23, 15,  7};

    generate
        for (i1=1; i1<=64; i1++) begin
            assign perm1[i1] = in_i[IP[i1]];
        end
    endgenerate

    // 2. Function KS: Key schedule

    assign round_key = (inv_i) ? ~round : round;

    func_ks inst_func_ks (
        .n_i   (round_key),
        .key_i (key_i),
        .k_o   (k)
    );

    // 3. Function f

    func_f inst_func_f (
        .r_i (r),
        .k_i (k),
        .z_o (z)
    );

    // 4. L, R of next round

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            l <= 32'h0;
            r <= 32'h0;
        end else if (start_i) begin
            {l, r} <= perm1;
        end else if (running) begin
            l <= r;
            r <= l ^ z;
        end
    end

    // 5. Inverse initial permutation

    localparam int iP[1:64] = '{40,  8, 48, 16, 56, 24, 64, 32,
                                39,  7, 47, 15, 55, 23, 63, 31,
                                38,  6, 46, 14, 54, 22, 62, 30,
                                37,  5, 45, 13, 53, 21, 61, 29,
                                36,  4, 44, 12, 52, 20, 60, 28,
                                35,  3, 43, 11, 51, 19, 59, 27,
                                34,  2, 42, 10, 50, 18, 58, 26,
                                33,  1, 41,  9, 49, 17, 57, 25};

    assign perm2 = {r, l};

    generate
        for (i2=1; i2<=64; i2++) begin
            assign out_o[i2] = perm2[iP[i2]];
        end
    endgenerate

    assign finish_o = finish;

endmodule
