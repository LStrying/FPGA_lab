//course:IS209-1:FPGA
//date:2022/03/27
//version:1
//module:top_module

//`include "divide.v"
//`include "counter.v"
module top_module(
    input clk,
    input rst_n,
    input control,
    output [7:0] led_out
);
    wire clk_1Hz,clk_10Hz;

    divide fenpiqi(
        .clk(clk),
        .rst_n(rst_n),
        .clk_1Hz(clk_1Hz),
        .clk_10Hz(clk_10Hz)
    );
    counter cnt(
        .clk(clk),
        .clk_1Hz(clk_1Hz),
        .clk_10Hz(clk_10Hz),
        .key_sw0(control),
        .key_sw3_n(rst_n),
        .led(led_out)
    );
    
endmodule

//course:IS209-1:FPGA
//date:2022/03/27
//version:1
//module:divide
//function:create clk_1Hz and clk_10Hz

module divide(
    input clk,//50MHz
    input rst_n,
    output clk_1Hz,//1Hz
    output clk_10Hz//10Hz
);

    parameter MAX = 25'd24_999_999;
    parameter MAX_10Hz = 22'd2_499_999;
    reg [25:0] cnt;
    reg [22:0] cnt_10Hz;
    reg clk_1Hz_reg;
    reg clk_10Hz_reg;

    //counter 1s;
    always@(posedge clk,negedge rst_n)begin
        if(!rst_n)
            cnt <= 25'b0;
        else if(cnt == MAX)
                cnt <= 25'b0;
        else 
            cnt <= cnt + 25'd1;
    end
    //create clk_1Hz
    always@(posedge clk,negedge rst_n)begin
        if(!rst_n)
          clk_1Hz_reg <= 1'd0;
        else if(cnt == MAX)
          clk_1Hz_reg <= ~clk_1Hz_reg;
    end

    //counter 0.1s
    always @(posedge clk,negedge rst_n) begin
        if(!rst_n)
            cnt_10Hz <= 22'b0;
        else if(cnt_10Hz == MAX_10Hz)
                cnt_10Hz <= 22'b0;
        else 
            cnt_10Hz <= cnt_10Hz + 22'd1;
    end
    //create clk_10Hz
    always @(posedge clk,negedge rst_n) begin
        if(!rst_n)
          clk_10Hz_reg <= 1'd0;
        else if(cnt_10Hz == MAX_10Hz)
          clk_10Hz_reg <= ~clk_10Hz_reg;
    end

    assign clk_1Hz = clk_1Hz_reg;
    assign clk_10Hz = clk_10Hz_reg;  

endmodule


//course:IS209-1:FPGA
//date:2022/03/27
//version:1
//module:counter
module counter(
    input clk,
    input clk_1Hz,
    input clk_10Hz,
    input key_sw0,
    input key_sw3_n,
    output [7:0] led
);
    parameter MAX_model_0 = 8'd127;
    parameter MAX_model_1 = 4'd9;

    reg [7:0] led_reg;
    reg [3:0] high,low;
    reg change_flag;

    //model_0: 0->127 1Hz
    always @(posedge clk_1Hz,negedge key_sw3_n) begin
        if(~key_sw3_n)
            led_reg <= 8'd0;
        else if((change_flag==1'b0) && (led_reg==MAX_model_0))
            led_reg <= 8'd0;
        else if(change_flag==1'b0)
            led_reg <= led_reg + 8'd1;
    end

    //module_1_high:0->9 1Hz
    always @(posedge clk_1Hz,negedge key_sw3_n) begin
        if(~key_sw3_n)
            high <= 4'd0;
        else if((change_flag==1'b1) && (high==MAX_model_1))//led_high
            high <= 4'd0;
        else if(change_flag==1'b1)
            high <= high + 4'd1;
    end

    //module_1_low:0->9 10Hz
    always @(posedge clk_10Hz,negedge key_sw3_n) begin
        if(~key_sw3_n)
            low <= 4'd0;
        else if((change_flag==1'b1) && (low==MAX_model_1))//led_low
            low <= 4'd0;
        else if(change_flag==1'b1)
            low <= low + 4'd1;
    end
  
    //control the model
    always @(posedge clk ) begin
        if((~key_sw3_n) && (key_sw0==1'b0))
            change_flag <= 1'b0;
        else if((~key_sw3_n) && (key_sw0==1'b1))
            change_flag <= 1'b1;
    end

    assign led = (change_flag==1'b0) ? led_reg : {high,low};

endmodule
