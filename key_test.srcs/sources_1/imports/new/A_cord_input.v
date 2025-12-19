`timescale 1ns / 1ps

module A_cord_input(
    input clk,
    input rst,
    input ready,              // 等同 key_valid
    input [4:0] key_num,      // 0~9, 10=ENTER
    input sw16,               // x sign
    input sw15,               // y sign
    output reg signed [7:0] x_val,
    output reg signed [7:0] y_val,
    output reg done,
    output [15:0] disp_nums
);

    // keyboard asssignment
    localparam key_0=0, key_1=1, key_2=2, key_3=3, key_4=4,
               key_5=5, key_6=6, key_7=7, key_8=8, key_9=9, key_ENTER=10;

    // digits: x_tens, x_ones, y_tens, y_ones
    reg [3:0] d0, d1, d2, d3;
    reg [1:0] input_idx;   // 0~3

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            d0 <= 0; d1 <= 0; d2 <= 0; d3 <= 0;
            input_idx <= 0;
            x_val <= 0;
            y_val <= 0;
            done <= 0;
            //disp_nums <= 16'h0000;
        end
        else begin
            done <= 0; // one-pulse

            if (ready) begin
                // ===== number input =====
                if (key_num >= key_0 && key_num <= key_9) begin
                    case (input_idx)
                        2'd0: d1 <= key_num; // x tens
                        2'd1: d0 <= key_num; // x ones
                        2'd2: d3 <= key_num; // y tens
                        2'd3: d2 <= key_num; // y ones
                    endcase
                    

                    if (input_idx < 2'd3)
                        input_idx <= input_idx + 1'b1;
                end

                // ===== ENTER: finish =====
                else if (key_num == key_ENTER) begin
                    x_val <= sw16 ? -((d1 * 10) + d0)
                                  :  ((d1 * 10) + d0);

                    y_val <= sw15 ? -((d3 * 10) + d2)
                                  :  ((d3 * 10) + d2);

                    done <= 1'b1;
                    input_idx <= 0; // ready for next input
                end
            end
        end
    end
    assign disp_nums = { d1, d0, d3, d2 };

endmodule
