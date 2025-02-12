// -----------------------------------------------------------------------------
// File Name: func_ks.sv
// Description:
//     This module implements the function KS as defined in Section 2.1 of NIST
//     SP 800-67. The detailed steps of this function are described in Appendix
//     A, Figure 3 of the document.
//
// Author: shsjung (github.com/shsjung)
// Date Created: 02-10-2025
// -----------------------------------------------------------------------------

module func_ks (
    input  [3:0]  n_i,
    input  [1:64] key_i,
    output [1:48] k_o
);

    genvar i1, i2;

    // 1. {C0, D0} = PC1(Key)
    // 2. Cn = C0 << a(n)
    //    Dn = D0 << a(n)
    //    where a(n) is sum of the schuedle of left shifts
    // 3. Kn = PC2({C0, D0})

    // 1. Permuted choice 1

    localparam int PC1[1:56] = '{57, 49, 41, 33, 25, 17,  9,
                                  1, 58, 50, 42, 34, 26, 18,
                                 10,  2, 59, 51, 43, 35, 27,
                                 19, 11,  3, 60, 52, 44, 36,
                                 63, 55, 47, 39, 31, 23, 15,
                                  7, 62, 54, 46, 38, 30, 22,
                                 14,  6, 61, 53, 45, 37, 29,
                                 21, 13,  5, 28, 20, 12,  4};

    logic [1:56] pc1;
    generate
        for (i1=1; i1<=56; i1++) begin
            assign pc1[i1] = key_i[PC1[i1]];
        end
    endgenerate

    logic [27:0] c0, d0;
    assign {c0, d0} = pc1;

    // 2. Left shift to C0 and D0

    logic [27:0] c, d;
    always_comb begin
        case (n_i)
            4'h0: begin c = {c0[26: 0], c0[27:27]}; d = {d0[26: 0], d0[27:27]}; end
            4'h1: begin c = {c0[25: 0], c0[27:26]}; d = {d0[25: 0], d0[27:26]}; end
            4'h2: begin c = {c0[23: 0], c0[27:24]}; d = {d0[23: 0], d0[27:24]}; end
            4'h3: begin c = {c0[21: 0], c0[27:22]}; d = {d0[21: 0], d0[27:22]}; end
            4'h4: begin c = {c0[19: 0], c0[27:20]}; d = {d0[19: 0], d0[27:20]}; end
            4'h5: begin c = {c0[17: 0], c0[27:18]}; d = {d0[17: 0], d0[27:18]}; end
            4'h6: begin c = {c0[15: 0], c0[27:16]}; d = {d0[15: 0], d0[27:16]}; end
            4'h7: begin c = {c0[13: 0], c0[27:14]}; d = {d0[13: 0], d0[27:14]}; end
            4'h8: begin c = {c0[12: 0], c0[27:13]}; d = {d0[12: 0], d0[27:13]}; end
            4'h9: begin c = {c0[10: 0], c0[27:11]}; d = {d0[10: 0], d0[27:11]}; end
            4'ha: begin c = {c0[ 8: 0], c0[27: 9]}; d = {d0[ 8: 0], d0[27: 9]}; end
            4'hb: begin c = {c0[ 6: 0], c0[27: 7]}; d = {d0[ 6: 0], d0[27: 7]}; end
            4'hc: begin c = {c0[ 4: 0], c0[27: 5]}; d = {d0[ 4: 0], d0[27: 5]}; end
            4'hd: begin c = {c0[ 2: 0], c0[27: 3]}; d = {d0[ 2: 0], d0[27: 3]}; end
            4'he: begin c = {c0[ 0: 0], c0[27: 1]}; d = {d0[ 0: 0], d0[27: 1]}; end
            4'hf: begin c = c0;                     d = d0;                     end
        endcase
    end

    // 3. Permuted choice 2

    localparam int PC2[1:48] = '{14, 17, 11, 24,  1,  5,
                                  3, 28, 15,  6, 21, 10,
                                 23, 19, 12,  4, 26,  8,
                                 16,  7, 27, 20, 13,  2,
                                 41, 52, 31, 37, 47, 55,
                                 30, 40, 51, 45, 33, 48,
                                 44, 49, 39, 56, 34, 53,
                                 46, 42, 50, 36, 29, 32};

    logic [1:56] cd;
    assign cd = {c, d};

    generate
        for (i2=1; i2<=48; i2++) begin
            assign k_o[i2] = cd[PC2[i2]];
        end
    endgenerate


endmodule
