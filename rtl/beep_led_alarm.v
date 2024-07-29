/****************
 description:蜂鸣器和led灯警示模块
 author: Luo Xing
 date: 2022-09-12 18:53:59
 version: V1.0.0
*************************************************************************/

//对于蜂鸣器
//frequency is 500HZ, "di"
//frequency is 1KHZ, "da"

module  beep_led_alarm
(
    input   wire                sys_clk             ,
    input   wire                sys_rst_n           ,
    input   wire    [12:0]      data_ave            ,//经过均值滤波后的距离值
    output  reg                 beep_out            ,
    output  reg                 led_out              
);

parameter CNT_1KHZ_MAX  =   15'd25_000      ;
parameter CNT_500HZ_MAX =   16'd50_000      ;

reg     [14:0]          cnt_1khz            ;
wire                    cnt_1khz_flag       ;
reg     [15:0]          cnt_500hz           ;
wire                    cnt_500hz_flag      ;
reg                     beep_da             ;//1KHz的脉冲信号
reg                     beep_di             ;//500Hz的脉冲信号

//led_out and beep_out
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        led_out<=1'b0;
        beep_out<=1'b0;
    end
    else if(data_ave<=13'd200) begin//当距离值小于200mm，即小于20cm时灯亮，起警示作用
        led_out<=1'b1;
        if(data_ave<=13'd50)//当距离值小于50mm,即5cm时，蜂鸣器发出da的声音
            beep_out<=beep_da ;
        else if(data_ave<=13'd30)//当距离值小于30mm,即3cm时，蜂鸣器发出di的声音
            beep_out<=beep_di ;
    end
    else begin
        led_out<=1'b0;
        beep_out<=1'b0;
    end
end

//cnt_1khz
assign  cnt_1khz_flag =cnt_1khz==CNT_1KHZ_MAX-1'B1;
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt_1khz<=15'd0;
    else if(cnt_1khz_flag)
        cnt_1khz<=15'd0;
    else
        cnt_1khz<=cnt_1khz+1'b1;
end

//beep_da
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        beep_da<=1'b0;
    else if(cnt_1khz_flag)
        beep_da<=~beep_da;
    else
        beep_da<=beep_da;
end

//cnt_500hz
assign cnt_500hz_flag=cnt_500hz==CNT_500HZ_MAX-1'B1;
always @ (posedge sys_clk or negedge sys_rst_n ) begin
    if(!sys_rst_n)
        cnt_500hz<=16'd0;
    else if(cnt_500hz_flag)
        cnt_500hz<=16'd0;
    else
        cnt_500hz<=cnt_500hz+1'b1;
end

//beep_di
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        beep_di<=1'b0;
    else if(cnt_500hz_flag)
        beep_di<=~beep_di;
    else
        beep_di<=beep_di;
end

endmodule