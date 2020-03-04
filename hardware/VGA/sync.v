// 1024 x 768 @ 60Hz (current monitor, different monitors will have different values)
// horizontal:    front porch 24
//                sync pulse 136
//                back porch 160
//						visible area 1024
//                whole line 1344
//
// vertical:      front porch 3
//                sync pulse 6
//                back porch 29
//						visible area 768
//                whole frame 806

module sync(CLK, HSYNC, VSYNC, R, G, B, KEY, SW);

   `include "sq.sv" // for drawing squares and rectangles
	`include "letters.sv" // for drawing letters (WIP)
	`include "spectBar.sv" // for drawing spectrogram bars
   
   input CLK;						// clock
   input [3:0] KEY;				// 4 buttons on the de2-115 board
   input [17:0] SW;				// 18 Switches on the de2-115
   output HSYNC, VSYNC;			// Horizontal and Vertical synchronization
   output [7:0] R, G, B;      // 8 bits for the de2-115
   
   reg hsync_out, vsync_out, border, graphBG, spect;
	reg [7:0] r_out, g_out, b_out, r, g, b;
	reg [10:0] hpos = 0; //current horizontal position
   reg [10:0] vpos = 0; //current vertical position
   
   always@(posedge CLK) begin
   
      square(hpos, vpos, 320, 38, 1344, 806, border);
		square(hpos, vpos, 416, 134, 1244, 710, graphBG);
		spectBar(hpos, vpos, 416, 134, r, g, b, spect);
		
      if (border == 1) begin
			r_out = 'd 79;
         g_out = 'd 38;
         b_out = 'd 131;
      end
		if (graphBG == 1) begin
			r_out = 'd 64;
         g_out = 'd 63;
         b_out = 'd 65;
      end
		if (spect == 1) begin
			r_out = r;
         g_out = g;
         b_out = b;
      end
		
      if (hpos < 1344)        // whole line
         hpos = hpos + 1;
      else begin
         hpos = 0;
         if (vpos < 806)      // whole frame
            vpos = vpos + 1;
         else begin     
            vpos = 0;
            // position updates happen here, upon frame reset
         end
      end
      
      if (hpos > 24 && hpos < 160)  // horizontal sync during sync pulse time
         hsync_out = 0;             // pulse low
      else
         hsync_out = 1;
        
      if (vpos > 3 && vpos < 29)     // vertical sync
         vsync_out = 0;
      else
         vsync_out = 1;
   
      if ( (hpos > 0 && hpos < 320) || (vpos > 0 && vpos < 38)) begin
         r_out = 0;
         g_out = 0;     // output all zero during fp, sync, and bp
         b_out = 0;
      end
   
   end   // end always

   assign HSYNC = hsync_out;
   assign VSYNC = vsync_out;
   assign R = r_out;
   assign G = g_out;
   assign B = b_out;

endmodule
