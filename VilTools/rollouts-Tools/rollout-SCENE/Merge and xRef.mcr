/**
 *
 */
macroscript	_scene_copy_object_between_max_instances
category:	"_Scene"
buttontext:	"Copy\Paste Obj"
toolTip:	"Copy selected object"
--icon:	"across:5|width:72|menu:_Scene"
(
	saveNodes selection (((GetDir #temp) as string ) + "\copy_paste_buffer.max")  quiet:true
)

/**
 *
 */
macroscript	_scene_paste_object_between_max_instances
category:	"_Scene"
buttontext:	"Copy\Paste Obj"
toolTip:	"Paste object to scene"
--icon:	"across:5|width:72|menu:_Scene"
(
	mergeMaxFile (((GetDir #temp) as string ) + "\copy_paste_buffer.max") #select

)
