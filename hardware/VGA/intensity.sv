// task to assign colour values to different intensites

task colormap;
      input [6:0] intensityValue;
      output [23:0] rgb;
		
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
endtask
