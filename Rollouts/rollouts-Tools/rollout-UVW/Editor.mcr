filein( getFilenamePath(getSourceFileName()) + "/Lib/UnwrapModifier.ms" ) -- DEV


/*------------------------------------------------------------------------------
	MAP CHANNELS
--------------------------------------------------------------------------------*/

--/**  
-- *	
-- */
--macroscript	uvw_editor_option_channels
--category:	"_UVW"
--buttontext:	"Channel"
--toolTip:	"Show diffuse in editor"
--icon:	"type:radiobuttons|items:#('1','2','3','4')|across:3"
--(
--
--)


/*------------------------------------------------------------------------------
	EDITOR OPEN BUTTON
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	unwrap_editor_open
category:	"_UVW"
buttontext:	"Open\Add Unwrap"
toolTip:	"Open unwrap editor"
--icon:	"across:1|height:64"
--icon:	"across:1"
(
	if selection.count == 0  then
		return false
	
	if classof (modpanel.getcurrentobject ()) != Unwrap_UVW then
	(
		if selection.count > 1  then
		(
			unwrap_indexes = (ModifyStack_v nodes: selection ).getIndexesOfInstances ( Unwrap_UVW )
	
			if unwrap_indexes.count > 0 then
				for i = 1 to (unwrap_indexes[1] - 1 ) do
					max prev mod
		)
		else
			for _modifier in selection[1].modifiers do
				if( classOf _modifier == Unwrap_UVW ) then 
					modPanel.setCurrentObject _modifier node:selection[1]
	)
		
	if( Unwrap_modifier = modpanel.getcurrentobject ()) != undefined then 
		Unwrap_modifier.edit()

)

/**  
 *	
 */
macroscript	unwrap_add_modifier
category:	"_UVW"
buttontext:	"Open\Add Unwrap"
toolTip:	"Add unwrap"
--icon:	"#(path, index)"
(
	clearListener() -- DEV
	filein( getFilenamePath(getSourceFileName()) + "/Lib/UnwrapModifier.ms" ) -- DEV
	
	UnwrapModifier 	= UnwrapModifier_v()
)

/*------------------------------------------------------------------------------
	EDITOR OPTIONS
--------------------------------------------------------------------------------*/
--/**  LABEL
-- *	
-- */
--macroscript	unwrap_editor_autoopen_label
--category:	"_UVW"
--buttontext:	"Auto Open"
--toolTip:	"Auto open Unwrap editor if:\n1) Object is selected\n2)Unwrap modifier is selected"
--icon:	"type:Label|across:2|offset:[-48,0]"
--(
--
--)
/**  
 *	
 */
macroscript	unwrap_editor_auto_open
category:	"_UVW"
buttontext:	"Auto Open"
--toolTip:	"Auto open Unwrap editor if:\n1) Object is selected\n2)Unwrap modifier is selected"
toolTip:	"Auto open Unwrap editor if Unwrap modifier is selected"
--icon:	"type:Radiobuttons|unselect:true|across:2|items:#('Object selected','Unwrap selected')|offset:[-64,0]"
icon:	"type:checkbox"
(
	--format "EventFired.val	= % \n" EventFired.val
	if EventFired.val == 1 then
		openUnwrapEditorEvent()
		
	else
		openUnwrapEditorKill()

)

/**  
 *	
 */
macroscript	unwrap_editor_option_grid
category:	"_UVW"
buttontext:	"Grid"
toolTip:	"Show grid in editor"
icon:	"type:checkbox|enabled:false"
--icon:	"type:checkbox|across:4|enabled:false"
(

)

/**  
 *	
 */
macroscript	unwrap_editor_option_texture
category:	"_UVW"
buttontext:	"Texture"
toolTip:	"Show diffuse in editor"
icon:	"type:checkbox|enabled:false"
--icon:	"type:checkbox|across:4"
(

)

