// task to draw a square, given an initial position

task square;
      input [10:0] xcur, ycur, xInit, yInit, xEnd, yEnd;
      output draw;
      
      if (xcur > xInit && xcur < (xInit+(xEnd-xInit)) && ycur > yInit && ycur < (yInit+(yEnd-yInit))) begin
         draw = 1;
      end
      else
         draw = 0;
endtask
