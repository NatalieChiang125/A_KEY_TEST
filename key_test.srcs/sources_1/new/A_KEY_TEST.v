`timescale 1ns / 1ps

module A_KEY_TEST(
        input clk,
        input rst,
        input [2:0] sw,
        input sw16,
        input sw15,
        inout PS2_DATA,
        inout PS2_CLK,
        output [6:0] display,
        output [3:0] digit
    );

    reg [1:0] mode;
    always @(posedge clk or posedge rst) begin
        if(rst) mode<=0;
        else begin
            case(sw)
                3'b001: mode<=0;
                3'b010: mode<=1;
                3'b100: mode<=2;
            endcase
        end
    end

    wire ready;
    wire [4:0] key_num;

    keyboard_processor key_proc (
        .PS2_DATA(PS2_DATA),
        .PS2_CLK (PS2_CLK),
        .rst      (rst),
        .clk      (clk),
        .ready    (ready),
        .key_num  (key_num)
    );

    wire signed [10:0] speed,turn;
    key_control(
        .clk(clk),
        .rst(rst),
        .ready(ready),
        .key_num(key_num),
        .speed(speed),
        .turn(turn)
    );

    wire [7:0] x_val,y_val;
    wire nav_done;
    wire [15:0] nav_disp_nums;
    A_cord_input nav(
        .clk(clk),
        .rst(rst),
        .ready(ready),
        .key_num(key_num),
        .sw16(sw16),
        .sw15(sw15),
        .x_val(x_val),
        .y_val(y_val),
        .done(nav_done),
        .disp_nums(nav_disp_nums)
    );

    reg [3:0] dig0,dig1,dig2,dig3;
    wire [15:0] nums;
    always @(*) begin
        case(mode)
            2'd0: begin
                dig0 = (speed<0)? -speed/100 : speed/100;
                dig1 = 4'd0;
                dig2 = (turn<0)? -turn/100 : turn/100;
                dig3 = 4'd0;
            end
            2'd2: begin
                //nums = nav_disp_nums;
            end
            default: begin
                dig0 = 4'd0;
                dig1 = 4'd0;
                dig2 = 4'd0;
                dig3 = 4'd0;
            end
        endcase
    end

    assign nums=(mode==2)? nav_disp_nums : {dig0,dig1,dig2,dig3};

    SevenSegment(
        .display(display),
        .digit(digit),
        .nums(nums),
        .rst(rst),
        .clk(clk)
    );



endmodule
