//**********************************************************************
// Program name      : .pde
// Author            : Bryan Costanza (GitHub: TravelByRocket)
// Date created      : 20191114
// Purpose           : Automate the process of creating living folds, avoiding complexities of creating patterns with graphic design applications like Illustrator
// Revision History  : 
// 20191114 -- createa. basic lined pattern to laser cut
// 20191115 -- text for button shortcuts, 's' to save PDF, 
//**********************************************************************

import processing.pdf.*;

boolean recording = false; // true when drawing to screen is being saved to PDF
boolean showGuides = true;

int pageMargin;
int structureHeight;

int colWidth = 80;
int rowHeight = 10;
int colPadding = 10;
int rowPadding = 10;

// Settings for making Beziers
float anchorWeightTips = 0.6; // distance factor from anchor to place control point, multipled by colWidth
float anchorWeightCenter = 0.7; //

String cutShape = "line";

void settings() {
	int pageHeightPx = 800; // use most of height of screen
	// int pageWidthPx = 800*11/17; // use height that is scaled to screen to determine width based on 11x17 (tabloid) size
	int pageWidthPx = 520; // use height that is scaled to screen to determine width based on 11x17 (tabloid) size
  size(pageWidthPx,pageHeightPx);
}

void setup() {
  pageMargin = height/40;
  structureHeight = 4 * pageMargin;
}

void draw() {
	background(255);

  noFill();

  int cols = (width - (2 * pageMargin))/(colWidth  + (2 * colPadding)) + 2; // add 2 to bleed on left and right
  int rows = (height - (2 * (pageMargin + structureHeight)))/(rowHeight + (2 * rowPadding));

  // println("cols: "+cols);
  // println("rows: "+rows);

  for (int col = 0; col < cols; ++col) {
  	for (int row = 0; row < rows; ++row) {

		  int x0 = - pageMargin + col * (colWidth  + 2 * colPadding);
		  int y0 = pageMargin + structureHeight + row * (rowHeight + 2 * rowPadding) + (((rowHeight + 2 * rowPadding)/2) * (col % 2));

		  brickOutline(x0,y0,x0+colWidth,y0+rowHeight);

		  stroke(#FF0000);
		  strokeWeight(0);
		  drawCutTrace(x0,y0);		  

		}
  }

  drawCutFrame();

  if(recording){
  	endRecord();
  	recording = false;
  }

  onScreenInstructions();

  delay(40);
}


class Brick{
	int brickWidth;
	int brickHeight;
	int brickPadLeft;
	int brickPadRight;
	int brickPadTop;
	int brickPadBottom;

	int brickUpperLeftX;
	int brickUpperLeftY;
	int brickBottomRightX;
	int brickBottomRightY;
}

void brickLines(){


}

void keyPressed(){
	if(key == 's'){
		drawWithPdfRecord();
	}
	if(key == 'g'){
		showGuides = !showGuides;
	}
	if(keyCode == UP){
		rowPadding--;
	}
	if(keyCode == DOWN){
		rowPadding++;
	}	
	if(keyCode == LEFT){
		colPadding--;
	}
	if(keyCode == RIGHT){
		colPadding++;
	}
	if(key == 'l'){
		cutShape = "line";
	}
	if(key == 'k'){
		cutShape = "bezier1";
	}
	if(key == 'e'){
		anchorWeightTips -= 0.1;
	}
	if(key == 'r'){
		anchorWeightTips += 0.1;
	}
	if(key == 'd'){
		anchorWeightCenter -= 0.1;
	}
	if(key == 'f'){
		anchorWeightCenter += 0.1;
	}
}

String dateTimeCode(){
	// return nf(day(),2) + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
	return str(year()).substring(2,4) + nf(month(),2) + nf(day(),2) + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
}

void drawWithPdfRecord(){
	recording = true;
	beginRecord(PDF, "saved/output" + dateTimeCode() + ".pdf");
	draw();
}

void onScreenInstructions(){
  noStroke();
  fill(75);
  textAlign(LEFT,BOTTOM);
  String infoText = "PadLeft = PadRight = " + colPadding + "\n" + 
  	  						  "PadTop = PadBottom = " + rowPadding + "\n" + 
  	  						  "anchorWeightCenter = " + anchorWeightCenter + "\n" +  
  	  						  "anchorWeightTips = " + anchorWeightTips + "\n" + 
  	  						  "'g' to toggle guides" + "\n" + 
  	   							"'s' to save PDF" + "\n" + 
  	   							"'l' for line cut" + "\n" + 
  	   							"'k' for bezier cut";
  text(infoText, 10, height - 10);
}

void brickOutline(int a, int b, int c, int d){
	if (showGuides) {
		noFill();
		stroke(150, 20, 250);
		strokeWeight(0);
		rectMode(CORNERS);
		rect(a,b,c,d);
	}
	
}

void drawCutFrame(){
	noFill();
	strokeWeight(0);
	stroke(#FF0000);

	
	line(        pageMargin,     pageMargin, width - pageMargin,              pageMargin);
	
	// the bottom part of the top structure is not cut
	pushStyle();
	stroke(#99FFFF);
	line(				 pageMargin, (structureHeight + pageMargin), width - pageMargin,          (structureHeight + pageMargin));
	popStyle();
	
	line(				 pageMargin,     pageMargin,         pageMargin, height - (structureHeight + pageMargin));
	line(width - pageMargin,     pageMargin, width - pageMargin, height - (structureHeight + pageMargin));
	ellipse((structureHeight + pageMargin), 3 * pageMargin, 2 * pageMargin, 2 * pageMargin);
	ellipse(width/2, 3 * pageMargin, 2 * pageMargin, 2 * pageMargin);
	ellipse(width - (structureHeight + pageMargin), 3 * pageMargin, 2 * pageMargin, 2 * pageMargin);
	arc(width/2, height - (structureHeight + pageMargin), width - 2 * pageMargin, 8 * pageMargin, 0, PI); // arc(x, y, width, height, start, stop);
}

void drawCutTrace(int x0, int y0){
	switch (cutShape) {
		case "line" :
			int lineStartX = x0;
		  int lineStartY = y0 + rowHeight/2;

		  int lineEndX = x0 + colWidth;
		  int lineEndY = lineStartY;

		  line(lineStartX,lineStartY,lineEndX,lineEndY);
		break;	
		case "bezier1" :			
			pushMatrix();
			translate(x0,y0);
			
			// beginShape();
			
			bezier(0, 0, colWidth * anchorWeightTips, 0, colWidth/2 - (colWidth * anchorWeightCenter), rowHeight, colWidth/2, rowHeight);
			bezier(colWidth/2, rowHeight, colWidth/2 + (colWidth * anchorWeightCenter), rowHeight, colWidth * (1 - anchorWeightTips), 0, colWidth, 0);
			// bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2);
			// endShape();

			popMatrix();
		break;	
	}

	
}
			