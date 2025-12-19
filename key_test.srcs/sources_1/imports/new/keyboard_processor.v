`timescale 1ns / 1ps

module keyboard_processor(
    inout PS2_DATA,
    inout PS2_CLK,
    input rst,
    input clk,
    output ready,
    output reg [4:0] key_num
    );

    wire been_ready;
    wire [511:0] key_down;
    wire [8:0] last_change;

    KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);

    //reg holding;
    //reg [8:0] held_code;

    assign ready=been_ready && key_down[last_change] && key_num!=4'h1F;

    initial begin
        //holding<=1'd0;
        //held_code<=9'd0;
        key_num<=5'd0;
    end

    /*always @ (posedge clk or posedge rst) begin
        if(rst) begin
            holding<=1'd0;
            held_code<=9'd0;
        end
        else begin
            if(ready) begin
                if(key_down[last_change]) begin
                    if(key_num!=5'h1F && !holding) begin
                        holding<=1'd1;
                        held_code<=last_change;;
                    end
                    else if(holding && (key_num==last_change)) begin
                        holding<=1'd0;
                        held_code<=9'd0;
                    end
                end
            end
        end
    end*/

    parameter [8:0] KEY_CODES [0:24]={
        9'h45,9'h70,
        9'h16, 9'h69,
        9'h1E, 9'h72,
        9'h26, 9'h7A,
        9'h25, 9'h6B,
        9'h2E, 9'h73,
        9'h36, 9'h74,
        9'h3D, 9'h6C,
        9'h3E, 9'h75,
        9'h46, 9'h7D,
        9'h5A, 9'h1D,
        9'h1B, 9'h1C,
        9'h23
    };

    always @ (*) begin
        case(last_change)
            KEY_CODES[00],KEY_CODES[01]: key_num=4'd0;
            KEY_CODES[02],KEY_CODES[03]: key_num=4'd1;
            KEY_CODES[04],KEY_CODES[05]: key_num=4'd2;
            KEY_CODES[06],KEY_CODES[07]: key_num=4'd3;
            KEY_CODES[08],KEY_CODES[09]: key_num=4'd4;
            KEY_CODES[10],KEY_CODES[11]: key_num=4'd5;
            KEY_CODES[12],KEY_CODES[13]: key_num=4'd6;
            KEY_CODES[14],KEY_CODES[15]: key_num=4'd7;
            KEY_CODES[16],KEY_CODES[17]: key_num=4'd8;
            KEY_CODES[18],KEY_CODES[19]: key_num=4'd9;
            KEY_CODES[20]: key_num=4'd10;
            KEY_CODES[21]: key_num=4'd11;
            KEY_CODES[22]: key_num=4'd12;
            KEY_CODES[23]: key_num=4'd13;
            KEY_CODES[24]: key_num=4'd14;
            default: key_num = 5'h1F;
        endcase
    end

endmodule
