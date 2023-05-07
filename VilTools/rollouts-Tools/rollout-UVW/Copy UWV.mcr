filein( getFilenamePath(getSourceFileName()) + "/Lib/UvCopier/UvCopier.ms" )

--/**  
-- */
--macroscript	_uvw_copy_taget_label
--category:	"_UVW"
--buttontext:	"Target channel"
--toolTip:	""
--icon:	"control:label|across:3"
--(	
--)


/**  
 */
macroscript	_uvw_copy_source_channel
category:	"_UVW"
buttontext:	"Source channel"
toolTip:	""
icon:	"control:radiobuttons|items:#('1','2','3','4')|across:3|offset:[ -16, 0 ]"
(
	--format "EventFired	= % \n" EventFired
	--
	--messageBox "UV Has been copied" title:"Success"
	--
	--EventFired.Control.state = 0
)


/**  
 */
macroscript	_uvw_copy
category:	"_UVW"
buttontext:	"Copy"
toolTip:	""
icon:	"across:3|height:24|offset:[ 0, 8 ]|Tooltip:Render UV Layout|Tooltip:Copy UV between channles\n"
(
	if selection.count > 0 then
	(
		undo "Copy UV`s" on
		(
			UvCopier_v ( selection ) (uvw.Source_channel.state)(uvw.Target_channel.state)
		)
	)
)

/**  
 */
macroscript	_uvw_copy
category:	"_UVW"
buttontext:	"Copy"
toolTip:	"Change channels of textures on copy"
icon:	"across:3|height:24|offset:[ 0, 8 ]|Tooltip:Render UV Layout|Tooltip:Copy UV between channles\n"
(
	
	if selection.count > 0 then
	(
		undo "Copy UV`s" on
		(
			_objects = for o in selection where superClassOf o == GeometryClass collect o
			
			source_channel = uvw.Source_channel.state
			target_channel = uvw.Target_channel.state
			
			UvCopier_v ( selection )(source_channel)(target_channel)
		
			/*------ CHANGE TEXTURES CHANNELS ------*/
			_Material 	= Material_v()
					
			materials = _Material.getMaterialsOfObjects( _objects )
			
			for mat in materials where (slots = _Material.getMapSlots(mat)).count > 0 do 
				for slot_name in slots where ( map_slot = getProperty mat slot_name ) != undefined do 
					map_slot.coords.mapChannel = target_channel
		)
	)
)

/**  
 */
macroscript	_uvw_copy_taget_channel
category:	"_UVW"
buttontext:	"Target channel"
toolTip:	""
icon:	"control:radiobuttons|items:#('1','2','3','4')|offset:[ 0, 0 ]"
(
	--format "EventFired	= % \n" EventFired
	--
	--messageBox "UV Has been copied" title:"Success"
	--
	--EventFired.Control.state = 0
)

