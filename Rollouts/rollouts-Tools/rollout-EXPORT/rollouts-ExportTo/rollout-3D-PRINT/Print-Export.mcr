--filein( getFilenamePath(getSourceFileName()) + "/Lib/PrintExporter.ms" )	-- "./Lib/PrintExporter.ms"

/*==============================================================================

		EXPORT BUTTON

================================================================================*/

--
--/**  #righclick
-- */
--macroscript	_export_print_open_dir
--category:	"_Export"
--buttontext:	"Export"
--toolTip:	"Open export folder"
----icon:	"Groupbox:Nodes|height:64"
--(
--	--export_dir = execute ("@"+ "\""+EventFired.Roll.export_dir.text +"\"")
--
--	--DosCommand ("explorer \""+export_dir+"\"")
--
--)



macroscript	_export_print
category:	"_Export"
buttontext:	"Export"
toolTip:	"Export selected nodes to files"
icon:	"height:64|across:2|offset:[0,16]"
--icon:	"Groupbox:Nodes|height:64"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.BROWSEPATH_Export_Dir.text +"\"")
	clearListener()


	(ExporterSetup_v #Print).export()


	--redrawViews()
)


/**  #righclick
 */
macroscript	_export_print_open_dir
category:	"_Export"
buttontext:	"Export"
toolTip:	"Open export folder"
--icon:	"Groupbox:Nodes|height:64"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.export_dir.text +"\"")

	--DosCommand ("explorer \""+export_dir+"\"")

)
