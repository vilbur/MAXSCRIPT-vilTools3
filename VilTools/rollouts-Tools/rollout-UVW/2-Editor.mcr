filein( getFilenamePath(getSourceFileName()) + "/Lib/UnwrapModifier.ms" ) -- DEV


/*------------------------------------------------------------------------------
	EDITOR OPTIONS
--------------------------------------------------------------------------------*/


/**  
 *	
 */
macroscript	unwrap_editor_auto_open
category:	"_UVW"
buttontext:	"AUTO OPEN EDITOR"
--toolTip:	"Auto open Unwrap editor if:\n1) Object is selected\n2)Unwrap modifier is selected"
toolTip:	"Auto open Unwrap editor if Unwrap modifier is selected"
--icon:	"control:Radiobuttons|unselect:true|across:2|items:#('Object selected','Unwrap selected')|offset:[-64,0]"
--icon:	"control:checkbox|offset:[48, 8]"
icon:	"control:checkbox|across:1|offset:[ 0, 8 ]|align:#CENTER"
(
	on execute do
	(
		format "EventFired.val	= % \n" EventFired.val
		
		if EventFired.val == 1 then
			CALLBACKMANAGER.start "openUnwrapEditor"
			
		else
			CALLBACKMANAGER.kill "openUnwrapEditor"
	)

)



/*------------------------------------------------------------------------------
	EDITOR OPEN BUTTON
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	unwrap_editor_open
category:	"_UVW"
buttontext:	"E D I T"
toolTip:	"Open unwrap editor"
icon:	"across:4|width:128|height:48|offset:[16, 8]"
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

--/**  
-- *	
-- */
--macroscript	unwrap_add_modifier
--category:	"_UVW"
--buttontext:	"Open"
--toolTip:	"Add unwrap"
----icon:	"#(path, index)"
--(
--	clearListener() -- DEV
--	filein( getFilenamePath(getSourceFileName()) + "/Lib/UnwrapModifier.ms" ) -- DEV
--	
--	UnwrapModifier 	= UnwrapModifier_v()
--)



/**  
 *	
 */
macroscript	unwrap_editor_option_grid
category:	"_UVW"
buttontext:	"Grid"
toolTip:	"Show grid in editor"
icon:	"control:checkbox|across:4|offset:[ 60, 24 ]|enabled:false"
--icon:	"control:checkbox|across:4|enabled:false"
(

)

/**  
 *	
 */
macroscript	unwrap_editor_option_texture
category:	"_UVW"
buttontext:	"Texture"
toolTip:	"Show diffuse in editor"
icon:	"control:checkbox|offset:[ 32, 24 ]|enabled:false"
--icon:	"control:checkbox|across:4"
(

)
