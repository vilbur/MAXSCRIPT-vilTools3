filein( getFilenamePath(getSourceFileName()) + "/Lib/MaxToZbrushSync.ms" )

/**
  *
  *
 */
macroscript	_3DsMaxSync_to_zbrush
category:	"_3DsMaxSync"
buttontext:	"Max > ZBrush"
toolTip:	""
icon:	"Across:2|width:196|height:48"
--icon:	"Groupbox:Nodes"
--icon:	"control:checkbutton"
(
	filein @"C:\GoogleDrive\ProgramsData\CG\ZBrush\Plugins\INSTALLED\MaxZbrushSync\3DsMax\MaxToZbrushSync.mcr"
	(MaxToZbrushSync_v()).exportObjToZbrush()
)

/**
  *
 */
macroscript	_3DsMaxSync_to_max
category:	"_3DsMaxSync"
buttontext:	"ZBrush > Max"
toolTip:	""
--icon:	"Across:2"
--icon:	"Groupbox:Nodes"
--icon:	"control:checkbutton"
(
	clearListener()
	--messageBox "_3DsMaxSync_to_max" title:"Title"  beep:false
	undo "Import Zbrush" on
	(
		(MaxToZbrushSync_v()).importObjToMax()
	)

)