//ambikam2, iren2
module create_shadow(
    input logic [9:0] DrawX, DrawY, 
    input logic [9:0] RectX, RectY, 
    input logic [9:0] RectY, RectL, RectR, RectU, RectD,
    input logic [9:0] Rect2X, Rect2Y, 
    input logic [9:0] Rect2L, Rect2R, Rect2U, Rect2D,
    input logic clk_25MHz, 
    output logic [3:0] shadowL_red, shadowL_green, shadowL_blue, 
    output logic [3:0] shadowR_red, shadowR_green, shadowR_blue
    );
    
    
    logic [3:0] shadowL_large_red, shadowL_large_green, shadowL_large_blue;
    logic [3:0] shadowL_small_red, shadowL_small_green, shadowL_small_blue;
    logic [3:0] shadowR_large_red, shadowR_large_green, shadowR_large_blue;
    logic [3:0] shadowR_small_red, shadowR_small_green, shadowR_small_blue;
    
    parameter [9:0] Rect_Y_Max= 420;  // Bottommost point on the Y axis
    
    shadow2_example shadowL_large (
       .red(shadowL_large_red),
       .green(shadowL_large_green),
       .blue(shadowL_large_blue),
       .DrawX(DrawX),
       .DrawY(DrawY),
       .blank(1),
       .spriteX(RectX),
       .spriteY(RectY),
       .vga_clk(clk_25MHz)
   );
   
   shadow_example shadowL_small (
       .red(shadowL_small_red),
       .green(shadowL_small_green),
       .blue(shadowL_small_blue),
       .DrawX(DrawX),
       .DrawY(DrawY),
       .blank(1),
       .spriteX(RectX),
       .spriteY(RectY),
       .vga_clk(clk_25MHz)
   );
   
    shadow2_example shadowR_large (
       .red(shadowR_large_red),
       .green(shadowR_large_green),
       .blue(shadowR_large_blue),
       .DrawX(DrawX),
       .DrawY(DrawY),
       .blank(1),
       .spriteX(Rect2X),
       .spriteY(Rect2Y),
       .vga_clk(clk_25MHz)
   );
   
   shadow_example shadowR_small (
       .red(shadowR_small_red),
       .green(shadowR_small_green),
       .blue(shadowR_small_blue),
       .DrawX(DrawX),
       .DrawY(DrawY),
       .blank(1),
       .spriteX(Rect2X),
       .spriteY(Rect2Y),
       .vga_clk(clk_25MHz)
   );
    
always_comb begin: Left_side_shadow
    
if (RectY + RectD == Rect_Y_Max)
begin
    shadowL_red = shadowL_large_red;
    shadowL_green = shadowL_large_green;
    shadowL_blue = shadowL_large_blue;
end

else 
begin
    shadowL_red = shadowL_small_red;
    shadowL_green = shadowL_small_green;
    shadowL_blue = shadowL_small_blue;
end

end


always_comb begin: right_side_shadow
    
    
if (Rect2Y + Rect2D == Rect_Y_Max)
begin
    shadowR_red = shadowR_large_red;
    shadowR_green = shadowR_large_green;
    shadowR_blue = shadowR_large_blue;
end

else 
begin
    shadowR_red = shadowR_small_red;
    shadowR_green = shadowR_small_green;
    shadowR_blue = shadowR_small_blue;
end
    
end 
   
endmodule
