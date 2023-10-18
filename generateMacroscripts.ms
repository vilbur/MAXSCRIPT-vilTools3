

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/MacroscriptGenerator.ms" ) -- "./../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/MacroscriptGenerator.ms"


/** 1) Loop *.mcr.ini in subfolders
  * 2) convert them to *.mcr files
  * 3) filein them
  *
  */
for ini_file in getFiles (getFilenamePath(getSourceFileName())+"\\*.mcr.ini")  recurse:true do
(
	mcr_file = (MacroscriptGenerator_v(ini_file)).generateMacroscriptFile()

	format "mcr.ini Converted:	% \n" (mcr_file)

	filein  mcr_file
)
