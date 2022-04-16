`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:10:21 03/29/2022 
// Module Name:    water_led 
// Project Name:   water_led
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module water_led(
    input clk,
    input rst_n,
    output [7:0] led
    );
  parameter MAX = 26'd49_999_999;
    reg [25:0] cnt;
    reg CLK_1Hz_flag;
    reg [7:0] led_reg;
    //counter 1s;
    always@(posedge clk,negedge rst_n)begin
        if(!rst_n)
            cnt <= 26'b0;
        else if(cnt == MAX)
                cnt <= 26'b0;
        else 
            cnt <= cnt + 26'd1;
    end
    //
    always@(posedge clk,negedge rst_n)begin
        if(!rst_n)
          CLK_1Hz_flag <= 1'd0;
        else if(cnt == MAX)
          CLK_1Hz_flag <= 1'd1;
        else
          CLK_1Hz_flag <= 1'd0; 
    end
    
    always@(posedge clk,negedge rst_n)begin
        if(!rst_n)
            led_reg <= 8'b00000000;
        else if(CLK_1Hz_flag==1'b1&&led_reg==8'b11111111)
            led_reg <= 8'b00000000;
        else if(CLK_1Hz_flag==1'b1)
            led_reg <= {led[6:0],1'b1};
    end

    assign led = led_reg;   

endmodule
