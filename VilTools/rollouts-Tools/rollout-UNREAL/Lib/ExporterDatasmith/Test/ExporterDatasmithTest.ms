clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ExporterDatasmith.ms" )


if maxFileName != "ExporterDatasmithTest.max" then 
	( messageBox "For this test open ExporterDatasmithTest.max" title:"Wrong scene"  beep:true;return false )


ExporterDatasmith_v export_nodes:#($ExportNode)
