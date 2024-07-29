/****************
 description:   数码管显示模块
 author: Luo Xing
 date: 2022-09-12 19:15:47
 version: V1.0.0
*************************************************************************/
//共阴极数码管，并且为0时该位数码管被选中

module  nixie_display
#(
    parameter   CNT_1MS_MAX     =   16'd50_000      
)
(
    input   wire                sys_clk             ,//Clock frequency is 50MHz.
    input   wire                sys_rst_n           ,
    input   wire    [15:0]      data_bcd            ,
    output  reg     [3:0]       nixie_cs            ,//数码管位选信号
    output  reg     [7:0]       nixie_seg            //数码管段选信号dp_g_to_a
);

//localparam define
localparam  _0 = 8'b0011_1111   ,
            _1 = 8'b0000_0110   ,
            _2 = 8'b0101_1011   ,
            _3 = 8'b0100_1111   ,
            _4 = 8'b0110_0110   ,
            _5 = 8'b0110_1101   ,
            _6 = 8'b0111_1101   ,
            _7 = 8'b0000_0111   ,
            _8 = 8'b0111_1111   ,
            _9 = 8'b0110_1111   ;

//parameter define
parameter   CNT_1S_MAX =   26'd50_000_000       ;

//wire or reg define
reg     [15:0]          cnt_1ms             ;
wire                    cnt_1ms_flag        ;
reg     [3:0]           disp_num            ;//动态扫描显示，对应的单个数码管显示的数字
/*reg     [25:0]          cnt_1s              ;
wire                    cnt_1s_flag         ;
reg     [15:0]          data_bcd_r          ;*/

/*
//cnt_1s:为了不让数据在数码管上一直抖动，则最快1s变化一次
assign cnt_1s_flag =cnt_1s==CNT_1S_MAX-1'B1;
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt_1s<=26'd0;
    else if(cnt_1s_flag)
        cnt_1s<=26'd0;
    else
        cnt_1s<=cnt_1s+1'b1;
end

//data_bcd_r
always @ (posedge sys_clk or negedge sys_rst_n ) begin
    if(!sys_rst_n)
        data_bcd_r<=16'd0;
    else if(cnt_1s_flag)
        data_bcd_r<=data_bcd;
    else
        data_bcd_r<=data_bcd_r;
end
*/

//cnt_1ms and cnt_1ms_flag
assign cnt_1ms_flag =  cnt_1ms==CNT_1MS_MAX-1'B1;
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt_1ms<=16'd0;
    else if(cnt_1ms_flag)
        cnt_1ms<=16'd0;
    else
        cnt_1ms<=cnt_1ms+1'b1;
end

//nixie_cs:数码管片选信号
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        nixie_cs<=4'b0000;//都不选中
    else if(cnt_1ms_flag) begin
        if(nixie_cs==4'b0000)
            nixie_cs<=4'b0001;
        else
            nixie_cs<={nixie_cs[2:0],nixie_cs[3]};
    end
    else
        nixie_cs<=nixie_cs;
end

//disp_num
always @ (nixie_cs,data_bcd) begin
    case(nixie_cs)
        4'b0001:disp_num<=data_bcd[3:0];
        4'b0010:disp_num<=data_bcd[7:4];
        4'b0100:disp_num<=data_bcd[11:8];
        4'b1000:disp_num<=data_bcd[15:12];
        default:disp_num<=4'd0;
    endcase
end

//nixie_seg:数码管段选信号
always @ (disp_num) begin
    case(disp_num)
        4'd0:nixie_seg<=_0  ;
        4'd1:nixie_seg<=_1  ;
        4'd2:nixie_seg<=_2  ;
        4'd3:nixie_seg<=_3  ;
        4'd4:nixie_seg<=_4  ;
        4'd5:nixie_seg<=_5  ;
        4'd6:nixie_seg<=_6  ;
        4'd7:nixie_seg<=_7  ;
        4'd8:nixie_seg<=_8  ;
        4'd9:nixie_seg<=_9  ;
        default:nixie_seg<=_0;
    endcase
end

endmodule