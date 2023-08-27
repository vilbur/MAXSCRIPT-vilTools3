

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/MacroscriptGenerator.ms" ) -- "./../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/MacroscriptGenerator.ms"



for ini_file in getFiles (getFilenamePath(getSourceFileName())+"\\*.mcr.ini")  recurse:true do
	 MacroscriptGenerator_v(ini_file)

