/****************
 description: 均值滤波算法
 author: Luo Xing
 date: 2022-09-12 17:54:37
 version: V1.0.0
*************************************************************************/

module  filter
(
    input   wire                sys_clk             ,
    input   wire                sys_rst_n           ,
    input   wire    [12:0]      data_bin            ,
    input   wire                fall_flag_r1        ,
    output  wire    [12:0]      data_ave             
);

reg     [12:0]      data_temp   [7:0]           ;
reg     [15:0]      data_sum                    ;

//data_temp:移位暂存8次测距的数值
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        data_temp[0]<=13'd0;
        data_temp[1]<=13'd0;
        data_temp[2]<=13'd0;
        data_temp[3]<=13'd0;
        data_temp[4]<=13'd0;
        data_temp[5]<=13'd0;
        data_temp[6]<=13'd0;
        data_temp[7]<=13'd0;
    end
    else if(fall_flag_r1) begin
        data_temp[0]<=data_bin  ;
        data_temp[1]<=data_temp[0] ;
        data_temp[2]<=data_temp[1] ;
        data_temp[3]<=data_temp[2] ;
        data_temp[4]<=data_temp[3] ;
        data_temp[5]<=data_temp[4] ;
        data_temp[6]<=data_temp[5] ;
        data_temp[7]<=data_temp[6] ;
    end
end

//data_sum:暂存的8个数据之和
always @ (posedge sys_clk or negedge sys_rst_n ) begin
    if(!sys_rst_n)
        data_sum<=1'd0;
    else
        data_sum<=data_temp[0]+data_temp[1]+data_temp[2]+data_temp[3]+data_temp[4]+data_temp[5]+data_temp[6]+data_temp[7];
end

//data_ave
assign  data_ave    =   data_sum[15:3]      ;//截取高13位，相当于右移3位，即除以8的效果。

endmodule