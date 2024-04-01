module rgb2hsv
(
    input                   clk,
    input                   arstn,
    input             [23:0]s_tdata,
    //input           [7:0]   R,
    //input           [7:0]   G,
    //input           [7:0]   B,
    input                   s_tlast,
    output  logic           s_tready,
    input                   s_tuser,
    input                   s_tvalid,


    //output  logic   [7:0]   H,
    //output  logic   [7:0]   S,
    //output  logic   [7:0]   V,
    output            [23:0]m_tdata,
    output  logic           m_tlast,
    input                   m_tready,
    output  logic           m_tuser,
    output  logic           m_tvalid

);
wire [7:0] R = s_tdata[23:16];
wire [7:0] G = s_tdata[15:8];
wire [7:0] B = s_tdata[7:0];

logic   [7:0]   H;
logic   [7:0]   S;
logic   [7:0]   V;

assign m_tdata = {V, S, H};

localparam XLEN = 17;
localparam STAGE_LIST = 32'b0000_0000_0000_0001_0101_0101_0101_0101; //32'h0101_0101;

assign s_tready = ~(m_tvalid & ~m_tready);

parameter PIPELINE_DIV_CNT = 9;
parameter PIPELINE_STAGE_CNT = PIPELINE_DIV_CNT + 1;

// Pipeline for AXI-S video interface
logic [PIPELINE_STAGE_CNT : 0] m_tlast_pipe;
logic [PIPELINE_STAGE_CNT : 0] m_tuser_pipe;

logic [7:0] R_pipe[0:PIPELINE_STAGE_CNT - 1];
logic [7:0] G_pipe[0:PIPELINE_STAGE_CNT - 1];
logic [7:0] B_pipe[0:PIPELINE_STAGE_CNT - 1];
logic [7:0] cmax_pipe[0:PIPELINE_STAGE_CNT - 1];

logic [PIPELINE_STAGE_CNT - 1 : 0] eq_pipe;

logic [16:0] denum_pipe[0:PIPELINE_DIV_CNT];

logic s_tvalid_reg;

logic div_vld;


// -----------------First stage----------------
wire eq = (R == G) && (G == B); //

// cmax
wire [7:0] cmax1 = (G > B) ? G : B;
wire [7:0] cmax2 = (B > R) ? B : R;
wire [7:0] cmax = (cmax1 > cmax2) ? cmax1 : cmax2; //

// cmin
wire [7:0] cmin1 = (G > B) ? B : G;
wire [7:0] cmin2 = (B > R) ? R : B;
wire [7:0] cmin = (cmin2 > cmin1) ? cmin1 : cmin2; 

logic [PIPELINE_STAGE_CNT - 1 : 0] G_B_sign_pipe; //
logic [PIPELINE_STAGE_CNT - 1 : 0] B_R_sign_pipe; //
logic [PIPELINE_STAGE_CNT - 1 : 0] R_G_sign_pipe; //

logic [7:0] G_B;
logic [7:0] B_R;
logic [7:0] R_G; 

// denum for H
wire [16:0] denum = cmax - cmin; //

// -----------------Second stage----------------

wire [16:0] num1 = 8'd60 * G_B; //
wire [16:0] num2 = 8'd60 * B_R; //
wire [16:0] num3 = 8'd60 * R_G; //

wire [16:0] nums = 9'd255 * denum_pipe[0]; //

// -----------------Fifth stage----------------

logic [7:0] rem_num1;
logic [7:0] rem_num2;
logic [7:0] rem_num3;
logic [7:0] rem_nums;

logic [7:0] div_num1;
logic [7:0] div_num2;
logic [7:0] div_num3;
logic [7:0] div_nums;

wire [9:0] h111 = (G_B_sign_pipe[PIPELINE_DIV_CNT]) ? ~(div_num1) + 1'd1 : div_num1;
wire [9:0] h222 = (B_R_sign_pipe[PIPELINE_DIV_CNT]) ? ~(div_num2) + 8'd121 : div_num2 + 8'd120;
wire [9:0] h333 = (R_G_sign_pipe[PIPELINE_DIV_CNT]) ? ~(div_num3) + 8'd241 : div_num3 + 8'd240;

wire [9:0] h11 = (h111[9]) ? h111 + 9'd360 : h111;
wire [9:0] h22 = (h222[9]) ? h222 + 9'd360 : h222;
wire [9:0] h33 = (h333[9]) ? h333 + 9'd360 : h333;

wire [8:0] h1 = (h11 == 9'd359 && rem_num1 == 0) ? '0 : h11;
wire [8:0] h2 = (h22 == 9'd359 && rem_num2 == 0) ? '0 : h22;
wire [8:0] h3 = (h33 == 9'd359 && rem_num3 == 0) ? '0 : h33;


//-------------------result----------------------
always_ff @(posedge clk) begin
    V <= cmax_pipe[PIPELINE_STAGE_CNT - 1];
    S <= (|cmax_pipe[PIPELINE_STAGE_CNT - 1]) ? div_nums : '0;
    if (eq_pipe[PIPELINE_STAGE_CNT - 1])
        H <= '0;
    else if (cmax_pipe[PIPELINE_STAGE_CNT - 1] == R_pipe[PIPELINE_STAGE_CNT - 1])
        H <= h1[1 +: 8];
    else if (cmax_pipe[PIPELINE_STAGE_CNT - 1] == G_pipe[PIPELINE_STAGE_CNT - 1])
        H <= h2[1 +: 8];
    else 
        H <= h3[1 +: 8];
end


// Pipeline for AXI-S video interface
always_ff @(posedge clk or negedge arstn)
    if (!arstn) begin
        m_tlast_pipe    <= '0;
        m_tuser_pipe    <= '0;
        s_tvalid_reg    <= '0;
        m_tvalid        <= '0;
    end
    else begin
        m_tlast_pipe    <= { m_tlast_pipe[PIPELINE_STAGE_CNT - 1 : 0], s_tlast};
        m_tuser_pipe    <= {m_tuser_pipe[PIPELINE_STAGE_CNT - 1 : 0], s_tuser};
        s_tvalid_reg    <= s_tvalid;
        m_tvalid        <= div_vld;
    end



always_ff @(posedge clk) begin
    eq_pipe     <= { eq_pipe[PIPELINE_STAGE_CNT - 2 : 0], eq};
    //denum_pipe  <= denum;

    G_B_sign_pipe    <= {G_B_sign_pipe[PIPELINE_STAGE_CNT - 1 : 0], ~(G >= B)}; 
    B_R_sign_pipe    <= {B_R_sign_pipe[PIPELINE_STAGE_CNT - 1 : 0], ~(B >= R)}; 
    R_G_sign_pipe    <= {R_G_sign_pipe[PIPELINE_STAGE_CNT - 1 : 0], ~(R >= G)}; 

    G_B         <= (G > B) ? G - B : B - G; 
    B_R         <= (B > R) ? B - R : R - B; 
    R_G         <= (R > G) ? R - G : G - R; 

    for (int i = 0; i < PIPELINE_STAGE_CNT; i++)
        if (i == 0) begin
            R_pipe[i] <= R;
            G_pipe[i] <= G;
            B_pipe[i] <= B;
            cmax_pipe[i] <= cmax;
        end
        else begin
            R_pipe[i] <= R_pipe[i-1];
            G_pipe[i] <= G_pipe[i-1];
            B_pipe[i] <= B_pipe[i-1];
            cmax_pipe[i] <= cmax_pipe[i-1];
        end

    for (int i = 0; i <= PIPELINE_DIV_CNT; i++)
        if (i == 0)
            denum_pipe[i] <= denum;
        else
            denum_pipe[i] <= denum_pipe[i-1];
end

assign m_tlast     = m_tlast_pipe[PIPELINE_STAGE_CNT];
assign m_tuser     = m_tuser_pipe[PIPELINE_STAGE_CNT];


divfunc 
#(
    .XLEN         ( XLEN            ),
    .STAGE_LIST   ( STAGE_LIST      )

) div_nums_f (
    .clk          ( clk             ),
    .rst          ( ~arstn          ),
    
    .a            ( nums            ),
    .b            ( {9'd0, cmax_pipe[0]}  ),
    .vld          ( s_tvalid_reg    ),
    
    .quo          ( div_nums        ),
    .rem          ( rem_nums        ),
    .ack          ( div_vld         )		
);

divfunc 
#(
    .XLEN         ( XLEN            ),
    .STAGE_LIST   ( STAGE_LIST      )

) div_num1_f (
    .clk          ( clk             ),
    .rst          ( ~arstn          ),
    
    .a            ( num1            ),
    .b            ( denum_pipe[0]   ),
    .vld          ( s_tvalid_reg    ),
    
    .quo          ( div_num1        ),
    .rem          ( rem_num1        ),
    .ack          ( )		
);

divfunc 
#(
    .XLEN         ( XLEN            ),
    .STAGE_LIST   ( STAGE_LIST      )

) div_num2_f (
    .clk          ( clk             ),
    .rst          ( ~arstn          ),
    
    .a            ( num2            ),
    .b            ( denum_pipe[0]   ),
    .vld          ( s_tvalid_reg    ),
    
    .quo          ( div_num2        ),
    .rem          ( rem_num2        ),
    .ack          ( )		
);

divfunc 
#(
    .XLEN         ( XLEN            ),
    .STAGE_LIST   ( STAGE_LIST      )

) div_num3_f (
    .clk          ( clk             ),
    .rst          ( ~arstn          ),
    
    .a            ( num3            ),
    .b            ( denum_pipe[0]   ),
    .vld          ( s_tvalid_reg    ),
    
    .quo          ( div_num3        ),
    .rem          ( rem_num3        ),
    .ack          ( )		
);

endmodule