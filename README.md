# Living Hinge Generation Tool
This tool was developed to rapidly design living hinge patterns. It is intended to be a simple but helpful tool in a way that I have not seen done elsewhere. There is a user interface that allows for selecting different patterns, cell sizes, and cell padding.

I have more discussion on the design process and use of the tool on my website: https://bryancostanza.com/#/living-hinge-design-tool/.

## Concept

### Pattern Spacing

The cut lines are all placed within a "cell" and each cell has horizontal padding and a vertical padding. Alternating columns are offset vertically by one half of a row height. There are on-screen controls and keyboard shortcuts for the following parameters: `cellWidth`, `cellHeight`, `cellPaddingH` (horizontal), `cellPaddingV` (vertical), `cutShape`.

### Custon Patterns

The software has a few basic, if somewhat arbitrary, patterns hard-coded as cut pattern options. The user can hard-code other patterns using the same basic coordinates concept as the Processing canvas in that (0,0) is the upper-left corner of the cell and (cellWidth,cellHeigh) is the bottom-right corner of the cell. You can edit these cut patterns inside of the `drawTrace()` function in `livingHingeTool.pde`. 

### Saving and Display Options
The cut pattern is saved to to a `/saved` directory by pressing the 's' button on the keyboard. Other keyboard shortcuts can be toggled by pressing 'h' and pattern spacing information is toggled with 'i'.

### Line Formatting

The lines are drawn with `strokWeight(0)` for one frame after the 's' button is pressed to make them "hairline" and seen as vector cuts by laser cutter software. All cut strokes are drawn with the default RGB full red, #FF0000 or (250,0,0).

## Usage

### Plugins Required
* You will need to install [ControlP5](http://www.sojamo.de/libraries/controlP5/) for this software to work. You can do that most easily from within Processing's "Add Library" menu. You can also install it by downloading it from the website, unzipping the file, and placing it your "libraries" folder. 
* This software also uses Processing's PDF library, but this is already included with your Processing installation and imported automatically.

### Download and Installation
* Once you clone or download this repository and install the ControlP5 library, you will have everything you need to run this software.

## Development Notes

### Open Issues
* The software currently only imports one SVG file or one of the pattern options. The import shows black and filled instead of with a red stoke but it does work otherwise. The import also looks notably bitrated on the canvas but the output is perfectly vector.
* Extreme parameter combinations will crash the software, likely from a divide by 0 error. This does not happen in a regular range of combinations.

### Future Development

* Publish the tool as a Processing plugin. Ensure that the design tool and the plugin functionality are completely separated. Further refine the tool and make it an included example. Have the tool output a function call (or similar) that can be used by itself in other sketches in the case that designers 
* Find and display a measure of the predicted ease of expanding the patterns when used with cardstock. The original reason for developing this software was to expand cardstock into interesting light manipulation pieces. It is difficult for now to know when the cut paper would be either too fragile or too inflexible to be expanded.
* Allow specifying absolute row and column counts as well as spacing ratios for scale-independent, highly controllable designs. This can be done outside of the software without too much additional work, but it would be nice to take this off the designers' hands.
* Remove old builds, clean up comments, classes, and organization
* Ensure clean PDF output for easier manipulation after saving the output, like editing in Rhino. Output already uses safe colors if used directly in a laser cutting application. At least making sure that the geometry values that save with the PDF (if turned on) are well outside the pattern boundary.
* Add a button for saving the output to PDF.
* Add some kind of estimate or proxy for cut time

### Comparable Tools
* [Grasshopper](https://www.rhino3d.com/6/new/grasshopper) for Rhino
* [Living Hinge Creator](https://inkscape.org/~drphonon/%E2%98%85living-hinge-creator) for Inkscape
