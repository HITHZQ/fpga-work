/****************
 description: 超声波控制模块，并且计算回响信号的高脉宽
 author: Luo Xing
 date: 2022-09-12 15:09:09
 version: V1.0.0
*************************************************************************/

module  ultrasound_ctrl
#(
    parameter   CNT_10US_MAX    =   9'd500          ,
    parameter   CNT_100MS_MAX   =   23'd5000_000    
)
(
    input   wire                sys_clk             ,//50MHz
    input   wire                sys_rst_n           ,
    input   wire                echo                ,//10us
    output  reg                 trig                ,
    output  reg                 fall_flag_r1        ,//下降沿标志的打拍信号
    output  reg     [12:0]      data_bin             
);
/*
计算：s=340*t/2 m   =   340_000 mm * t /2
记脉冲个数：N
s=N*20*340_000/1000_000_000/2 mm = N*0.0034 mm = N*34/10000 ;
5000/0.0034=1470588     21bit      ; 34      6bit
*/
//reg and wire define
reg                 echo_r1             ;
reg                 echo_r2             ;
wire                raise_flag          ;//上升沿标志信号
wire                fall_flag           ;//下降沿标志信号
reg     [20:0]      cnt_pulse           ;//考虑的范围25~4000mm
reg     [20:0]      temp_pulse          ;

reg     [22:0]      cnt_100ms           ;
wire                cnt_100ms_flag      ;

//raise_flag
assign raise_flag = ((~echo_r2) && (echo_r1)) ? 1'b1 : 1'b0 ;
assign fall_flag  = ((echo_r2) && (~echo_r1)) ? 1'b1 : 1'b0 ;

//beat time
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        echo_r1<=1'b0;
        echo_r2<=1'b0;
    end
    else begin
        echo_r1<=echo;
        echo_r2<=echo_r1;
    end
end

//cnt_pulse
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt_pulse<=21'd0;
    else if(raise_flag)
        cnt_pulse<=21'd1;//直接从1开始计数，计算的时候就不需要再进行加1操作了
    else if(echo_r2)
        cnt_pulse<=cnt_pulse+1'b1;
    else
        cnt_pulse<=cnt_pulse; 
end

//temp_pulse
always @ (posedge sys_clk or negedge sys_rst_n ) begin
    if(!sys_rst_n)
        temp_pulse<=21'd0;
    else if(fall_flag)
        temp_pulse<=cnt_pulse;
    else
        temp_pulse<=temp_pulse;     
end

//计算距离，以mm为单位，s=N*34/10000 
//reg             fall_flag_r1    ;
always @ (posedge sys_clk or negedge sys_rst_n ) begin
    if(!sys_rst_n)
        fall_flag_r1<=1'b0;
    else
        fall_flag_r1<=fall_flag;
end

//data_bin
always @ (posedge sys_clk or negedge sys_rst_n ) begin
    if(!sys_rst_n)
        data_bin<=1'b0;
    else if(fall_flag_r1)
        data_bin<=temp_pulse*34/10000;
    else
        data_bin<=data_bin;
end

//trig:超声波触发信号，高电平至少为10us,同时考虑到信号不要重叠，所以当距离为5000mm时的来回时间做为超声波触发信号的周期T
//T=(5/340) * 1000ms = 14.7ms，来回就是29.4ms，所以就让触发脉冲的周期至少为30ms，高电平时间为10us
//为了防止发射信号对回响信号产生影响，这里直接设定为100ms的周期，高电平为10us


//cnt_100ms and cnt_100ms_flag
assign  cnt_100ms_flag  =   cnt_100ms==CNT_100MS_MAX - 1'B1 ;
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt_100ms<=23'd0;
    else if(cnt_100ms_flag)
        cnt_100ms<=23'd0;
    else
        cnt_100ms<=cnt_100ms+1'b1;
end

//trig
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        trig<=1'b0;
    else if(cnt_100ms<CNT_10US_MAX)
        trig<=1'b1;
    else
        trig<=1'b0;
end

endmodule