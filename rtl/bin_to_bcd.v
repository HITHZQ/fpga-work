/****************
 description: 二进制码转化为8421BCD码
 author: Luo Xing
 date: 2022-09-12 14:03:58
 version: V1.0.0
*************************************************************************/

module  bin_to_bcd
(
    input   wire                sys_clk             ,//The onboard clock frequency is 50MHz.
    input   wire                sys_rst_n           ,
    input   wire    [12:0]      data_ave            ,
    output  reg     [15:0]      data_bcd             
);

parameter   SHIFT_CNT_MAX   =   5'd14       ;//输入的二进制数有多少位就进行多少次比较移位操作

reg                 shift_flag              ;
reg     [4:0]       shift_cnt               ;
reg     [28:0]      data_shift              ;
wire                complete_flag           ;

//shift_flag
always @ (posedge sys_clk or negedge sys_rst_n ) begin
    if(!sys_rst_n)
        shift_flag<=1'b0;
    else
        shift_flag<=~shift_flag;
end

//shift_cnt
wire                shift_cnt_flag          ;
assign  shift_cnt_flag  =   shift_cnt==SHIFT_CNT_MAX    ;

always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        shift_cnt<=5'd0;
    else if(shift_flag) begin
        if(shift_cnt_flag)
            shift_cnt<=5'd0;
        else
            shift_cnt<=shift_cnt+1'b1;
    end
    else
        shift_cnt<=shift_cnt        ;
end

//data_shift
always @ (posedge sys_clk or negedge sys_rst_n ) begin
    if(!sys_rst_n)
        data_shift<=29'd0;
    else if((!shift_cnt) && (shift_flag))
        data_shift<={16'b0,data_ave} ; 
    else if((shift_cnt>=1'b1)  && (shift_cnt<=5'd13)) begin
        if(!shift_flag) begin //shift_flag==0，比较
            data_shift[16:13]<=(data_shift[16:13] > 4'd4) ? (data_shift[16:13]+4'd3) : data_shift[16:13] ;
            data_shift[20:17]<=(data_shift[20:17] > 4'd4) ? (data_shift[20:17]+4'd3) : data_shift[20:17] ;
            data_shift[24:21]<=(data_shift[24:21] > 4'd4) ? (data_shift[24:21]+4'd3) : data_shift[24:21] ;
            data_shift[28:25]<=(data_shift[28:25] > 4'd4) ? (data_shift[28:25]+4'd3) : data_shift[28:25] ;
        end
        else begin//shift_flag==1，移位
            data_shift<=data_shift<<1'b1;
        end
    end
    else
        data_shift<=data_shift;
end

//complete_flag
assign  complete_flag   =   (shift_cnt_flag && shift_flag) ? 1'b1: 1'b0 ;

//data_bcd
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        data_bcd<=16'd0;
    else if(complete_flag)
        data_bcd<=data_shift[28:13] ;
    else
        data_bcd<=data_bcd;
end

endmodule
