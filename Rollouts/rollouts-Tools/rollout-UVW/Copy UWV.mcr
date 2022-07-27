--
--/**  
-- */
--macroscript	_uvw_copy_taget_label
--category:	"_UVW"
--buttontext:	"Target channel"
--toolTip:	""
--icon:	"type:label|across:3"
--(	
--)


/**  
 */
macroscript	_uvw_copy_taget
category:	"_UVW"
buttontext:	"[channel]"
toolTip:	""
icon:	"type:radiobuttons|items:#('1','2','3','4')|across:3|unselect:true|offset:[ -16, 0 ]"
(
	format "EventFired	= % \n" EventFired
	
	messageBox "UV Has been copied" title:"Success"
	
	EventFired.Control.state = 0
)


--/**  
-- */
--macroscript	_uvw_copy
--category:	"_UVW"
--buttontext:	"Copy"
--toolTip:	""
--icon:	""
--(
--	if selection.count > 0 then
--	(
--		undo "Copy UV`s" on
--		(
--			
--			source_channel = uvw.Source_channel.state
--			target_channel = uvw.Target_channel.state
--		
--			for obj in selection do
--			(
--				if ( polyop.getMapSupport obj target_channel == false ) do polyop.setMapSupport obj target_channel true 
--				
--				--polyop.setNumMapVerts obj target_channel (polyop.getNumMapVerts obj source_channel ) keep:false
--				--polyop.setNumMapFaces obj target_channel (polyop.getNumMapFaces obj source_channel)  keep:false
--				
--				polyop.setNumMapVerts obj target_channel ( polyop.getNumMapVerts obj source_channel) keep:false
--				polyop.setNumMapFaces obj target_channel ( polyop.getNumMapFaces obj source_channel)  keep:false
--				
--				
--				for v = 1 to ( polyop.getNumMapVerts obj target_channel) do 
--					polyop.setMapVert obj target_channel v ( polyop.getMapVert obj source_channel v)
--
--				for f = 1 to ( polyop.getNumMapFaces obj target_channel) do
--					polyop.setMapFace obj target_channel f (polyop.getMapFace obj source_channel f)
--			)
--		)
--	)
--)



