//**********************************************************************
// Author            : Bryan Costanza (GitHub: TravelByRocket)
// Date created      : 20191114
// Purpose           : Create custom living hinges by defining an area and pattern; modify spacing with the keyboard, define shapes in the code
//**********************************************************************

// CONSTRUCTORS
// HingeArea()
// HingeArea(int x0, int y0, int x1, int y1)
// HingeArea(int x0, int y0, int x1, int y1, String cutShape, int cellWidth, int cellHeight, int cellPaddingH, int cellPaddingV)

// METHODS
// draw();
// cellGeometry(int theWidth, int theHeight, int thePadH, int thePadV)
// areaCoords(int x0, int y0, int x1, int y1)
// cutShape(String theShape)
// outlineToggle()
// outlineShow()
// outlineHide()
// outlineColor(color theColor) // not yet implemented

class HingeArea{
	int cols; // calculated for every draw()
	int rows; // calculated for every draw()
	int x0 = width/4;
	int y0 = height/4;
	int x1 = width*3/4;
	int y1 = height*3/4;
	int cellWidth = width/10;
	int cellHeight = height/20;
	int cellPaddingH = width/40;
	int cellPaddingV = height/40;
	boolean showOutlines = true;
	String cutShape = "line";

	// Constructor may be called with no arguments to use default values
	HingeArea(){
		// defaults are defined above
	}

	// HingeArea often will not move so the defaults location can be overridden in the constructor
	HingeArea(int _x0, int _y0, int _x1, int _y1){
		x0 = _x0;
		y0 = _y0;
		x1 = _x1;
		y1 = _y1;
	}

	// HingeArea can be called with a constructor that sets all fields at once
	HingeArea(int _x0, int _y0, int _x1, int _y1, String _cutShape, int _cellWidth, int _cellHeight, int _cellPaddingH, int _cellPaddingV){
		x0 = _x0;
		y0 = _y0;
		x1 = _x1;
		y1 = _y1;

		cellWidth = _cellWidth;
		cellHeight = _cellHeight;
		cellPaddingH = _cellPaddingH;
		cellPaddingV = _cellPaddingV;

		cutShape = _cutShape;
	}

	void draw(){
		if(showOutlines){
			makeOutline(x0,y0,x1,y1);
		}

		// Determine rows and columns of cuts to make based on current geometry
		cols = ((x1 - x0) + cellWidth) / (cellWidth + (2 * cellPaddingH)) + 1; // will round down so add 1 and trim with later IF check
		rows = ((y1 - y0) + cellHeight) / (cellHeight + (2 * cellPaddingV)) + 1; // will round down so add 1 and trim with later IF check

		// run through each column and each row to place a cell in every needed location
		for (int col = 0; col < cols; ++col) {
			for (int row = 0; row < rows; ++row) {

				// logic for X and Y is to find upper-left corner of upper-left cell and then use col- and row-based offsets
				int x0cellTopLeft = (x0 - (cellWidth / 2));
				int x0cellColOffset = col * (cellWidth + (2 * cellPaddingH));
				int x0cell = x0cellTopLeft + x0cellColOffset;
				
				int y0cellTopLeft = y0;
				int y0cellRowOffset = row * (cellHeight + (2 * cellPaddingV)) + ((cellHeight + (2 * cellPaddingV)) / 2) * (col % 2);
				int y0cell = y0cellTopLeft + y0cellRowOffset;

				if(x0cell < x1 && y0cell < y1){ // the rows and cols calcs are sometimes too generous so don't call draw if outside of hinge area
					drawTrace(x0cell,y0cell,cellWidth,cellHeight,cutShape);
					if (showOutlines) {
						makeOutline(x0cell, y0cell, x0cell + cellWidth, y0cell + cellHeight);
					}	
				}
			}
		}
	}

	void cellGeometry(int theWidth, int theHeight, int thePadH, int thePadV){
		cellWidth = theWidth;
		cellHeight = theHeight;
		cellPaddingH = thePadH;
		cellPaddingV = thePadV;	
	}

	void areaCoords(int _x0, int _y0, int _x1, int _y1){
		x0 = _x0;
		y0 = _y0;
		x1 = _x1;
		y1 = _y1;
	}

	void cutShape(String _cutShape){
		cutShape = _cutShape;
	}
	
	// Manage Outline Display
	void outlineToggle(){
		showOutlines = !showOutlines;
	}

	void outlineShow(){
		showOutlines = true;
	}

	void outlineHide(){
		showOutlines = false;
	}

	void outlineColor(color theColor){
		// not yet implemented
	}
}

void drawTrace(int x0, int y0, int cellWidth, int cellHeight, String theCutShape){
	pushMatrix();
	translate(x0,y0); // move the matrix so that dimensions here can be relative just like for the canvas
	// the extents of the cell will be (0,0) in the upper-left corner and (cellWidth,cellHeight) in the bottom-right corner
	
	switch (theCutShape) {
		case "line" :
			line(0,cellHeight/2,cellWidth,cellHeight/2);
		break;
		case "bezier1" :
			float anchorWeightTips = genericParameterA; //distance factor from anchor to place control point
			float anchorWeightCenter = genericParameterB;
			
			bezier(0, 0, cellWidth * anchorWeightTips, 0, cellWidth/2 - (cellWidth * anchorWeightCenter), cellHeight, cellWidth/2, cellHeight);
			bezier(cellWidth/2, cellHeight, cellWidth/2 + (cellWidth * anchorWeightCenter), cellHeight, cellWidth * (1 - anchorWeightTips), 0, cellWidth, 0);
		break;
		case "custom1" :			
			line(0, cellHeight, cellWidth/2, 0);
			line(cellWidth/2, 0, cellWidth, cellHeight);
		break;
		case "custom2" :			
			line(0, cellHeight, cellWidth, 0);
		break;
	}
	popMatrix();
}

void makeOutline(int x0, int y0, int x1, int y1){
	pushStyle();
		noFill();
		strokeWeight(1);
		stroke(200);
		rectMode(CORNERS);
		rect(x0,y0,x1,y1);
	popStyle();
}