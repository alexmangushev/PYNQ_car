`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 07:00:42 PM
// Design Name: 
// Module Name: hsv_mask
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


module hsv_mask
(
    input                   clk,
    input                   arstn,
    input             [23:0]s_tdata,
    input                   s_tlast,
    output                  s_tready,
    input                   s_tuser,
    input                   s_tvalid,

    output  reg       [7:0] m_tdata,
    output                  m_tlast,
    input                   m_tready,
    output                  m_tuser,
    output                  m_tvalid
);

parameter H_LOW = 8'd50;
parameter H_HIGH = 8'd100;

parameter S_LOW = 8'd50;
parameter S_HIGH = 8'd255;

parameter V_LOW = 8'd50;
parameter V_HIGH = 8'd255;

wire [7:0] V = s_tdata[23:16];
wire [7:0] S = s_tdata[15:8];
wire [7:0] H = s_tdata[7:0];

always @*
    if (H >= H_LOW && H <= H_HIGH &&
        S >= S_LOW && S <= S_HIGH &&
        V >= V_LOW && V <= V_HIGH)
        m_tdata = 8'hFF;
    else
        m_tdata = 8'h0;

assign m_tlast = s_tlast;
assign m_tuser = s_tuser;
assign m_tvalid = s_tvalid;
assign s_tready = m_tready;

endmodule
