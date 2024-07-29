/****************
 description: 超声波测距的顶层模块
 author: Luo Xing
 date: 2022-09-12 19:16:27
 version: V1.0.0
*************************************************************************/

module  distance_meter
(
    input   wire                sys_clk             ,
    input   wire                sys_rst_n           ,
    input   wire                echo                ,
    output  wire                trig                ,
    output  wire    [3:0]       nixie_cs            ,//片选信号，高有效
    output  wire    [7:0]       nixie_seg           ,//共阴极数码管，高有效
    output  wire                led_out             ,
    output  wire                beep_out             
);

//wire and reg define
wire                fall_flag_r1            ;
wire    [12:0]      data_bin                ;//得到的超声波测得的距离值，以mm为单位
wire    [12:0]      data_ave                ;//均值滤波后的数据
wire    [15:0]      data_bcd                ;//显示的四位BCD码数据

//超声波控制模块
ultrasound_ctrl
#(
    . CNT_10US_MAX    (   9'd500        )  ,
    . CNT_100MS_MAX   (   23'd5000_000  )  
)
ultrasound_ctrl_inst_1
(
    . sys_clk         ( sys_clk      )    ,//50MHz
    . sys_rst_n       ( sys_rst_n    )    ,
    . echo            ( echo         )    ,//10us
    . trig            ( trig         )    ,
    . fall_flag_r1    ( fall_flag_r1 )    ,//下降沿标志的打拍信号
    . data_bin        ( data_bin     )     
);

//加入均值滤波算法
filter filter_inst_1
(
    . sys_clk        ( sys_clk      )     ,
    . sys_rst_n      ( sys_rst_n    )     ,
    . data_bin       ( data_bin     )     ,
    . fall_flag_r1   ( fall_flag_r1 )     ,
    . data_ave       ( data_ave     )      
);


//蜂鸣器和LED灯警示模块
beep_led_alarm beep_led_alarm_inst_1
(
    . sys_clk       ( sys_clk   )      ,
    . sys_rst_n     ( sys_rst_n )      ,
    . data_ave      ( data_ave  )      ,//经过均值滤波后的距离值
    . beep_out      ( beep_out  )      ,
    . led_out       ( led_out   )       
);

//二进制码转化为8421BCD码
bin_to_bcd bin_to_bcd_inst_1
(
    . sys_clk      ( sys_clk   )       ,//The onboard clock frequency is 50MHz.
    . sys_rst_n    ( sys_rst_n )       ,
    . data_ave     ( data_ave  )       ,
    . data_bcd     ( data_bcd  )        
);

//数码管显示模块
nixie_display
#(
    . CNT_1MS_MAX     (   16'd50_000      )
)
nixie_display_inst_1
(
    .  sys_clk       (sys_clk   )      ,//Clock frequency is 50MHz.
    .  sys_rst_n     (sys_rst_n )      ,
    .  data_bcd      (data_bcd  )      ,
    .  nixie_cs      (nixie_cs  )      ,//数码管位选信号
    .  nixie_seg     (nixie_seg )       //数码管段选信号dp_g_to_a
);

endmodule