clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ExporterDatasmith.ms" )


if maxFileName != "ExporterDatasmithTest.max" then 
	( messageBox "For this test open ExporterDatasmithTest.max" title:"Wrong scene"  beep:true;return false )


export_dir = getFilenamePath(getSourceFileName()) + "\\Export\\"

--format "export_dir	= % \n" export_direxport_dir

ExportChecker = ExportChecker_v export_node: $ExportTest

--ExportChecker.checkScene()
ExportChecker.attachObjectsInGroups()

(ExporterDatasmith_v()).export ($ExportTest) (export_dir)

--format "export_dir	= % \n" export_dir