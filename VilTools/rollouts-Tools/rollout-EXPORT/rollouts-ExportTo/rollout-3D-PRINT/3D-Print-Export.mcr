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


--macroscript	_export_print_test
--category:	"_Export"
--buttontext:	"[Open In Path]"
--toolTip:	"Exported files opened in programs with this path"
--icon:	"control:#browsePath|mode:#getOpenFileName|caption:Test Caption|across:1|offset:[0,16]"
----icon:	"Groupbox:Nodes|height:64"
--(
--	--clearListener()
--	format "EventFired	= % \n" EventFired
--
--)

/**  #righclick
 */
macroscript	_export_print_open_in_chitubox
category:	"_Export"
buttontext:	"[Open In Program]"
toolTip:	"Open export file in chitubox after export"
icon:	"control:radiobuttons|across:2|offset:[ 0, 0 ]|items:#('Chitubox', 'LycheSlicer')|columns:1"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.export_dir.text +"\"")

	--DosCommand ("explorer \""+export_dir+"\"")
	--format "EventFired	= % \n" EventFired

)

macroscript	_export_print
category:	"_Export"
buttontext:	"Export"
toolTip:	"Export selected nodes to files"
icon:	"height:64|across:2"
--icon:	"Groupbox:Nodes|height:64"
(
	clearListener()

	(ExporterSetup_v #Print).export()
)


--
--macroscript	_export_print_test
--category:	"_Export"
--buttontext:	"Chitubox"
----toolTip:	"Export selected nodes to files"
--icon:	"control:#checkButton|across:1|offset:[0,16]"
----icon:	"Groupbox:Nodes|height:64"
--(
--	--clearListener()
--	format "EventFired	= % \n" EventFired
--	format "VilTools.title	= % \n" VilTools.title
--	format "VilTools.ini	= % \n" (VilTools.ini.getPath())
--)
