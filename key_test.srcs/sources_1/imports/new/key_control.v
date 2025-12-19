`timescale 1ns / 1ps

module key_control(
    input clk,
    input rst,
    input ready,
    input [4:0] key_num,
    output reg signed [10:0] speed,
    output reg signed [10:0] turn
    );


    
    localparam UP_KEY    = 4'd11;
    localparam DOWN_KEY  = 4'd12;
    localparam LEFT_KEY  = 4'd13;
    localparam RIGHT_KEY = 4'd14;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            speed <= 0;
            turn  <= 0;
        end
        else if(ready) begin
            case(key_num)
                UP_KEY:    begin
                    speed <= speed + 100;
                    if(speed > 900) speed <= 900;
                end
                DOWN_KEY:  begin
                    speed <= speed - 100;
                    if(speed < -900) speed <= -900;
                end
                RIGHT_KEY: begin
                    turn  <= turn + 50;
                    if(turn > 200) turn <= 200;
                end
                LEFT_KEY:  begin
                    turn  <= turn - 50;
                    if(turn < -200) turn <= -200;
                end
                default: begin
                    speed <= speed;
                    turn  <= turn;
                end
            endcase
        end
    end

endmodule
