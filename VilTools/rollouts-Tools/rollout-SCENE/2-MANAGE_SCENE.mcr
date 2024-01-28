
/*------------------------------------------------------------------------------

	 FETCH \ HLOD

--------------------------------------------------------------------------------*/


/**
 *
 */
macroscript	_scene_hold
category:	"_Scene"
buttontext:	"Hold\Fetch"
toolTip:	"Hold scene"
--icon:	"#(path, index)"
(
	if queryBox "Hold scene ?" title:"Hold scene"  beep:false then
		holdMaxFile()
)

/**
 *
 */
macroscript	_scene_fetch
category:	"_Scene"
buttontext:	"Hold\Fetch"
toolTip:	"Fetch scene"
--icon:	"#(path, index)"
(
	if queryBox "Fetch scene ?" title:"Fetch scene"  beep:false then
	(
		fetchMaxFile quiet:true
		print "SCENE FETCHED"
	)
)