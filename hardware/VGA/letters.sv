// task to draw letters, given an initial position

task letters;
      input [10:0] xcur, ycur, xpos, ypos;
		input [8*1:1] letter;
      output draw;
      if (letter == "a") begin
			if (xcur == xpos+6 && ycur == ypos) begin
				draw = 1;
			end
			else if (xcur > xpos+4 && xcur < xpos+8 && ycur == ypos+1) begin
				draw = 1;
			end
			else if (xcur > xpos+4 && xcur < xpos+8 && ycur == ypos+2) begin
				draw = 1;
			end
			else if ((xcur == xpos+4 && ycur == ypos+3) ||  (xcur > xpos+5 && xcur < xpos+8 && ycur == ypos+3)) begin
				draw = 1;
			end
			else if ((xcur == xpos+4 && ycur == ypos+4) ||  (xcur > xpos+6 && xcur < xpos+9 && ycur == ypos+4)) begin
				draw = 1;
			end
			else if ((xcur == xpos+4 && ycur == ypos+5) ||  (xcur > xpos+6 && xcur < xpos+9 && ycur == ypos+5)) begin
				draw = 1;
			end
			else if ((xcur == xpos+3 && ycur == ypos+6) ||  (xcur > xpos+6 && xcur < xpos+9 && ycur == ypos+6)) begin
				draw = 1;
			end
			else if (xcur > xpos+2 && xcur < xpos+10 && ycur == ypos+7) begin
				draw = 1;
			end
			else if ((xcur == xpos+2 && ycur == ypos+8) ||  (xcur > xpos+7 && xcur < xpos+10 && ycur == ypos+8)) begin
				draw = 1;
			end
			else if ((xcur == xpos+2 && ycur == ypos+9) ||  (xcur > xpos+7 && xcur < xpos+10 && ycur == ypos+9)) begin
				draw = 1;
			end
			else if ((xcur > xpos && xcur < xpos+3 && ycur == ypos+10) ||  (xcur > xpos+7 && xcur < xpos+11 && ycur == ypos+10)) begin
				draw = 1;
			end
			else if ((xcur > xpos-1 && xcur < xpos+4 && ycur == ypos+11) ||  (xcur > xpos+6 && xcur < xpos+12 && ycur == ypos+11)) begin
				draw = 1;
			end
			else
				draw = 0;
		end
endtask

