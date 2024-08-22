//ambikam2, iren2

module lab622xsa(
   input logic Clk,
   input logic reset_rtl_0,
  
   // USB signals
   input logic [0:0] gpio_usb_int_tri_i,
   output logic gpio_usb_rst_tri_o,
   input logic usb_spi_miso,
   output logic usb_spi_mosi,
   output logic usb_spi_sclk,
   output logic usb_spi_ss,
  
   // UART
   input logic uart_rtl_0_rxd,
   output logic uart_rtl_0_txd,
  
   // HDMI
   output logic hdmi_tmds_clk_n,
   output logic hdmi_tmds_clk_p,
   output logic [2:0] hdmi_tmds_data_n,
   output logic [2:0] hdmi_tmds_data_p,
      
   // HEX displays
   output logic [7:0] hex_segA,
   output logic [3:0] hex_gridA,
   output logic [7:0] hex_segB,
   output logic [3:0] hex_gridB
);
  
   logic [31:0] keycode0_gpio, keycode1_gpio;
   logic clk_25MHz, clk_125MHz, clk, clk_100MHz;
   logic locked;
   logic [9:0] drawX, drawY;
   logic [9:0] rectx, recty, rectL, rectR, rectU, rectD;
   logic [3:0] bg_red, bg_green, bg_blue;
   
   logic [9:0] rect2x, rect2y, rect2L, rect2R, rect2U, rect2D; 

   logic motionx_;
   logic motionx1_;

   logic punch_flag_;
   logic punch_flag1_;
    
   logic kick_flag_;
   logic kick_flag1_;
    
   logic block_flag_;
   logic block_flag1_;
    
   logic [7:0] healthL_;
   logic [7:0] healthR_;
    
   logic deathL_;
   logic deathR_;
    
   logic [3:0] bg_red_, bg_green_, bg_blue_;
    
   logic startscreen_;
   logic fighting_;
   logic ending_;

   logic hsync, vsync, vde;
   logic [3:0] red, green, blue;
   logic reset_ah;
  
   assign reset_ah = reset_rtl_0;

   // Keycode HEX drivers
   hex_driver HexA (
       .clk(Clk),
       .reset(reset_ah),
       .in({keycode0_gpio[15:12], keycode0_gpio[11:8], keycode0_gpio[7:4], keycode0_gpio[3:0]}),
       .hex_seg(hex_segA),
       .hex_grid(hex_gridA)
   );
  
   hex_driver HexB (
       .clk(Clk),
       .reset(reset_ah),
       .in({keycode1_gpio[15:12], keycode1_gpio[11:8], keycode1_gpio[7:4], keycode1_gpio[3:0]}),
       .hex_seg(hex_segB),
       .hex_grid(hex_gridB)
   );
  
   mb_block mb_block_i (
       .clk_100MHz(Clk),
       .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
       .gpio_usb_keycode_0_tri_o(keycode0_gpio),
       .gpio_usb_keycode_1_tri_o(keycode1_gpio),
       .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
       .reset_rtl_0(~reset_ah),
       .uart_rtl_0_rxd(uart_rtl_0_rxd),
       .uart_rtl_0_txd(uart_rtl_0_txd),
       .usb_spi_miso(usb_spi_miso),
       .usb_spi_mosi(usb_spi_mosi),
       .usb_spi_sclk(usb_spi_sclk),
       .usb_spi_ss(usb_spi_ss)
   );
      
   // Clock wizard configured with a 1x and 5x clock for HDMI
   clk_wiz_0 clk_wiz (
       .clk_out1(clk_25MHz),
       .clk_out2(clk_125MHz),
       .reset(reset_ah),
       .locked(locked),
       .clk_in1(Clk)
   );
  
   // VGA Sync signal generator
   vga_controller vga (
       .pixel_clk(clk_25MHz),
       .reset(reset_ah),
       .hs(hsync),
       .vs(vsync),
       .active_nblank(vde),
       .drawX(drawX),
       .drawY(drawY)
   );

   // Real Digital VGA to HDMI converter
   hdmi_tx_0 vga_to_hdmi (
       .pix_clk(clk_25MHz),
       .pix_clkx5(clk_125MHz),
       .pix_clk_locked(locked),
       .rst(reset_ah),
       .red(red),
       .green(green),
       .blue(blue),
       .hsync(hsync),
       .vsync(vsync),
       .vde(vde),
       .aux0_din(4'b0),
       .aux1_din(4'b0),
       .aux2_din(4'b0),
       .ade(1'b0),
       .TMDS_CLK_P(hdmi_tmds_clk_p),         
       .TMDS_CLK_N(hdmi_tmds_clk_n),         
       .TMDS_DATA_P(hdmi_tmds_data_p),        
       .TMDS_DATA_N(hdmi_tmds_data_n)
   );

   ball ball_inst(
        .Reset(reset_ah),
        .frame_clk(vsync),
        .keycode(keycode1_gpio[7:0]),
        .keycode2(keycode1_gpio[15:8]),
        .RectX(rectx2),
        .RectY(recty2),
        .RectL(rect2L),         
        .RectR(rect2R),       
        .RectU(rect2U),            
        .RectD(rect2D),
        .motionx(motionx_),
        .punch_flag(punch_flag_),
        .kick_flag(kick_flag_),
        .block_flag(block_flag_),
        .deathL(deathL_),
        .deathR(deathR_),
        .startscreen(startscreen_),
        .Rect1X(rectxsig),
        .Rect1Y(rectysig),
        .Rect1L(rectL),
        .Rect1R(rectR),
        .Rect1U(rectU),
        .Rect1D(rectD)
    );
   
  ball_1 ball_1_inst(
        .Reset(reset_ah),
        .frame_clk(vsync),
        .keycode(keycode0_gpio[7:0]),
        .keycode2(keycode0_gpio[15:8]),
        .RectX(rectx),
        .RectY(recty),
        .RectL(rectL),
        .RectR(rectR),
        .RectU(rectU),
        .RectD(rectD),
        .motionx1(motionx1_),
        .punch_flag1(punch_flag1_),
        .kick_flag1(kick_flag1_),
        .block_flag1(block_flag1_),
        .deathL(deathL_),
        .deathR(deathR_),
        .startscreen(startscreen_),
        .Rect2X(rectx2),
        .Rect2Y(recty2),
        .Rect2L(rect2L),
        .Rect2R(rect2R),
        .Rect2U(rect2U),
        .Rect2D(rect2D)
    );

   // Color Mapper Module  
   color_mapper color_instance(
        .DrawX(drawX),
        .DrawY(drawY),
        .RectX(rectx),
        .RectY(recty),
        .RectL(rectL),
        .RectR(rectR),
        .RectU(rectU),
        .RectD(rectD),
        .Rect2X(rect2x),
        .Rect2Y(rect2y),
        .Rect2L(rect2L),
        .Rect2R(rect2R),
        .Rect2U(rect2U),
        .Rect2D(rect2D),
        .motionx(motionx_),
        .motionx1(motionx1_),
        .Red(red),
        .Green(green),
        .Blue(blue),
        .punch(punch_flag_),
        .punch1(punch_flag1_),
        .kick(kick_flag_),
        .kick1(kick_flag1_),
        .block(block_flag_),
        .block1(block_flag1_),
        .healthR(healthR_),
        .healthL(healthL_),
        .deathR(deathR_),
        .deathL(deathL_),
        .bg_red(bg_red_),
        .bg_green(bg_green_),
        .bg_blue(bg_blue_),
        .startscreen(startscreen_),
        .fighting(fighting_),
        .ending(ending_),
        .clk_25MHz(clk_25MHz),
        .clk_100MHz(Clk),
        .vsync(vsync),
        .Reset(reset_ah)
   );

   states states_instance(
        .clk_25MHz(clk_25MHz),
        .Reset(reset_ah), 
        .keycode(keycode1_gpio[7:0]), 
        .keycode1(keycode1_gpio[15:8]), 
        .keycode2(keycode0_gpio[7:0]), 
        .keycode3(keycode0_gpio[15:8]),
        .DrawX(drawX), 
        .DrawY(drawY),
        .healthL(healthL_),
        .healthR(healthR_),
        .startscreen(startscreen_),
        .fighting(fighting_),
        .ending(ending_),
        .deathL(deathL_),
        .deathR(deathR_),
        .bg_red(bg_red_), 
        .bg_green(bg_green_), 
        .bg_blue(bg_blue_)
   );
endmodule


