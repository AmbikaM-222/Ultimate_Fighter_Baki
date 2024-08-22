//ambikam2, iren2
module color_mapper (
    input logic [9:0] DrawX, DrawY, RectX, RectY, RectL, RectR, RectU, RectD,
    Rect2X, Rect2Y, Rect2L, Rect2R, Rect2U, Rect2D,
    input logic clk_25MHz,
    input logic clk_100MHz,
    input logic vsync,
    input logic [9:0] motionx,
    input logic [9:0] motionx1,
    input logic Reset,
    input logic punch,  // right character punch
    input logic punch1, // left character punch
    input logic kick, // right character kick
    input logic kick1, // left character kick
    input logic block, // right character block
    input logic block1, // left character block
    input logic [3:0] bg_red, bg_green, bg_blue,
    input logic startscreen,
    input logic fighting,
    input logic ending,
    input logic deathL,
    input logic deathR,
    output logic [7:0] healthR,
    output logic [7:0] healthL,
    output logic [3:0] Red, Green, Blue
);

    logic clk_;
    logic rect_on, rect_on2;
    logic shadow_on, shadow_on2;
    parameter [9:0] Rect_Y_Max = 420;  // Bottommost point on the Y axis
    parameter [9:0] health_Max_startL = 258;
    parameter [9:0] health_Max_startR = 373;
    parameter [9:0] health_Max_endL  = 66;
    parameter [9:0] health_Max_endR = 564;
    parameter [9:0] block_startL = 66;
    parameter [9:0] block_endL  = 257;
    parameter [9:0] block_startR = 373;
    parameter [9:0] block_endR = 564;
    parameter [9:0] critX_L = 110;
    parameter [9:0] critY_L = 55;
    parameter [9:0] critX_R = 400;
    parameter [9:0] critY_R = 60;
    parameter [9:0] rageX_L = 60;
    parameter [9:0] rageY_L = 72;
    parameter [9:0] rageX_R = 505;
    parameter [9:0] rageY_R = 75;

   

    always_comb begin: Sprite_on_proc
        if ((DrawX >= RectX - RectL + 2) &&
            (DrawX <= RectX + RectR) &&
            (DrawY >= RectY - RectU) &&
            (DrawY <= RectY + RectD - 2)
            ) begin
                    rect_on = 1'b1;
            end
        else begin
            rect_on = 1'b0;
        end
                
        if ((DrawX >= Rect2X - Rect2L + 2) &&
            (DrawX <= Rect2X + Rect2R) &&
            (DrawY >= Rect2Y - Rect2U) &&
            (DrawY <= Rect2Y + Rect2D - 2)) begin
            rect_on2 = 1'b1;
        end else begin
            rect_on2 = 1'b0;
        end
    end




 always_comb begin: block_bar
    
    //block bar R
    
    if (block) 
    begin
        if (blockbarR_current < 192)
        begin
            blockbarR_next = blockbarR_current + 8'd2;
            block_emptyR = 1'b0;
        end
        else
        begin
            blockbarR_next = 8'd192;
            block_emptyR  = 1'b1;
        end
    end
    
    
    else
    begin
        if (blockbarR_current == 192)
        begin
            blockbarR_next = blockbarR_current - 8'd1;
            block_emptyR = 1'b1;
        end
        else if (blockbarR_current < 192 && blockbarR_current > 0)
        begin
            blockbarR_next = blockbarR_current - 8'd1;
            block_emptyR = 1'b0;
        end
        else
        begin
            blockbarR_next = 8'd0;
            block_emptyR = 1'b0;
        end
        
    end
    
if (block1) 
    begin
        if (blockbarL_current < 192)
        begin
            blockbarL_next = blockbarL_current + 8'd2;
            block_emptyL = 1'b0;
        end
        else
        begin
            blockbarL_next = 8'd192;
            block_emptyL  = 1'b1;
        end
    end
    
    
    else
    begin
        if (blockbarL_current == 192)
        begin
            blockbarL_next = blockbarL_current - 8'd1;
            block_emptyL = 1'b1;
        end
        else if (blockbarL_current < 192 && blockbarL_current > 0)
        begin
            blockbarL_next = blockbarL_current - 8'd1;
            block_emptyL = 1'b0;
        end
        else
        begin
            blockbarL_next = 8'd0;
            block_emptyL = 1'b0;
        end
        
    end
    

//if (block1)
//begin
//    if (blockbarL_current > 2)
//    begin
//        blockbarL_next = blockbarL_current - 8'd2; // Decrease by 2 when block1 is active
//        block_emptyL = 1'b0; // Not empty since it's decreasing from a positive number
//    end
//    else
//    begin
//        blockbarL_next = 8'd0; // Ensures it doesn't go negative
//        block_emptyL = 1'b1; // It's empty when it reaches 0
//    end
//end

//else
//begin
//    if (blockbarL_current == 0)
//    begin
//        blockbarL_next = blockbarL_current + 8'd2; // Start increasing from 0
//        block_emptyL = 1'b1; // Still empty until it begins to increase
//    end
//    else if (blockbarL_current > 0 && blockbarL_current < 192)
//    begin   
//        blockbarL_next = blockbarL_current + 8'd1; // Increase by 1
//        block_emptyL = 1'b0; // Not empty since it's increasing and below 192
//    end
//    else
//    begin
//        blockbarL_next = 8'd192; // Capped at 192, cannot increase further
//        block_emptyL = 1'b0; // Not empty when at 192
//    end
//end


    end
    
    always_comb begin: block_drawing
    //right bar first
    
    if ((DrawY >= 35) && (DrawY <= 40) && (DrawX <= block_endR && DrawX >= block_startR + blockbarR_current) && DrawX >= block_startR)
    begin
        blockdrawR = 1'b1;
    end
    
    else 
    begin
        blockdrawR = 1'b0;
    end
    
    //left bar
//    if ((DrawY >= 35) && (DrawY <= 40) && (DrawX >= block_startL) && (DrawX <= block_startL + blockbarL_current) && DrawX <= block_endL)
//    begin
//        blockdrawL = 1'b1;
//    end
    
//    else 
//    begin
//        blockdrawL = 1'b0;
//    end
    
//    end

    if ((DrawY >= 35) && (DrawY <= 40) && (DrawX >= block_startL) && (DrawX <= block_endL - blockbarL_current) && DrawX <= block_endL)
    begin
        blockdrawL = 1'b1;
    end
    
    else 
    begin
        blockdrawL = 1'b0;
    end
    
    end
    
    always_comb begin: rage_damage
    
    if (healthL_current < 120)
    begin
        rageL = 8'd0;
    end
   
    else
    begin
        rageL = 8'd1;
    end
    
    
    if (healthR_current < 120)
    begin
        rageR = 8'd0;
    end
   
    else
    begin
        rageR = 8'd1;
    end
    
    
    
    end
    
    always_comb begin: hit_detection
    
    healthL_next = healthL_current;
    healthR_next = healthR_current;
    
//    hitL_next = 1'b0;
//    hitR_next = 1'b0;
    
    if (punch_count < 32'd4  && punch_count > 0)
    begin
       punch_ = 1'b1;
    end
    
    else
    begin
        punch_ = 1'b0;
    end
    
    if (punch1_count < 32'd4 && punch1_count > 0)
    begin
        punch1_ = 1'b1;
    end
    
    else
    begin
        punch1_ = 1'b0;
    end
    
    //kick count logic 
    
     if (kick_count < 32'd4  && kick_count > 0)
    begin
       kick_ = 1'b1;
    end
    
    else
    begin
        kick_ = 1'b0;
    end
    
    
    if (kick1_count < 32'd4 && kick1_count > 0)
    begin
        kick1_ = 1'b1;
    end
    
    else
    begin
        kick1_ = 1'b0;
    end
    
    
    // check if a kick has hit
    if (kick1_ == 1'b1 && punch1_ == 1'b0 )
        begin
            if ((RectX + RectWidthRight > Rect2X - Rect2WidthLeft - 20) && (RectY > Rect2Y - 20) && (RectY < Rect2Y + 20) && (!deathR) && (!deathL) && (!block))
                begin         
                    critR_next = 1'b1;
                    hitR_next = 1'b1;
                    healthR_next = (healthR_current + 8'h02 + rageL);
                end
            else if ((RectX + RectWidthRight > Rect2X - Rect2WidthLeft - 20) && (RectY > Rect2Y - 20) && (RectY < Rect2Y + 20) && (!deathR) && (!deathL) && (block) && (block_emptyR))
                 begin         
                    critR_next = 1'b1;
                    hitR_next = 1'b1;
                    healthR_next = (healthR_current + 8'h02 + rageL);
                end         
           else 
                begin
                    critR_next = 1'b0;
                    hitR_next = 1'b0;
                    healthR_next = healthR_current;
                end
        end
        
//        else
//        begin
//            hitR_next = 1'b0;
//        //    healthR_next = healthR_current;
//        end
        
        // if player one throws a punch or punch1, check 20 if the characters are within 10 pixels of each other horizontally and 20 pixels vertically
    if (punch1_ == 1'b1 && kick1_ == 1'b0)
        begin
            if ((RectX + RectWidthRight > Rect2X - Rect2WidthLeft - 10) && (RectY > Rect2Y - 20) && (RectY < Rect2Y + 20) && (!deathR) && (!deathL) && (!block))
                begin           
                    hitR_next = 1'b1;
                    critR_next = 1'b0;
                    healthR_next = (healthR_current + 8'h01 + rageL);
                    end
                    
            else if ((RectX + RectWidthRight > Rect2X - Rect2WidthLeft - 20) && (RectY > Rect2Y - 20) && (RectY < Rect2Y + 20) && (!deathR) && (!deathL) && (block) && (block_emptyR))
                 begin         
                    hitR_next = 1'b1;
                    critR_next = 1'b0;
                    healthR_next = (healthR_current + 8'h01 + rageL);
                end    
            else
                begin
                    hitR_next = 1'b0;
                    critR_next = 1'b0;
                    healthR_next = healthR_current;
                end
        end
        
//   else
//        begin
//            hitR_next = 1'b0;
//            healthR_next = healthR_current;
//        end
        
    if (kick_ == 1'b1 && punch_ == 1'b0)
        begin
            if  ((RectX + RectWidthRight > Rect2X - Rect2WidthLeft-20) && (RectY > Rect2Y - 20) && (RectY < Rect2Y + 20) && (!deathR) && (!deathL) && (!block1))
                begin
                    critL_next = 1'b1;
                    hitL_next = 1'b1;
                    healthL_next = (healthL_current + 8'h02 + rageR);
                end 
            else if ((RectX + RectWidthRight > Rect2X - Rect2WidthLeft-20) && (RectY > Rect2Y - 20) && (RectY < Rect2Y + 20) && (!deathR) && (!deathL) && (block1) && (block_emptyL))
                begin
                    critL_next = 1'b1;
                    hitL_next = 1'b1;
                    healthL_next = (healthL_current + 8'h02 + rageR);
                end 
            else 
                begin
                    critL_next = 1'b0; 
                    hitL_next = 1'b0;   
                    healthL_next = healthL_current;
                end
        end
        
//        else 
//        begin
//            hitL_next = 1'b0;
//            healthL_next = healthL_current;
//        end
        
//    else 
//        begin
//            hitL_next = 1'b0;
//        end
        
  
    

        
//    else
//        begin
//            hitR_next = 1'b0;
//        end
        
    if (punch_ == 1'b1 && kick_ == 1'b0)
        begin
            if  ((RectX + RectWidthRight > Rect2X - Rect2WidthLeft-10) && (RectY > Rect2Y - 20) && (RectY < Rect2Y + 20) && (!deathR) && (!deathL) && (!block1))
                begin
                    critL_next = 1'b0; 
                    hitL_next = 1'b1;
                    healthL_next = (healthL_current + 8'h01 + rageR);
                end 
             else if  ((RectX + RectWidthRight > Rect2X - Rect2WidthLeft-10) && (RectY > Rect2Y - 20) && (RectY < Rect2Y + 20) && (!deathR) && (!deathL) && (block1) && (block_emptyL))
                begin
                    critL_next = 1'b0; 
                    hitL_next = 1'b1;
                    healthL_next = (healthL_current + 8'h01 + rageR);
                end 
            else 
                begin
                    critL_next = 1'b0; 
                    hitL_next = 1'b0;    
                    healthL_next = healthL_current;
                end
        end
        
//    else 
//        begin
//            hitL_next = 1'b0;
//            healthL_next = healthL_current;
//        end
        
   end
   
   always_ff @ (posedge vsync or posedge Reset)
   begin
    if (Reset)
    begin
        blockbarL_current <= 8'b0;
        blockbarR_current <= 8'b0;
    end
    
    else
    begin
        blockbarL_current <= blockbarL_next;
        blockbarR_current <= blockbarR_next;
    end
    end
    
    
    // this always FF handles all of the health updating, and hit marking
    //  The health value is changed every time  a hit is made and updated on the posedge of the clock
    // the hit marker determines if we made a hit or not to show the flashing, it is reset to 0 after the hit has been made
    
    always_ff @ (posedge clk_25MHz or posedge Reset)
    begin
        if (Reset)
        begin   
            healthL_current <= 8'b0;
            healthR_current <= 8'b0;
            
            hitL_current <= 1'b0;
            hitR_current <= 1'b0;
            
            critL_current <= 1'b0;
            critR_current <= 1'b0;
        
            kick_count <= 32'd0;
            kick1_count <= 32'd0;  
            
             punch_count  <= 32'd0;
             punch1_count <= 32'd0;
        end
        
        
        else if (kick == 1'b0 && kick1 == 1'b0 && punch == 1'b0 && punch1 == 1'b0)
        begin
            healthL_current <= healthL_next;
            healthR_current <= healthR_next;
            
            healthL <= healthL_current;
            healthR <= healthR_current;
            
            hitL_current <= 1'b0;
            hitR_current <= 1'b0;
            
            critL_current <= 1'b0;
            critR_current <= 1'b0;
            
            kick_count <= 32'b0;
            kick1_count <= 32'b0;
            
             punch_count  <= 32'd0;
             punch1_count <= 32'd0;
        end
        
        else if (kick == 1'b0 && kick1 == 1'b1 && punch1 == 1'b0/*&& (punch1 == 1'b0 || punch1 == 1'b1) && (punch == 1'b0 || punch == 1'b1)*/)
        begin
            healthL_current <= healthL_next;
            healthR_current <= healthR_next;
            
            healthL <= healthL_current;
            healthR <= healthR_current;
            
            hitL_current <= 1'b0;
            hitR_current <= hitR_next;
            
            critL_current <= 1'b0;
            critR_current <= critR_next;
            
            kick_count <= 32'b0;
            kick1_count <= kick1_count + 1;
            
            punch_count  <= 32'd0;
            punch1_count <= 32'd0;
        end
        
        else if (kick == 1'b1 && kick1 == 1'b0 /*&& (punch1 == 1'b0 || punch1 == 1'b1) && (punch == 1'b0 || punch == 1'b1)*/ )
        begin
            healthL_current <= healthL_next;
            healthR_current <= healthR_next;
            
            healthL <= healthL_current;
            healthR <= healthR_current;
            
            hitL_current <= hitL_next;
            hitR_current <= 1'b0;
            
            critL_current <= critL_next;
            critR_current <= 1'b0;
            
            kick_count <= kick_count + 1;
            kick1_count <= 32'b0;
            
            punch_count  <= 32'd0;
            punch1_count <= 32'd0;
        end
        
        else if (kick == 1'b1 && kick1 == 1'b1 /*&& (punch1 == 1'b0 || punch1 == 1'b1) && (punch == 1'b0 || punch == 1'b1)*/)
        begin
            healthL_current <= healthL_next;
            healthR_current <= healthR_next;
            
            healthL <= healthL_current;
            healthR <= healthR_current;
            
            hitL_current <= hitL_next;
            hitR_current <= hitR_next;
            
            critL_current <= critL_next;
            critR_current <= critR_next;
            
            kick_count <= kick_count + 1;
            kick1_count <= kick1_count + 1;
            
            punch_count  <= 32'd0;
            punch1_count <= 32'd0;
        end
        
        else if (punch == 1'b0 && punch1 == 1'b1  && (kick1 == 1'b0) /*&& (kick == 1'b0 || kick == 1'b1*/)
        begin
            healthL_current <= healthL_next;
            healthR_current <= healthR_next;
            
            healthL <= healthL_current;
            healthR <= healthR_current;
            
            hitL_current <= 1'b0;
            hitR_current <= hitR_next;
            
            critL_current <= 1'b0;
            critR_current <= 1'b0;
            
            punch_count <= 32'd0;
            punch1_count <= punch1_count + 1;
            
            kick_count <= 32'd0;
            kick1_count <= 32'd0; 
        end
        

        
        else if (punch == 1'b1 && punch1 == 1'b1 && (kick == 1'b0) && (kick1 == 1'b0))
        begin
            healthL_current <= healthL_next;
            healthR_current <= healthR_next;
            
            hitL_current <= hitL_next;
            hitR_current <= hitR_next;
            
            critL_current <= 1'b0;
            critR_current <= 1'b0;
            
            punch_count <= punch_count + 1;
            punch1_count <= punch1_count + 1;
            
            kick_count <= 32'd0;
            kick1_count <= 32'd0; 
        end
        
        else if (punch == 1'b1 && punch1 == 1'b0 && (kick == 1'b0) /* && (kick1 == 1'b0 || kick1 == 1'b1)*/)
        begin
            healthL_current <= healthL_next;
            healthR_current <= healthR_next;
            
            hitL_current <= hitL_next;
            hitR_current <= 1'b0;
            
            critL_current <= 1'b0;
            critR_current <= 1'b0;
            
            punch_count <= punch_count + 1;
            punch1_count <= 1'b0;
            
            kick_count <= 32'd0;
            kick1_count <= 32'd0; 
        end
        
        
        else
        begin
            healthL_current <= healthL_next;
            healthR_current <= healthR_next;
            
            hitL_current <= 1'b0;
            hitR_current <= 1'b0;
            
            critL_current <= 1'b0;
            critR_current <= 1'b0;
            
            punch_count <= 32'd0;
            punch1_count <= 32'd0;
            
            kick_count <= 32'd0;
            kick1_count <= 32'd0;
        end
    end
    
    always_comb begin: crithit_drawingL
        if ((DrawY >= critY_L + 5 && DrawY <= critY_L+ 30) && (DrawX >= critX_L && DrawX <= critX_L + 128) && critL_current == 1)
        begin
            drawcritL = 1'b1;
        end
        
        else 
        begin
            drawcritL = 1'b0;
        end
    
    end
    
    always_comb begin: crithit_drawingR
        if ((DrawY >= critY_R + 5 && DrawY <= critY_R + 30) && (DrawX >= critX_R && DrawX <= critX_R + 128) && critR_current == 1)
        begin
            drawcritR = 1'b1;
        end
        
        else 
        begin
            drawcritR = 1'b0;
        end
    
    end
    
    always_comb begin: rage_drawingL
        if ((DrawY >= rageY_L + 10 && DrawY <= rageY_L + 40) && (DrawX >= rageX_L + 5 && DrawX <= rageX_L + 75) && rageL == 8'h1)
        begin
            drawrageL = 1'b1;
        end
        
        else 
        begin
            drawrageL = 1'b0;
        end
    
   end 
   
   always_comb begin: rage_drawingR
        if ((DrawY >= rageY_R + 10 && DrawY <= rageY_R + 40) && (DrawX >= rageX_R + 5 && DrawX <= rageX_R + 75) && rageR == 8'h1)
        begin
            drawrageR = 1'b1;
        end
        
        else 
        begin
            drawrageR = 1'b0;
        end
    
   end 
    
    always_comb begin: health_bar_drawingL
        if (DrawY > 12 && DrawY < 28 && DrawX >= health_Max_startL - healthL_current && DrawX <= health_Max_startL /*+ 8'h01*/ && DrawX >= health_Max_endL)
        begin
            drawbarL = 1'b1;
        end
        
        else
        begin
            drawbarL = 1'b0;
        end
          
    end
    
    always_comb begin: health_bar_drawingR
        if (DrawY > 12 && DrawY < 28 && DrawX <= health_Max_startR + healthR_current-8'h03 && DrawX >= health_Max_startR && DrawX <= health_Max_endR)
        
        begin
            drawbarR = 1'b1;
        end
        
        else
        begin
            drawbarR = 1'b0;
        end
        
    end
       
    always_comb begin: RGB_Display
    
        if (drawbarL && (!ending) && (!startscreen))
        begin
            if (healthL_current < 120)
            begin
                Red = 4'hf;
                Green = 4'hA;
                Blue = 4'h0;
            end
            else 
            begin
                Red = 4'hf;
                Green = 4'h0;
                Blue = 4'h0;
            end
        end
        
        else if (drawbarR && (!ending)&& (!startscreen))
        begin
           if (healthR_current < 120)
            begin
                Red = 4'hf;
                Green = 4'hA;
                Blue = 4'h0;
            end
            else 
            begin
                Red = 4'hf;
                Green = 4'h0;
                Blue = 4'h0;
            end
        end
        
        else if (blockdrawL && (!ending) && (!startscreen))
        begin
            Red = 4'h0;
            Green = 4'h0;
            Blue = 4'hE;
        end
        
         else if (blockdrawR && (!ending) && (!startscreen))
         begin
            Red = 4'h0;
            Green = 4'h0;
            Blue = 4'hE;
         end
        
        else if (drawcritL)
        begin
            if (!((crithit_red == 4'hF) && (crithit_green == 4'h0) && (crithit_blue == 4'hA)))
            begin
                Red = crithit_red;
                Green = crithit_green;
                Blue = crithit_blue;
            end
            else
            begin
                Red = bg_red;
                Green = bg_green;
                Blue = bg_blue;
            end
        end
        
        else if (drawcritR)
        begin
            if (!((crithit_red == 4'hF) && (crithit_green == 4'h0) && (crithit_blue == 4'hA)))
            begin
                Red = crithit_red;
                Green = crithit_green;
                Blue = crithit_blue;
            end
            else
            begin
                Red = bg_red;
                Green = bg_green;
                Blue = bg_blue;
            end
        end
        
        else if (drawrageL && (!ending))
        begin
            if (!((rage_red == 4'h0) && (rage_green == 4'h0) && (rage_blue == 4'h0)))
            begin
                Red = rage_red;
                Green = rage_green;
                Blue = rage_blue;
            end
            else
            begin
//              Red = rage_red;
//                Green = rage_green;
//                Blue = rage_blue;
                
                 Red = bg_red;
                Green = bg_green;
                Blue = bg_blue;
            end
        end
        
       else if (drawrageR && (!ending))
        begin
            if (!((rage_red == 4'h0) && (rage_green == 4'h0) && (rage_blue == 4'h0)))
            begin
                Red = rage_red;
                Green = rage_green;
                Blue = rage_blue;
            end
            else
            begin
                Red = bg_red;
                Green = bg_green;
                Blue = bg_blue;
            end
        end
        
        
        
        else if (rect_on == 1'b1 && (!((doppo_red == 4'hF) && (doppo_green == 4'h3) && (doppo_blue == 4'hD))
        && !((doppo_red == 4'hB) && (doppo_green == 4'h4) && (doppo_blue == 4'h9))
        && !((doppo_red == 4'hA) && (doppo_green == 4'h3) && (doppo_blue == 4'h8)) 
        && !((doppo_red == 4'h0) && (doppo_green == 4'hF) && (doppo_blue == 4'h0))
        && !((doppo_red == 4'h3) && (doppo_green == 4'h9) && (doppo_blue == 4'h1))
        && !((doppo_red == 4'hF) && (doppo_green == 4'h0) && (doppo_blue == 4'hF))
        && !((doppo_red == 4'hC) && (doppo_green == 4'h2) && (doppo_blue == 4'hC)) )
         && (RectY+RectHeightDown == Rect_Y_Max) 
         && (!punch1) && (!startscreen) && (fighting) /*&&(!ending)*/
         && (!deathL) && (!kick1) && (!block1) /*|| (punch1 && kick1)*/ )
        begin
                if (hitL_current != 1'b1)
                begin
                    Red = doppo_red;
                    Green = doppo_green;
                    Blue = doppo_blue;
                end
                
                else 
                begin
                    Red = 4'hf;
                    Green = 4'h0;
                    Blue = 4'h0;
                end
        end
        
        else if (rect_on == 1'b1 && (!((doppo_jump_red == 4'hF) && (doppo_jump_green == 4'h3) && (doppo_jump_blue == 4'hD)) 
         && !((doppo_jump_red == 4'hC) && (doppo_jump_green == 4'h6) && (doppo_jump_blue == 4'hA))
         && (RectY+RectHeightDown < Rect_Y_Max) && (!punch1))&& (!startscreen) && (fighting) 
         && (!block1) /*&&(!ending)*/ && (!deathL) && (!kick1))
        begin
                if (hitL_current != 1'b1)
                begin
                    Red = doppo_jump_red;
                    Green = doppo_jump_green;
                    Blue = doppo_jump_blue;
                end
                
                else 
                begin
                    Red = 4'hf;
                    Green = 4'h0;
                    Blue = 4'h0;
                end
        end
        
            else if (rect_on == 1'b1 && (!((doppo_punch_red == 4'hF) && (doppo_punch_green == 4'h3) && (doppo_punch_blue == 4'hD))
          //  && !((doppo_punch_red == 4'hB) && (doppo_punch_green == 4'h3) && (doppo_punch_blue == 4'h9)) 
//            && !((doppo_punch_red == 4'hA) && (doppo_punch_green == 4'h3) && (doppo_punch_blue == 4'h8))) 
            && (punch1)) && (!startscreen) && (fighting) && (!deathL) && (!kick1) )
        begin
                if (hitL_current != 1'b1)
                begin
                    Red = doppo_punch_red;
                    Green = doppo_punch_green;
                    Blue = doppo_punch_blue;
                end
                
                else 
                begin
                    Red = 4'hf;
                    Green = 4'h0;
                    Blue = 4'h0;
                end

        end
        
        
        else if (rect_on == 1'b1 && (!((doppo_kick_red == 4'hF) && (doppo_kick_green == 4'h0) && (doppo_kick_blue == 4'hC))
        // && !((doppo_kick_red == 4'hD) && (doppo_kick_green == 4'h1) && (doppo_kick_blue == 4'hB))
        ) /*&& (!punch1)*/&& (!startscreen) && (fighting) /*&&(!ending)*/ && (!deathL) && (kick1) )
        begin
                if (hitL_current != 1'b1)
                begin
                    Red = doppo_kick_red;
                    Green = doppo_kick_green;
                    Blue = doppo_kick_blue;
                end
                
                else 
                begin
                    Red = 4'hf;
                    Green = 4'h0;
                    Blue = 4'h0;
                end

        end

        
        else if (rect_on == 1'b1 && (!((doppo_block_red == 4'hE) && (doppo_block_green == 4'h4) && (doppo_block_blue == 4'hC))
            && (!punch1))&&(!startscreen) && (fighting) && (!deathL) && (block1) && (!kick1))

        begin
                if (hitL_current != 1'b1 && block_emptyL != 1'b1)
                begin
                    Red = doppo_block_red;
                    Green = doppo_block_green;
                    Blue = doppo_block_blue;
                end
                
                else if (hitL_current == 1'b1 && block_emptyL != 1'b1)
                begin
                    Red = doppo_block_red;
                    Green = doppo_block_green;
                    Blue = doppo_block_blue;
                end
                
                else if (hitL_current == 1'b1 && block_emptyL ==  1'b1)
                begin
                    Red = 4'hf;
                    Green = 4'h0;
                    Blue = 4'h0;
                end
                
                else
                begin
                    Red = doppo_block_red;
                    Green = doppo_block_green;
                    Blue = doppo_block_blue;
                end
              
                
              

        end
        
        
        
         else if (rect_on == 1'b1 && !((doppo_dead_red == 4'hE) && (doppo_dead_green == 4'h4) && (doppo_dead_blue == 4'hD))
        && !((doppo_dead_red == 4'hA) && (doppo_dead_green == 4'h4) && (doppo_dead_blue == 4'h9)) && (!startscreen) && (deathL))
                begin          
                    Red = doppo_dead_red;
                    Green = doppo_dead_green;
                    Blue = doppo_dead_blue;
                end
                

        

        
           else if (rect_on2 == 1'b1 && (!((baki_red == 4'hF) && (baki_green == 4'h2) && (baki_blue == 4'hC)) 
                   && !((baki_red == 4'hD) && (baki_green == 4'h5) && (baki_blue == 4'hB)) 
                   && !((baki_red == 4'hB) && (baki_green == 4'h2) && (baki_blue == 4'h9)) 
                   && !((baki_red == 4'hF) && (baki_green == 4'h1) && (baki_blue == 4'hD))
                   && !((baki_red == 4'h0) && (baki_green == 4'hF) && (baki_blue == 4'h0))
                   && !((baki_red == 4'h5) && (baki_green == 4'hA) && (baki_blue == 4'h1))
                   && !((baki_red == 4'hF) && (baki_green == 4'h0) && (baki_blue == 4'hF))
                   && !((baki_red == 4'hA) && (baki_green == 4'h1) && (baki_blue == 4'hA)) ) 
                   && (Rect2Y+Rect2HeightDown == Rect_Y_Max) && (!punch)&& (!startscreen) && (fighting) 
                   && (!deathR) && (!kick) && (!block) /*&&(!ending)*/ )
         begin
                if (hitR_current != 1'b1)
                begin
                    Red = baki_red;
                    Green = baki_green;
                    Blue = baki_blue;
                end
                
                else 
                begin
                    Red = 4'hf;
                    Green = 4'h0;
                    Blue = 4'h0;
                end
         end

            else if (rect_on2 == 1'b1 && (!((baki_jump_red == 4'hF) && (baki_jump_green == 4'h3) && (baki_jump_blue == 4'hD))
         && !((baki_jump_red == 4'hB) && (baki_jump_green == 4'h4) && (baki_jump_blue == 4'h9)) 
         && (Rect2Y+Rect2HeightDown < Rect_Y_Max) 
         && (!punch))&& (!startscreen) && (fighting)  && (!deathR) && (!kick) && (!block)/*&&(!ending)*/)  
         begin
                if (hitR_current != 1'b1)
                begin
                    Red = baki_jump_red;
                    Green = baki_jump_green;
                    Blue = baki_jump_blue;
                end
                
                else
                begin
                    Red = 4'hf;
                    Green = 4'h0;
                    Blue = 4'h0;
                end
         end
         
         
         else if (rect_on2 == 1'b1 && (!((baki_punch_red == 4'hE) && (baki_punch_green == 4'h4) && (baki_punch_blue == 4'hD))
      //   && !((baki_punch_red == 4'hA) && (baki_punch_green == 4'h5) && (baki_punch_blue == 4'h9)) 
         && (punch))&& (!startscreen) && (fighting)  && (!deathR) && (!deathL)/*&&(!ending)*/&& (!kick))  
         begin
                if (hitR_current != 1'b1)
                begin
                    Red = baki_punch_red;
                    Green = baki_punch_green;
                    Blue = baki_punch_blue;
                end
                
                else 
                begin
                    Red = 4'hf;
                    Green = 4'h0;
                    Blue = 4'h0;
                end
         end
         
         else if (rect_on2 == 1'b1 && (!((baki_kick_red == 4'hF) && (baki_kick_green == 4'h3) && (baki_kick_blue == 4'hD))
         /*&& (!punch)*/)&& (!startscreen) && (fighting)  && (!deathR) && (!deathL)/*&&(!ending)*/ && (kick))  
         begin
                if (hitR_current != 1'b1)
                begin
                    Red = baki_kick_red;
                    Green = baki_kick_green;
                    Blue = baki_kick_blue;
                end
                
                else 
                begin
                    Red = 4'hf;
                    Green = 4'h0;
                    Blue = 4'h0;
                end
         end
         
        else if (rect_on2 == 1'b1 && (!((baki_block_red == 4'hF) && (baki_block_green == 4'h0) && (baki_block_blue == 4'hE)))
         && (!punch)&& (!startscreen) && (fighting)  && (!deathR)/*&&(!ending)*/ && (block) && (!kick))  
         begin   
                if (hitR_current != 1'b1 && block_emptyR != 1'b1)
                begin
                    Red = baki_block_red;
                    Green = baki_block_green;
                    Blue = baki_block_blue;
                end
                
                else if (hitR_current == 1'b1 && block_emptyR != 1'b1)
                begin
                    Red = baki_block_red;
                    Green = baki_block_green;
                    Blue = baki_block_blue;
                end
                
                else if (hitR_current == 1'b1 && block_emptyR ==  1'b1)
                begin
                    Red = 4'hf;
                    Green = 4'h0;
                    Blue = 4'h0;
                end
                
                else
                begin
                     Red = baki_block_red;
                    Green = baki_block_green;
                    Blue = baki_block_blue;
                end
         end


else if (rect_on2 == 1'b1 && (!((baki_dead_red == 4'hE) && (baki_dead_green == 4'h4) && (baki_dead_blue == 4'hD)))
            && (!startscreen) && (deathR))
      
                begin
                    Red = baki_dead_red;
                    Green = baki_dead_green;
                    Blue = baki_dead_blue;
                end
//else if (ending) begin
//if (( DrawY >= 195 && DrawY <= 285 && DrawX <= 200  && DrawX >= 440) && !((obg_red == 4'hF) && (obg_green == 4'h3) && (obg_blue == 4'hD))) 
// begin
    
//        Red = obg_red;//bg2_red;
//        Green = obg_green;//bg2_green;
//        Blue = obg_blue;//bg2_blue;

//    end
//end
//        else begin 
//            if (DrawY > 10'd420) begin
//                Red = 4'hf; 
//                Green = 4'h5;
//                Blue = 4'h0;
//            end
            else begin
           // if (!((bg_red == 4'hF) && (bg_green == 4'h3) && (bg_blue == 4'hD)))
           // begin
//                Red = wbg_red; 
//                Green = wbg_green;
//                Blue = wbg_blue;
                Red = bg_red;
                Green = bg_green;
                Blue = bg_blue;
              //  end
            end      
        end
        
 
//    end 
endmodule
