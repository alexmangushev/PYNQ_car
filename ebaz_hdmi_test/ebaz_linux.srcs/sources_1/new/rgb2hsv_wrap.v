module rgb2hsv_wrap(
    input                   clk,
    input                   arstn,
    input             [23:0]s_tdata,
    input                   s_tlast,
    output                  s_tready,
    input                   s_tuser,
    input                   s_tvalid,

    output            [23:0]m_tdata,
    output                  m_tlast,
    input                   m_tready,
    output                  m_tuser,
    output                  m_tvalid
);
    
    
rgb2hsv rgb2hsv_instance 
(
    .clk         (  clk     ),
    .arstn       (  arstn   ),    
    .s_tdata     (  s_tdata ),
    .s_tlast     (  s_tlast ),
    .s_tready    (  s_tready),
    .s_tuser     (  s_tuser ),
    .s_tvalid    (  s_tvalid),

    .m_tdata     (  m_tdata ),
    .m_tlast     (  m_tlast ),
    .m_tready    (  m_tready),
    .m_tuser     (  m_tuser ),
    .m_tvalid    (  m_tvalid)
);

endmodule
