`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2024 11:26:28 PM
// Design Name: 
// Module Name: pl_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pl_test
(
    input           CLK_50,
    input           KEY_1,
    output          LED_2
);
    
    reg [31:0]      cnt;
    wire            rst = KEY_1;
    wire            clk = CLK_50;
    
    assign LED_2 = cnt[22];

    always @(posedge clk or negedge rst)
    if (!rst)
        cnt <= 1'b0;
    else
        cnt <= cnt + 1'b1;
endmodule
