filein( getFilenamePath(getSourceFileName()) + "/Lib/UvCopy/UvCopy.ms" )
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
			copyUV (uvw.Source_channel.state)(uvw.Target_channel.state)
		)
	)
)

/**  
 */
macroscript	_uvw_copy
category:	"_UVW"
buttontext:	"Copy"
toolTip:	"Chnage channels of textures on copy"
icon:	"across:3|height:24|offset:[ 0, 8 ]|Tooltip:Render UV Layout|Tooltip:Copy UV between channles\n"
(
	
	if selection.count > 0 then
	(
		undo "Copy UV`s" on
		(
			source_channel = uvw.Source_channel.state
			target_channel = uvw.Target_channel.state
			
			
			--copyUV (source_channel)(target_channel)
		
			/*------ CHANGE TEXTURES CHANNLES ------*/
			
			_Material 	= Material_v()
		
			materials = _Material.getMaterialsOfObjects( selection as Array )
			
			for mat in materials do
			(
				slots = _Material.getMapSlots(mat)
				format "slots	= % \n" slots
			)
		
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

