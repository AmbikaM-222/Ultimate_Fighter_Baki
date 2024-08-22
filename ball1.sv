//ambikam2, iren2

module ball_1 
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode, keycode2,    

    output logic signed [9:0]  RectX, 
    output logic signed [9:0]  RectY, 
    output logic signed [9:0]  RectL, RectR,
    output logic signed [9:0]  RectU, RectD,
    
    output logic [9:0] motionx1,
    
    input logic  deathL,
    input logic deathR,
    input logic startscreen,
    
    output logic punch_flag1,
    output logic kick_flag1,
    output logic block_flag1,
   
    input logic [9:0]   Rect2X, 
                        Rect2Y, 
                        Rect2L, Rect2R, 
                        Rect2U, Rect2D
);
    
    parameter [9:0] Rect_X_Center = 150;
    parameter [9:0] Rect_Y_Center = 420 - 60; 
    parameter [9:0] Rect_X_Min = 3;     
    parameter [9:0] Rect_X_Max = 549;
    parameter [9:0] Rect_Y_Min = 0;    
    parameter [9:0] Rect_Y_Max = 420;  
    parameter [9:0] Rect_X_Step = 2;      
    parameter [9:0] Rect_Y_Step = 1;    
    parameter [9:0] Attack_Step = 20; 

    logic [9:0] Rect_X_Motion;
    logic [9:0] Rect_X_Motion_next;
    logic [9:0] Rect_Y_Motion;
    logic [9:0] Rect_Y_Motion_next;

    logic [9:0] Rect_X_next;
    logic [9:0] Rect_Y_next;
    
    logic [9:0] g;
    assign g = 10'd3;
    
    logic rbound_flag;
    logic lbound_flag;
   
    logic right_bound;
    assign right_bound = (RectX + RectR) >= Rect_X_Max;  
    logic left_bound;
    assign left_bound = (RectX - RectL) <= Rect_X_Min;
    logic ground;
    assign ground = (RectY + RectD) >= Rect_Y_Max;
    
    logic p2_rbound_flag;
    logic p2_lbound_flag;
    logic p2_hbound_flag;
   
    logic [9:0] p2_right_bound;
    assign p2_right_bound = Rect2X + Rect2R;
    logic [9:0] p2_left_bound;
    assign p2_left_bound = Rect2X - Rect2L;
    logic [9:0] p2_height_bound;
    assign p2_height_bound = Rect2Y - Rect2U;
    logic [9:0] p2_feet_bound;
    assign p2_feet_bound = Rect2Y + Rect2D;
    
 
                        
    always_comb begin
        Rect_Y_Motion_next = Rect_Y_Motion + g;
        Rect_X_Motion_next = 10'd0;
        motionx1 = Rect_X_Motion;
        rbound_flag = 1'b0;
        lbound_flag = 1'b0;
        
        p2_rbound_flag = 1'b0;
        p2_lbound_flag = 1'b0;
        p2_hbound_flag = 1'b0;
        
        punch_flag1 = 1'b0;
        kick_flag1 = 1'b0;

        RectU = 90;
        RectD = 60;
        RectL = 45;  
        RectR = 45;

  
        
        if (ground) {
            Rect_Y_Motion_next = 10'd0;
        }

        if (left_bound) {
            Rect_X_Motion_next = 10'd0;
            lbound_flag = 1'b1;
        } else if (right_bound) {
            Rect_X_Motion_next = 10'd0;
            rbound_flag = 1'b1;
        }

        if ((RectX + RectR >= p2_left_bound) && (RectX + RectR <= p2_right_bound) && (RectY + RectD > p2_height_bound)) {
            Rect_X_Motion_next = (~ (Rect_X_Step) + 1'b1);
            p2_lbound_flag = 1'b1;
        }
                
        if (((RectX - RectL) <= p2_right_bound) && ((RectX - RectL) >= p2_left_bound) && (RectY + RectD > p2_height_bound)) {
            Rect_X_Motion_next = Rect_X_Step;
            p2_rbound_flag = 1'b1;
        }

        if ((keycode == 8'h1a || keycode2 == 8'h1a) && (ground) && (!deathL) && (!deathR) && (!startscreen)) { // Jump (W)
                       if (ground)
                Rect_Y_Motion_next = -10'd30;
        }
        
        if ((keycode == 8'h07 || keycode2 == 8'h07) && (rbound_flag != 1'b1) && (p2_lbound_flag != 1'b1) && (!deathL) && (!deathR) && (!startscreen)) { // Move Right(D)
            Rect_X_Motion_next = 10'd3;
        }
        if ((keycode == 8'h04 || keycode2 == 8'h04) && (lbound_flag != 1'b1) && (p2_rbound_flag != 1'b1) && (!deathL) && (!deathR) && (!startscreen)) { // Move Left (A)
            Rect_X_Motion_next = -10'd3;
        }
             
        if (((keycode == 8'h1a && keycode2 == 8'h07) || (keycode == 8'h07 && keycode2 == 8'h1a)) && (rbound_flag != 1'b1) && (p2_lbound_flag != 1'b1) && (!deathL) && (!deathR) && (!startscreen)) {
            Rect_X_Motion_next = 10'd3;
            if (ground)
                Rect_Y_Motion_next = -10'd30;
        }
        if (((keycode == 8'h1a && keycode2 == 8'h07) || (keycode == 8'h07 && keycode2 == 8'h1a)) && (rbound_flag == 1'b1) && (p2_lbound_flag != 1'b1) && (!deathL) && (!deathR) && (!startscreen)) {
            Rect_X_Motion_next = 10'd0;
            if (ground)
                Rect_Y_Motion_next = -10'd30;
        }
        if (((keycode == 8'h1a && keycode2 == 8'h04) || (keycode == 8'h04 && keycode2 == 8'h1a)) && (lbound_flag != 1'b1) && (p2_rbound_flag == 1'b1) && (!deathL) && (!deathR) && (!startscreen)) {
            Rect_X_Motion_next = -10'd3;
            if (ground)
                Rect_Y_Motion_next = -10'd30;
        }
        if (((keycode == 8'h1a && keycode2 == 8'h04) || (keycode == 8'h04 && keycode2 == 8'h1a)) && (lbound_flag == 1'b1) && (p2_rbound_flag == 1'b1) && (!deathL) && (!deathR) && (!startscreen)) {
            Rect_X_Motion_next = 10'd0;
            if (ground)
                Rect_Y_Motion_next = -10'd30;
        }

        if ((keycode == 8'h15 || keycode2 == 8'h15) && !(deathR || deathL) && (!startscreen) && (!kick_flag1)) {
            punch_flag1 = 1'b1;
        }
        
        if ((keycode == 8'h09 || keycode2 == 8'h09) && !(deathR || deathL) && (!startscreen)) {
            kick_flag1 = 1'b1;
        }

        if ((keycode == 8'h16 || keycode2 == 8'h16) && !(deathR || deathL) && (!startscreen)) {
            block_flag1 = 1'b1;
        }

        if (punch_flag1 || kick_flag1 || block_flag1) {
            Rect_X_Motion_next = 10'd0;
        }

        if (deathL || deathR || startscreen) {
            Rect_Y_Motion_next = 10'd0;
            Rect_X_Motion_next = 10'd0;
        }
    end 
           
    assign Rect_X_next = (RectX + Rect_X_Motion_next);
    assign Rect_Y_next = (RectY + Rect_Y_Motion_next);
   
    always_ff @(posedge frame_clk or posedge Reset)
    begin: Move_Rect
        if (Reset) begin 
            Rect_Y_Motion <= 10'd0;
			Rect_X_Motion <= 10'd0;
            
			RectY <= Rect_Y_Center;
			RectX <= Rect_X_Center;
        end else begin 
			Rect_Y_Motion <= Rect_Y_Motion_next; 
			Rect_X_Motion <= Rect_X_Motion_next; 

            RectY <= Rect_Y_next;  
            RectX <= Rect_X_next;
		end  
    end
endmodule
