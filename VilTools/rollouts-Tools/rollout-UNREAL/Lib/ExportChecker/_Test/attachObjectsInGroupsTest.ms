clearListener()

--filein( getFilenamePath(getSourceFileName()) + "/../../../../../../../Library/MAXSCRIPT-UI-framework/Lib/ConstructPropeties/ConstructPropeties.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../ExportChecker.ms" )


if maxFileName != "attachObjectsInGroupsTest.max" then 
	( messageBox "For this test open attachObjectsInGroupsTest.max" title:"Wrong scene"  beep:true;return false )


ExportChecker = ExportChecker_v export_node: $ExportNode

ExportChecker.attachObjectsInGroups()