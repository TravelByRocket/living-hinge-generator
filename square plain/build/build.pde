//**********************************************************************
// Program name      : .pde
// Author            : Bryan Costanza (GitHub: TravelByRocket)
// Date created      : 20191114
// Purpose           : Automate the process of creating living folds, avoiding complexities of creating patterns with graphic design applications like Illustrator
//**********************************************************************

import processing.pdf.*;

/////////////////////////////
// GLOBAL VARS //////////////
/////////////////////////////

boolean willRecord = false;
boolean recording = false; // true when drawing to screen is being saved to PDF
boolean showGuides = true;
boolean showHelp = true;
int curStrokeWeight = 1;
String patterns[] = {"line","bezier1","custom1","custom2"};
int curPattern = 0;

PFont rajdani;
HingeArea hingeArea;
color grayTrace;

// Settings for making Beziers
float anchorWeightTips = 0.6; // distance factor from anchor to place control point, multipled by cellWidth
float anchorWeightCenter = 0.7; //

String cutShape = "line";

/////////////////////////////
// SETTINGS /////////////////
/////////////////////////////

int pageHeightPx = 600;
int pageWidthPx = 600;
int pageMarginPx = 100;
void settings() {
	size(pageWidthPx,pageHeightPx);
}

/////////////////////////////
// SETUP ////////////////////
/////////////////////////////

void setup() {
	hingeArea = new HingeArea(pageMarginPx,pageMarginPx,pageWidthPx - pageMarginPx,pageHeightPx - pageMarginPx,"line",50,25,10,10);
	rajdani = loadFont("Rajdhani-Regular-14.vlw");
	textFont(rajdani);
	grayTrace = color(200);
}

/////////////////////////////
// DRAW /////////////////////
/////////////////////////////

void draw() {
	background(255);
	
	if(willRecord){
		recording = true;
		beginRecord(PDF, "saved/output" + dateTimeCode() + ".pdf");
		curStrokeWeight = 0;
	}

	hingeArea.draw();
	onScreenInstructions();

  if(recording){
  	endRecord();
  	recording = false;
  	willRecord = false;
  	curStrokeWeight = 1;
  }


  delay(40);
}

class HingeArea{
	int cols;
	int rows;
	Cell cell;
	int x0,y0,x1,y1;
	int cellWidth,cellHeight;
	int cellPaddingH,cellPaddingV;

	HingeArea(int _x0, int _y0, int _x1, int _y1, String _cutShape, int _cellWidth, int _cellHeight, int _cellPaddingH, int _cellPaddingV){
	  x0 = _x0;
	  y0 = _y0;
	  x1 = _x1;
	  y1 = _y1;

	  cellWidth = _cellWidth;
	  cellHeight = _cellHeight;
	  cellPaddingH = _cellPaddingH;
	  cellPaddingV = _cellPaddingV;

		cell = new Cell(_cutShape);
	}

	void draw(){
		makeOutline(x0,y0,x1,y1);

		cols = ((x1 - x0) + cellWidth) / (cellWidth + (2 * cellPaddingH)) + 1; // will round down so add 1 and trim with later IF check
	  rows = ((y1 - y0) + cellHeight) / (cellHeight + (2 * cellPaddingV)) + 1; // will round down so add 1 and trim with later IF check

	  for (int col = 0; col < cols; ++col) {
	  	for (int row = 0; row < rows; ++row) {

	  		int x0cellTopLeft = (x0 - (cellWidth / 2));
	  		int x0cellColOffset = col * (cellWidth + (2 * cellPaddingH));
	  		int x0cell = x0cellTopLeft + x0cellColOffset;
			  
			  int y0cellTopLeft = y0;
	  		int y0cellRowOffset = row * (cellHeight + (2 * cellPaddingV)) + ((cellHeight + (2 * cellPaddingV)) / 2) * (col % 2);
	  		int y0cell = y0cellTopLeft + y0cellRowOffset;

	  		if(x0cell < x1 && y0cell < y1){ // the rows and cols calcs are sometimes too generous so don't call draw if outside of hinge area
	  			cell.draw(x0cell, y0cell, cellWidth, cellHeight);
		  		drawCutTrace(x0cell,y0cell);
	  		}  
			}
	  }
	}

	// ADJUST PADDING
	void decreasePaddingH(){
		cellPaddingH--;
	}
	void increasePaddingH(){
		cellPaddingH++;
	}
	void decreasePaddingV(){
		cellPaddingV--;
	}
	void increasePaddingV(){
		cellPaddingV++;
	}

	// ADJUST CELL SIZE
	void decreaseCellHeight(){
		cellHeight--;
	}
	void increaseCellHeight(){
		cellHeight++;
	}
	void decreaseCellWidth(){
		cellWidth--;
	}
	void increaseCellWidth(){
		cellWidth++;
	}


}

class Cell{

	Cell(String cutShape){

	}

	void draw(int _x0, int _y0, int _cellWidth, int _cellHeight){
		makeOutline(_x0, _y0, _x0 + _cellWidth, _y0 + _cellHeight);
	}


}


boolean holdingShift = false;
void keyPressed(){
	if(key == 's'){
		willRecord = true;
	}
	if(key == 'g'){
		showGuides = !showGuides;
	}
	if(key == 'l'){
		curPattern = (curPattern + 1) % 4;
		cutShape = patterns[curPattern];
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
	if(key == 'h'){
		showHelp = !showHelp;
	}

	if(keyCode == SHIFT){
		holdingShift = true;
	}

	if(holdingShift){
		if(keyCode == UP){
			hingeArea.decreaseCellHeight();
		}
		if(keyCode == DOWN){
			hingeArea.increaseCellHeight();
		}	
		if(keyCode == LEFT){
			hingeArea.decreaseCellWidth();
		}
		if(keyCode == RIGHT){
			hingeArea.increaseCellWidth();
		}
	} else {
		if(keyCode == UP){
			hingeArea.decreasePaddingV();
		}
		if(keyCode == DOWN){
			hingeArea.increasePaddingV();
		}	
		if(keyCode == LEFT){
			hingeArea.decreasePaddingH();
		}
		if(keyCode == RIGHT){
			hingeArea.increasePaddingH();
		}
	}
	
}

void keyReleased(){
	if(keyCode == SHIFT){
		holdingShift = false;
	}
}

String dateTimeCode(){
	return str(year()).substring(2,4) + nf(month(),2) + nf(day(),2) + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
}

void onScreenInstructions(){
	if(showHelp){
		noStroke();
	  fill(100);
	  textAlign(LEFT,BOTTOM);
	  String infoText = "cellPaddingH = " + hingeArea.cellPaddingH + "\n" + 
	  	  						  "cellPaddingV = " + hingeArea.cellPaddingV + "\n" + 
	  	  						  "cellWidth = " + hingeArea.cellWidth + "\n" + 
	  	  						  "cellHeight = " + hingeArea.cellHeight + "\n" + 
	  	  						  // "anchorWeightCenter = " + anchorWeightCenter + "\n" +  
	  	  						  // "anchorWeightTips = " + anchorWeightTips + "\n" + 
	  	  						  "'g' to toggle guides" + "\n" + 
	  	   							"'h' to toggle help" + "\n" + 
	  	   							"'s' to save PDF" + "\n" + 
	  	   							"'l' to cycle patterns";
	  text(infoText, 10, height - 10);
	}
}

void makeOutline(int _x0, int _y0, int _x1, int _y1){
	if (showGuides) {
		noFill();
		strokeWeight(curStrokeWeight);
		stroke(grayTrace);
		rectMode(CORNERS);
		rect(_x0,_y0,_x1,_y1);
	}
}

void drawCutTrace(int x0, int y0){
	noFill();
	strokeWeight(curStrokeWeight);
	stroke(#FF0000);
	switch (cutShape) {
		case "line" :
			int lineStartX = x0;
		  int lineStartY = y0 + hingeArea.cellHeight/2;

		  int lineEndX = x0 + hingeArea.cellWidth;
		  int lineEndY = lineStartY;

		  line(lineStartX,lineStartY,lineEndX,lineEndY);
		break;
		case "bezier1" :			
			pushMatrix();
			translate(x0,y0);
			
			bezier(0, 0, hingeArea.cellWidth * anchorWeightTips, 0, hingeArea.cellWidth/2 - (hingeArea.cellWidth * anchorWeightCenter), hingeArea.cellHeight, hingeArea.cellWidth/2, hingeArea.cellHeight);
			bezier(hingeArea.cellWidth/2, hingeArea.cellHeight, hingeArea.cellWidth/2 + (hingeArea.cellWidth * anchorWeightCenter), hingeArea.cellHeight, hingeArea.cellWidth * (1 - anchorWeightTips), 0, hingeArea.cellWidth, 0);

			popMatrix();
		break;
		case "custom1" :			
			pushMatrix();
			translate(x0,y0);
			
			line(0, hingeArea.cellHeight, hingeArea.cellWidth/2, 0);
			line(hingeArea.cellWidth/2, 0, hingeArea.cellWidth, hingeArea.cellHeight);

			popMatrix();
		break;
		case "custom2" :			
			pushMatrix();
			translate(x0,y0);
			
			line(0, hingeArea.cellHeight, hingeArea.cellWidth, 0);

			popMatrix();
		break;
	}
}