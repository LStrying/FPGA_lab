//course:IS209-1:FPGA
//date:2022/03/28
//version:1
//module:detect_Moore

module detect_moore(
    input clk,
    input rst_n,
    input data,
    output reg led0
);
    parameter idle = 3'd0;
    parameter s0 = 3'd1;
    parameter s1 = 3'd2;
    parameter s2 = 3'd3;
    parameter s3 = 3'd4;
    parameter s4 = 3'd5;

    reg [2:0] state,next_state;

    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)
            state <= idle;
        else state <= next_state;
    end

    always@(*)begin
        case(state)
            idle: next_state = (data) ? s0 : idle;
            s0: next_state = (data) ? s0 : s1;
            s1: next_state = (data) ? s2 : idle;
            s2: next_state = (data) ? s3 : s1;
            s3: next_state = (data) ? s0 : s4;
            s4: next_state = (data) ? s0 : idle;
            default:next_state =  idle;
        endcase
    end

     /*always@(posedge clk,negedge rst_n)begin
        if(~rst_n)
            led0 <= 1'b0;
        else if(state == s4)
            led0 <= 1'b1;
        else led0 <= 1'b0;
    end*/
    always@(*)begin
        if(~rst_n)
            led0 = 1'b0;
        else if(state == s4)
            led0 = 1'b1;
        else led0 =  1'b0;
    end
endmodule




//course:IS209-1:FPGA
//date:2022/03/28
//version:1
//module:detect_Mealy

module detect_mealy(
    input clk,
    input rst_n,
    input data,
    output  reg led0
);
    parameter idle = 3'd0;
    parameter s0 = 3'd1;
    parameter s1 = 3'd2;
    parameter s2 = 3'd3;
    parameter s3 = 3'd4;

    reg [2:0] state,next_state;
    reg led0_reg;
    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)
            state <= idle;
        else state <= next_state;
    end

    always@(*)begin
        case(state)
            idle: next_state <= (data) ? s0 : idle;
            s0: next_state <= (data) ? s0 : s1;
            s1: next_state <= (data) ? s2 : idle;
            s2: next_state <= (data) ? s3 : s1;
            s3: next_state <= (data) ? s0 : idle;
            default: next_state <=  idle;
        endcase
    end

    always@(*)begin
        if(~rst_n)
            led0_reg = 1'b0;
        else if(state == s3 && data == 1'b0)
            led0_reg = 1'b1;
        else led0_reg = 1'b0;
    end

    always@(posedge clk,negedge rst_n)begin
        if(~rst_n)
            led0 <= 1'b0;
        else led0 <= led0_reg;
    end
 
endmodule
