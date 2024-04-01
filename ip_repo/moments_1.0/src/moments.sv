module moments
(
    input                   clk,
    input                   arstn,

    input           [7:0]   s_tdata,
    input                   s_tlast,
    output                  s_tready,
    input                   s_tuser,
    input                   s_tvalid,

    output logic    [31:0]  m00,    // count of all non zero pix
    output logic    [31:0]  m10,    // sum of x coordinat for all non zero pix
    output logic    [31:0]  m01     // sum of y coordinat for all non zero pix
);

logic    [31:0]  m00_tmp;
logic    [31:0]  m10_tmp;
logic    [31:0]  m01_tmp;

logic [11:0] x_cnt;
logic [11:0] y_cnt;

assign s_tready = '1;

// x coordinate of pixel
always_ff @(posedge clk or negedge arstn)
    if (!arstn)
        x_cnt <= '0;
    else if ((s_tuser | s_tlast) & s_tvalid)
        x_cnt <= '0;
    else if (s_tvalid)
        x_cnt <= x_cnt + 1'b1;

// y coordinate of pixel
always_ff @(posedge clk or negedge arstn)
    if (!arstn)
        y_cnt <= '0;
    else if (s_tuser & s_tvalid)
        y_cnt <= '0;
    else if (s_tvalid)
        y_cnt <= y_cnt + 1'b1;

// moments
always_ff @(posedge clk or negedge arstn)
    if (!arstn) begin
        m00_tmp <= '0;
        m10_tmp <= '0;
        m01_tmp <= '0;
    end
    else if (s_tuser & s_tvalid) begin
        m00_tmp <= '0;
        m10_tmp <= '0;
        m01_tmp <= '0;
    end
    else if (|(s_tdata) & s_tvalid) begin
        m00_tmp <= m00_tmp + 1'b1;
        m10_tmp <= m10_tmp + x_cnt;
        m01_tmp <= m01_tmp + y_cnt;
    end
    
// moments out
// update after frame finish
always_ff @(posedge clk or negedge arstn)
    if (!arstn) begin
        m00 <= '0;
        m10 <= '0;
        m01 <= '0;
    end
    else if (s_tuser & s_tvalid) begin
        m00 <= m00_tmp;
        m10 <= m10_tmp;
        m01 <= m01_tmp;
    end
    
endmodule