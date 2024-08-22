
module states(
    input logic clk_25MHz,
    input logic Reset, 
    
    input logic [7:0] keycode, keycode1, keycode2, keycode3,
    
    input logic [9:0] DrawX, DrawY,
    input logic [7:0] healthL,
    input logic [7:0] healthR,
    
    output logic startscreen,
    output logic fighting,
    output logic ending,
    
    output logic deathL,
    output logic deathR,
    
    output logic [3:0] bg_red, bg_green, bg_blue
    );
    
    logic deathL_next;
    logic deathR_next;
    
    logic [3:0] wbg_red, wbg_green, wbg_blue;
    logic [3:0] bg2_red, bg2_green, bg2_blue;
    logic [3:0] obg_red, obg_green, obg_blue;
    
    logic startscreen_next = 1'b0;
    
    logic fighting_next = 1'b0;
    logic ending_next = 1'b0;
    
    // Overall idea for this is for this module to now handle all of background RGB outputs, but now it selects between
    // 3 different BRAM instantiations of backgrounds
    
   welcome_bg_example wbg (
   .red(wbg_red),
   .green(wbg_green),
   .blue(wbg_blue),
   .DrawX(DrawX),
   .DrawY(DrawY),
   .blank(1),
   .vga_clk(clk_25MHz)
   );
    
   bg2_example bg2 (
   .red(bg2_red),
   .green(bg2_green),
   .blue(bg2_blue),
   .DrawX(DrawX),
   .DrawY(DrawY),
   .blank(1),
   .vga_clk(clk_25MHz)
   );
   
   obg_example obg (
   .red(obg_red),
   .green(obg_green),
   .blue(obg_blue),
   .DrawX(DrawX),
   .DrawY(DrawY),
   .blank(1),
   .vga_clk(clk_25MHz)
   );
    
    always_comb begin: check_states
    
//    startscreen_next = startscreen;
    fighting_next = fighting;
    ending_next = ending;
    
    if (startscreen && (!((keycode == 8'h28) || (keycode1 == 8'h28) || (keycode2 == 8'h28) || (keycode3 == 8'h28))) )
    begin
        bg_red = wbg_red;
        bg_green = wbg_green;
        bg_blue = wbg_blue;
        startscreen_next = 1'b1;
        fighting_next = 1'b0;
        ending_next = 1'b0;
    end
    
    else if ((keycode == 8'h28) || (keycode1 == 8'h28) || (keycode2 == 8'h28) || (keycode3 == 8'h28))
    begin
       startscreen_next = 1'b0;
       fighting_next = 1'b1;
       ending_next = 1'b0;
       
       bg_red = bg2_red;
       bg_green = bg2_green;
       bg_blue = bg2_blue;
    end
    
    else if (fighting && ((healthL < 192) && (healthR < 192)))
    begin
        bg_red = bg2_red;
        bg_green = bg2_green;
        bg_blue = bg2_blue;
        
        startscreen_next = 1'b0;
        
        deathL_next = 1'b0;
        deathR_next = 1'b0;
        
        ending_next = 1'b0;
    end
    
    else if (fighting && ((healthL >= 192) && (healthR < 192)))
    begin

        bg_red = obg_red;//bg2_red;
        bg_green = obg_green;//bg2_green;
        bg_blue = obg_blue;//bg2_blue;
        
        startscreen_next = 1'b0;
        
        deathL_next = 1'b1;
        deathR_next = 1'b0;
        
        ending_next = 1'b1;
    end 
    
    else if (fighting && ((healthL < 192) && (healthR >= 192)))
    begin

       bg_red = obg_red;//bg2_red;
        bg_green = obg_green;//bg2_green;
        bg_blue = obg_blue;//bg2_blue;
        
        startscreen_next = 1'b0;
        
        deathL_next = 1'b0;
        deathR_next = 1'b1;
        
        ending_next = 1'b1;
    end 
    
    else if (fighting && ((healthL >= 192) && (healthR >= 192)))
    begin
  
        bg_red = obg_red;//bg2_red;
        bg_green = obg_green;//bg2_green;
        bg_blue = obg_blue;//bg2_blue;
        
//        bg_red = bg2_red;
//        bg_green = bg2_green;
//        bg_blue = bg2_blue;
        
        startscreen_next = 1'b0;
        
        deathL_next = 1'b1;
        deathR_next = 1'b1;
        
        ending_next = 1'b1;
    end 
    
    else 
    begin
        bg_red = wbg_red;
        bg_green = wbg_green;
        bg_blue = wbg_blue;
        startscreen_next = 1'b1;
        fighting_next = 1'b0;
        ending_next = 1'b0;
        deathL_next = 1'b0;
        deathR_next = 1'b0;
    end
    
    end
    
    always_ff @ (posedge clk_25MHz or posedge Reset) 
    begin 
    
    if (Reset)
    begin
        startscreen <= 1'b1;
        fighting <= 1'b0;
        ending <= 1'b0;
        deathL <= 1'b0;
        deathR <= 1'b0;
    end
    
    else
    begin
        startscreen <= startscreen_next;
        fighting <= fighting_next;
        ending <= ending_next;
        deathL <= deathL_next;
        deathR <= deathR_next;
    end
    
    end
    
    
endmodule
