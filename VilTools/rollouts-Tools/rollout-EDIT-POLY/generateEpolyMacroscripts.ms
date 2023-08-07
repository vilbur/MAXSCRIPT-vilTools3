
print "MacroscriptGenerator.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../../../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/MacroscriptGenerator.ms" ) -- "./../../../../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/MacroscriptGenerator.ms"



for ini_file in getFiles (getFilenamePath(getSourceFileName())+"\\*.ini") do
	MacroscriptGenerator_v(ini_file)
