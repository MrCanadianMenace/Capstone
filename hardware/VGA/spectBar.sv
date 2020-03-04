// task to draw spectrogram bars, given an initial position
task spectBar;
	input [10:0] xcur, ycur, xInit, yInit;
   output [7:0] r, g, b;
   output draw;
	reg [23:0] rgb;
	
	integer i = 0;
	integer j = 0;
	integer hMax = 828;
	integer vMax = 576;
	integer intensityValue = 0;
		for (i = 0; i < hMax; i = i + 18) begin
			for (j = 0; j < vMax; j = j + 18) begin
				if (xcur > xInit+i && xcur <= (xInit+i+18) && ycur > yInit+j && ycur <= (yInit+j+18)) begin
					if (intensityValue >= 0 && intensityValue <= 5)
						rgb = 24'h0000FF;
					else if (intensityValue > 5 && intensityValue <= 10)
						rgb = 24'h0033FF;
					else if (intensityValue > 10 && intensityValue <= 15)
						rgb = 24'h0066FF;
					else if (intensityValue > 15 && intensityValue <= 20)
						rgb = 24'h0099FF;
					else if (intensityValue > 20 && intensityValue <= 25)
						rgb = 24'h00CCFF;
					else if (intensityValue > 25 && intensityValue <= 30)
						rgb = 24'h00FFCC;
					else if (intensityValue > 30 && intensityValue <= 35)
						rgb = 24'h00FF99;
					else if (intensityValue > 35 && intensityValue <= 40)
						rgb = 24'h00FF66;
					else if (intensityValue > 40 && intensityValue <= 45)
						rgb = 24'h00FF33;
					else if (intensityValue > 45 && intensityValue <= 50)
						rgb = 24'h00FF00;
					else if (intensityValue > 50 && intensityValue <= 55)
						rgb = 24'h00FF00;
					else if (intensityValue > 55 && intensityValue <= 60)
						rgb = 24'h33FF00;
					else if (intensityValue > 60 && intensityValue <= 65)
						rgb = 24'h66FF00;
					else if (intensityValue > 65 && intensityValue <= 70)
						rgb = 24'h99FF00;
					else if (intensityValue > 70 && intensityValue <= 75)
						rgb = 24'hCCFF00;
					else if (intensityValue > 75 && intensityValue <= 80)
						rgb = 24'hFFCC00;
					else if (intensityValue > 80 && intensityValue <= 85)
						rgb = 24'hFF9900;
					else if (intensityValue > 85 && intensityValue <= 90)
						rgb = 24'hFF6600;
					else if (intensityValue > 90 && intensityValue <= 95)
						rgb = 24'hFF3300;
					else if (intensityValue > 95 && intensityValue <= 100)
						rgb = 24'hFF0000;
					else
						rgb = 24'h000000;
					r = rgb[23:16];
					g = rgb[15:8];
					b = rgb[7:0];
					draw = 1;
				end
				else
					draw = 0;
			end
		end
endtask
