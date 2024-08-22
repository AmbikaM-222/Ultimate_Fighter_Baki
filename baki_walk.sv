
module baki_walk (
	input logic vga_clk,
	input logic vsync, // frame clock
	input logic [9:0] motionx,
	input logic [9:0] DrawX, DrawY,
	input logic [9:0] spriteX, spriteY, spriteWidthL, spriteHeightU,
	input logic [7:0] healthR,
	output logic [3:0] red, green, blue
	
);

logic [5:0] walk_count_curr;
logic [5:0] walk_count_next;

logic [5:0] breathe_count_curr;
logic [5:0] breathe_count_next;

logic [3:0] baki_stand_red, baki_stand_green, baki_stand_blue;
logic [3:0] baki_rage_red, baki_rage_green, baki_rage_blue;
logic [3:0] baki_walk_red, baki_walk_green, baki_walk_blue;
logic [3:0] baki_breathe_red, baki_breathe_green, baki_breathe_blue;




baki_breathe_example bbreathe(
   .red(baki_breathe_red),
   .green(baki_breathe_green),
   .blue(baki_breathe_blue),
   .DrawX(DrawX),
   .DrawY(DrawY),
   .blank(1),
   .spriteX(spriteX),
   .spriteY(spriteY),
   .spriteWidthL(spriteWidthL),
   .spriteHeightU(spriteHeightU),
   .vga_clk(vga_clk)
   );


 baki_example bstand(
   .red(baki_stand_red),
   .green(baki_stand_green),
   .blue(baki_stand_blue),
   .DrawX(DrawX),
   .DrawY(DrawY),
   .blank(1),
   .spriteX(spriteX),
   .spriteY(spriteY),
   .spriteWidthL(spriteWidthL),
   .spriteHeightU(spriteHeightU),
   .vga_clk(vga_clk)
   );
   
  baki_rage_example brage(
   .red(baki_rage_red),
   .green(baki_rage_green),
   .blue(baki_rage_blue),
   .DrawX(DrawX),
   .DrawY(DrawY),
   .blank(1),
   .spriteX(spriteX),
   .spriteY(spriteY),
   .spriteWidthL(spriteWidthL),
   .spriteHeightU(spriteHeightU),
   .vga_clk(vga_clk)
   );

 baki_walk_example bwalk(
   .red(baki_walk_red),
   .green(baki_walk_green),
   .blue(baki_walk_blue),
   .DrawX(DrawX),
   .DrawY(DrawY),
   .blank(1),
   .spriteX(spriteX),
   .spriteY(spriteY),
   .spriteWidthL(spriteWidthL),
   .spriteHeightU(spriteHeightU),
   .vga_clk(vga_clk)
   );

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
//assign rom_address = ((DrawX * 90) / 640) + (((DrawY * 150) / 480) * 90);
always_comb begin: walking_animation

if (motionx != 0 && walk_count_curr < 24)
begin
    walk_count_next = walk_count_curr + 1;
end

else
begin
    walk_count_next = 0;
end

if (motionx == 0 && breathe_count_curr < 24)
begin
    breathe_count_next = breathe_count_curr + 1;
end

else
begin
    breathe_count_next = 0;
end

if (motionx == 0)
begin
    if (breathe_count_curr  >= 0 && breathe_count_curr <= 12)
    begin
        if (healthR < 120)
        begin
            red = baki_stand_red;
            green = baki_stand_green;
            blue = baki_stand_blue;
        end
        
        else 
        begin
            red = baki_rage_red;
            green = baki_rage_green;
            blue = baki_rage_blue;
        end
    end
    else
    begin
        red = baki_breathe_red;
        green = baki_breathe_green;
        blue = baki_breathe_blue;
    end
end

else 
begin
    if (walk_count_curr >= 0 && walk_count_curr < 2)
    begin
        if (healthR >= 120)
        begin
            red = baki_rage_red;
            green = baki_rage_green;
            blue = baki_rage_blue;
        end
        else
        begin
            red = baki_stand_red;
            green = baki_stand_green;
            blue = baki_stand_blue;
        end
    end
    
    else if (walk_count_curr <= 11 && walk_count_curr > 2)
    begin
        red = baki_walk_red;
        green = baki_walk_green;
        blue = baki_walk_blue;
    end
    
    else
    begin
        if (healthR >= 120)
        begin
            red = baki_rage_red;
            green = baki_rage_green;
            blue = baki_rage_blue;
        end
        else
        begin
            red = baki_stand_red;
            green = baki_stand_green;
            blue = baki_stand_blue;
        end
    end

end

end

always_ff @ (posedge vsync) begin

walk_count_curr <= walk_count_next;
breathe_count_curr <= breathe_count_next;

end

endmodule

