//**********************************************************************
// Author            : Bryan Costanza (GitHub: TravelByRocket)
// Date created      : 20191114
// Purpose           : Create custom living hinges by defining an area and pattern; modify spacing with the keyboard, define shapes in the code
//**********************************************************************

import processing.pdf.*;

/////////////////////////////
// GLOBAL VARS //////////////
/////////////////////////////

boolean willRecord = false; // switches on pressing 's' and done in this way to avoid (a)synchrony issues
boolean recording = false; // true when drawing to screen is being saved to PDF
boolean showHelp = true;
boolean showInfo = true;
int curStrokeWeight = 1;
String patterns[] = {"line","bezier1","custom1","custom2"};
int curPattern = 0;

PFont rajdani;
HingeArea hingeArea;

int cellWidth = 50;
int cellHeight = 25;
int cellPaddingH = 10;
int cellPaddingV = 10;

// generic parameters adjusted down/up with q/w, e/r, and t/y keys; adjusts by 0.1 for each key press
float genericParameterA = 0.7; // 
float genericParameterB = 0.7; //
float genericParameterC = 0.7; //

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
	// hingeArea = new HingeArea(pageMarginPx,pageMarginPx,pageWidthPx - pageMarginPx,pageHeightPx - pageMarginPx,cutShape,cellHeight,cellWidth,cellPaddingH,cellPaddingV);
	hingeArea = new HingeArea();
	hingeArea.areaCoords(pageMarginPx,pageMarginPx,pageWidthPx - pageMarginPx,pageHeightPx - pageMarginPx);
	hingeArea.cellGeometry(cellHeight,cellWidth,cellPaddingH,cellPaddingV);

	rajdani = loadFont("Rajdhani-Regular-14.vlw");
	textFont(rajdani);
}

/////////////////////////////
// DRAW /////////////////////
/////////////////////////////

void draw() {
	background(255);
	
	if(willRecord){
		recording = true;
		beginRecord(PDF, "saved/output" + dateTimeCode() + ".pdf");
		curStrokeWeight = 0; // reduce to hairline for the one recording frame
	}

	strokeWeight(curStrokeWeight);
	stroke(#FF0000); // the outlines and text will not be affected by this
	noFill();

	hingeArea.cellGeometry(cellWidth,cellHeight,cellPaddingH,cellPaddingV);
	hingeArea.draw();

	onScreenInfo();

	if(recording){
		endRecord();
		recording = false;
		willRecord = false;
		curStrokeWeight = 1;
	}

	onScreenHelp();

	delay(40);
}

boolean holdingShift = false;
void keyPressed(){
	if(key == 's'){
		willRecord = true;
	}
	if(key == 'o'){
		hingeArea.outlineToggle();
	}
	if(key == 'l'){
		curPattern = (curPattern + 1) % 4;
		cutShape = patterns[curPattern];
		hingeArea.cutShape(cutShape);
	}
	if(key == 'q'){
		genericParameterA -= 0.1;
	}
	if(key == 'w'){
		genericParameterA += 0.1;
	}
	if(key == 'e'){
		genericParameterB -= 0.1;
	}
	if(key == 'r'){
		genericParameterB += 0.1;
	}
	if(key == 't'){
		genericParameterC -= 0.1;
	}
	if(key == 'y'){
		genericParameterC += 0.1;
	}
	if(key == 'h'){
		showHelp = !showHelp;
	}
	if(key == 'i'){
		showInfo = !showInfo;
	}
	if(key == 'z'){
		hingeArea.areaCoords(200,200,400,400);
	}

	if(keyCode == SHIFT){
		holdingShift = true;
	}

	if(holdingShift){
		if(keyCode == UP){
			decreaseCellHeight();
		}
		if(keyCode == DOWN){
			increaseCellHeight();
		}	
		if(keyCode == LEFT){
			decreaseCellWidth();
		}
		if(keyCode == RIGHT){
			increaseCellWidth();
		}
	} else {
		if(keyCode == UP){
			decreasePaddingV();
		}
		if(keyCode == DOWN){
			increasePaddingV();
		}	
		if(keyCode == LEFT){
			decreasePaddingH();
		}
		if(keyCode == RIGHT){
			increasePaddingH();
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

void onScreenInfo(){
	if(showInfo){
		noStroke();
		fill(100);
		textAlign(LEFT,BOTTOM);
		String infoText = "cellWidth = " + cellWidth + "\n" + 
											"cellHeight = " + cellHeight + "\n" +
											"cellPaddingH = " + cellPaddingH + "\n" + 
											"cellPaddingV = " + cellPaddingV;

											// "anchorWeightCenter = " + anchorWeightCenter + "\n" +  
											// "anchorWeightTips = " + anchorWeightTips + "\n" +

		text(infoText, 10, height - 10);
	}
}

void onScreenHelp(){
	if(showHelp){
		noStroke();
		fill(100);
		textAlign(RIGHT,BOTTOM);
		String helpText = "'o' to toggle outlines" + "\n" + 
											"'h' to toggle help" + "\n" + 
											"'i' to toggle info" + "\n" + 
											"'s' to save PDF" + "\n" + 
											"'l' to cycle patterns";
		text(helpText, width - 10, height - 10);
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
