
module doppo_walk (
	input logic vga_clk,
	input logic vsync, // frame clock
	input logic [9:0] motionx1,
	input logic [9:0] DrawX, DrawY,
	input logic [9:0] spriteX, spriteY, spriteWidthL, spriteHeightU,
	input logic [7:0] healthL,
	output logic [3:0] red, green, blue
);

logic [5:0] walk_count_curr;
logic [5:0] walk_count_next;

logic [5:0] breathe_count_curr;
logic [5:0] breathe_count_next;

logic [3:0] doppo_stand_red, doppo_stand_green, doppo_stand_blue;
logic [3:0] doppo_rage_red, doppo_rage_green, doppo_rage_blue;
logic [3:0] doppo_walk_red, doppo_walk_green, doppo_walk_blue;
logic [3:0] doppo_breathe_red, doppo_breathe_green, doppo_breathe_blue;

doppo_breathe_example dbreathe(
   .red(doppo_breathe_red),
   .green(doppo_breathe_green),
   .blue(doppo_breathe_blue),
   .DrawX(DrawX),
   .DrawY(DrawY),
   .blank(1),
   .spriteX(spriteX),
   .spriteY(spriteY),
   .spriteWidthL(spriteWidthL),
   .spriteHeightU(spriteHeightU),
   .vga_clk(vga_clk)
);


 doppo_example dstand(
   .red(doppo_stand_red),
   .green(doppo_stand_green),
   .blue(doppo_stand_blue),
   .DrawX(DrawX),
   .DrawY(DrawY),
   .blank(1),
   .spriteX(spriteX),
   .spriteY(spriteY),
   .spriteWidthL(spriteWidthL),
   .spriteHeightU(spriteHeightU),
   .vga_clk(vga_clk)
   );
   
  doppo_rage_example drage(
   .red(doppo_rage_red),
   .green(doppo_rage_green),
   .blue(doppo_rage_blue),
   .DrawX(DrawX),
   .DrawY(DrawY),
   .blank(1),
   .spriteX(spriteX),
   .spriteY(spriteY),
   .spriteWidthL(spriteWidthL),
   .spriteHeightU(spriteHeightU),
   .vga_clk(vga_clk)
   );  

 doppo_walk_example dwalk(
   .red(doppo_walk_red),
   .green(doppo_walk_green),
   .blue(doppo_walk_blue),
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

if (motionx1 != 0 && walk_count_curr < 24)
begin
    walk_count_next = walk_count_curr + 1;
end

else
begin
    walk_count_next = 0;
end

if (motionx1 == 0 && breathe_count_curr < 24)
begin
    breathe_count_next = breathe_count_curr + 1;
end 

else
begin
    breathe_count_next = 0;
end

if (motionx1 == 0)
begin
    if (breathe_count_curr  >= 0 && breathe_count_curr <= 12)
    begin
        if (healthL < 120)
        begin
            red = doppo_stand_red;
            green = doppo_stand_green;
            blue = doppo_stand_blue;
        end
        
        else 
        begin
            red = doppo_rage_red;
            green = doppo_rage_green;
            blue = doppo_rage_blue;
        end
    end
    else
    begin
        red = doppo_breathe_red;
        green = doppo_breathe_green;
        blue = doppo_breathe_blue;
    end
end

else 
begin

    if (walk_count_curr >= 0 && walk_count_curr < 2)
    begin
        if (healthL >= 120)
        begin
            red = doppo_rage_red;
            green = doppo_rage_green;
            blue = doppo_rage_blue;
        end
        else
        begin
            red = doppo_stand_red;
            green = doppo_stand_green;
            blue = doppo_stand_blue;
        end
    end
    
    else if (walk_count_curr <= 11 && walk_count_curr > 2)
    begin
        red = doppo_walk_red;
        green = doppo_walk_green;
        blue = doppo_walk_blue;
    end
    
    else
    begin
        if (healthL >= 120)
        begin
            red = doppo_rage_red;
            green = doppo_rage_green;
            blue = doppo_rage_blue;
        end
        else
        begin
            red = doppo_stand_red;
            green = doppo_stand_green;
            blue = doppo_stand_blue;
        end
    end

end

end


always_ff @ (posedge vsync) begin

walk_count_curr <= walk_count_next;
breathe_count_curr <= breathe_count_next;

end

endmodule

