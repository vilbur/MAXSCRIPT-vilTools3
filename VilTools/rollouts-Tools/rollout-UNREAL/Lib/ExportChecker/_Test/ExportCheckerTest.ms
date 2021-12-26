clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../../../../Library/MAXSCRIPT-UI-framework/Lib/ConstructPropeties/ConstructPropeties.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../ExportChecker.ms" )


if maxFileName != "ExportCheckerTest.max" then
	loadMaxFile( getFilenamePath(getSourceFileName()) + "/Scene/ExportCheckerTest.max" )



ExportChecker = ExportChecker_v export_nodes: #($ExportNode)

ExportChecker.analyzeExport()