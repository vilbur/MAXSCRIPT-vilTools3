/*------------------------------------------------------------------------------
	EDIT POLY
--------------------------------------------------------------------------------*/
/*
*	Ui Functions of modifier button 
*	
*	1) Add modifier
*	2) Save preset
*	3) Load Preset
*	4) Disable if subobject is active
*	
*/
macroscript	modifier_add_editpoly
category:	"_Modifiers"  
buttonText:	"EditPoly"
tooltip:	"Add EditPoly"
(
	--sub_obj	= subObjectLevel
	--
	--_Edit_Poly = (ModifierPreset_v control:#Edit_Poly ).add()
	--
	--if( sub_obj != undefined and sub_obj != 0 ) then 
	--	subObjectLevel = sub_obj
	--
	--redrawViews()
	addModifierOrLoadPreset(Edit_Poly)
)


/*------------------------------------------------------------------------------
	CHAMFER
--------------------------------------------------------------------------------*/
/** Add modifier if modifier of same type is not selected in stack
  * CTRL KEY FORCE ADDING MODIFIER although is active in stack
  *
  * Show load presets menu,if same type of modifier is active in stack
  */
macroscript	modifier_chamfer
category:	"_Modifiers"  
buttonText:	"Chamfer"
tooltip:	"Add modifier or load preset\nCtrl+LMB: Force adding of modifier."
icon:	"Menu:_Modifiers"
(
	addModifierOrLoadPreset(Chamfer)
)

/**
  *
  */
macroscript	modifier_chamfer_add_with_preset
category:	"_Modifiers"  
buttonText:	"Chamfer"
tooltip:	"Manage pesets"
(
	managePresetMenu(Chamfer)
)


/*------------------------------------------------------------------------------
	NOISE
--------------------------------------------------------------------------------*/
/**  
  */
macroscript	modifier_noise
category:	"_Modifiers"  
buttonText:	"Noise"
tooltip:	"Add modifier or load preset\nCtrl+LMB: Force adding of modifier."
(
	addModifierOrLoadPreset( NoiseModifier )
)
/**  
  */ 
macroscript	modifier_noise_preset
category:	"_Modifiers"  
buttonText:	"Noise"
tooltip:	"Manage pesets"
(
	managePresetMenu( NoiseModifier )
)

/*------------------------------------------------------------------------------
	FFD BOX
--------------------------------------------------------------------------------*/
/**  
  */
macroscript	modifier_ffdbox
category:	"_Modifiers"  
buttonText:	"FFDBox"
tooltip:	"Add modifier or load preset\nCtrl+LMB: Force adding of modifier."
(
	addModifierOrLoadPreset( FFDBox )
)

/**  
  */ 
macroscript	modifier_ffdbox_preset
category:	"_Modifiers"  
buttonText:	"FFDBox"
tooltip:	"Manage pesets"
(
	managePresetMenu( FFDBox )
)

/*------------------------------------------------------------------------------
	FACE EXTRUDE
--------------------------------------------------------------------------------*/
/**  
  */
macroscript	modifier_face_extrude
category:	"_Modifiers"  
buttonText:	"Face Extrude"
tooltip:	"Add modifier or load preset\nCtrl+LMB: Force adding of modifier."
(
	addModifierOrLoadPreset( Face_Extrude )
)

/**  
  */ 
macroscript	modifier_face_extrude_preset
category:	"_Modifiers"  
buttonText:	"Face Extrude"
tooltip:	"Manage pesets"
(
	managePresetMenu( Face_Extrude )
)

/*------------------------------------------------------------------------------
	SELECT MODIFIER INSTANCES
--------------------------------------------------------------------------------*/
/**  
  */
macroscript	modifier_get_instances_in_objects
category:	"_Modifiers"  
buttonText:	"Select Instances"
tooltip:	"Select objects with instance of current modifier"
icon:	"Menu:_Modifiers"
(
	select ((Modifier_v()).getObjectsWithInstance objects)
)


--macroscript	modifier_add_normal
--category:	"_Modifiers"  
--buttonText:	"Normal"
--tooltip:	"Add Normal"
--(
--	_Normal = (ModifierPreset_v control:#Normal ).add()
--
--	redrawViews()
--)
--macroscript	modifier_add_shell
--category:	"_Modifiers"  
--buttonText:	"Shell"
--tooltip:	"Add Shell"
--(
--	_Shell = (ModifierPreset_v control:#Shell ).add()
--
--	_Shell.overrideMatID = on
--	_Shell.matID = 255
--
--	_Shell.selectInnerFaces = on
--	_Shell.innerAmount = 30
--	_Shell.outerAmount = 0
--
--	redrawViews()
--)
--
--macroscript	modifier_resetXform
--category:	"_Modifiers"  
--buttonText:	"Xform"
--tooltip:	"Add Reset Xform"
--(
--	--clearListener()
--	Xform = (XForm_Modifier_v())
--
--	Xform.resetObject()
--)
--
--macroscript	modifier_Relax
--category:	"_Modifiers"  
--buttonText:	"Relax"
--tooltip:	"Add Reset Relax"
--(
--	--clearListener()
--	(ModifierPreset_v control:#Relax).add()
--
--)


--macroscript	modifier_smooth
--category:	"_Modifiers"  
--buttonText:	"Smooth"
--tooltip:	"Add Smooth"
--(
--	--clearListener()
--	(ModifierPreset_v control:#Smooth).add()
--
--)
--
--macroscript	modifier_volume_select
--category:	"_Modifiers"  
--buttonText:	"Volume Select"
--tooltip:	"Add Volume Select"
--(
--	--clearListener()
--	(ModifierPreset_v control:#VolumeSelect).add()
--
--)
--
--macroscript	modifier_face_extrude
--category:	"_Modifiers"  
--buttonText:	"Face Extrude"
--tooltip:	"Add Volume Select"
--(
--	--clearListener()
--
--	dialog	= dotNetObject "MaxCustomControls.RenameInstanceDialog" ""
--	dialog.text	= "Extrude Name"
--	modal	= dialog.Showmodal()
--	modifier_name	= dialog.InstanceName
--
--	if( modifier_name!="" ) then
--		modifier_name += "-"
--
--	_Mesh_Select	= (ModifierPreset_v control:#Mesh_Select	name:(modifier_name+"Select"	)).add()
--	_Face_Extrude	= (ModifierPreset_v control:#Face_Extrude	name:(modifier_name+"Extrude"	)).add()
--
--	_Mesh_Select.ignoreBackfacing = on
--
--	modPanel.setCurrentObject _Mesh_Select
--	subObjectLevel = 4 
--)
--
--macroscript	modifiers_taper
--category:	"_Modifiers"
--buttontext:	"Taper"
--toolTip:	"Add Taper"
----icon:	"#(path, index)"
--(
--	_selection	= selection
--	amount = -0.1
--	--dialog	= dotNetObject "MaxCustomControls.RenameInstanceDialog" "5"
--	--dialog.text	= "Amount"
--	--modal	= dialog.Showmodal()
--	--amount	= dialog.InstanceName
--
--	for obj in _selection where superClassOf obj == GeometryClass do
--	(
--		--print ( "obj = " + obj as string )
--		--select obj
--		--modPanel.addModToSelection  (Taper amount:(amount as float )) ui:on
--		_taper = Taper amount:(amount as float )
--
--		--_taper.Gizmo.position  = obj.pos
--
--		addModifier obj _taper
--
--		--print ( "_taper.center = " + _taper.center as string )
--		--print ( "_taper.Gizmo.position = " + _taper.Gizmo.position as string )
--
--		/**  http://www.scriptspot.com/forums/3ds-max/general-scripting/help-to-gizmo-center-modifier 
--		 *	
--		 */
--		if isProperty _taper #gizmo and isProperty _taper #center do
--		(
--
--			node = (refs.dependentnodes _taper)[1]
--			_taper.gizmo.transform = obj.transform * inverse node.transform 
--		)
--
--	)
--
--	--select _selection
--
--)
--
--/** Add FFD box to selection 
-- *	If baseobject is box, then Add number of points as count of segments of box
-- */
--macroscript	modifiers_ffdbox
--category:	"_Modifiers"
--buttontext:	"FFD Box"
--toolTip:	"Add FFD Box"
----icon:	"#(path, index)"
--(
--	obj	= selection[1]
--	_FFDBox	= FFDBox ()
--	segments	= [2, 2 , 2]
--
--	if( classOf obj.baseObject == Box and subObjectLevel == 0 ) then
--	(
--		segments	= [ (obj.widthsegs +1), (obj.lengthsegs +1), (obj.heightsegs  +1)]
--	)
--	setDimensions _FFDBox ( point3 segments[1] segments[2] segments[3] )
--	modPanel.addModToSelection _FFDBox ui:on
--
--)
--/** Add segment on active axises to current FFD moddifier 
-- *	
-- */
--macroscript	modifiers_ffd_add_segment
--category:	"_Modifiers"
--buttontext:	"FFD add segment"
--toolTip:	"FFD add segment on active axis"
----icon:	"#(path, index)"
--(
--	axises	= #( "X", "Y", "Z" )
--	_FFDBox	= modPanel.getCurrentObject()
--	active_axises	= toUpper ( toolMode.axisConstraints as string )
--	segments	= getDimensions _FFDBox
--
--	if not( classOf _FFDBox == FFDBox ) then
--		return ()
--	
--	getDimensions _FFDBox
--	
--	for i = 1 to active_axises.count do
--		segments[ findItem axises (active_axises[i]) ] += 1 
--
--	print ( "segments = " + segments as string )
--	
--	setDimensions _FFDBox ( point3 segments[1] segments[2] segments[3] )
--)
--
--/** Remove segment on active axises to current FFD moddifier 
-- *	
-- */
--macroscript	modifiers_ffd_remove_segment
--category:	"_Modifiers"
--buttontext:	"FFD remove segment"
--toolTip:	"FFD remove segment on active axis"
----icon:	"#(path, index)"
--(
--	axises	= #( "X", "Y", "Z" )
--	_FFDBox	= modPanel.getCurrentObject()
--	active_axises	= toUpper ( toolMode.axisConstraints as string )
--	segments	= getDimensions _FFDBox
--	
--	if not( classOf _FFDBox == FFDBox ) then
--		return ()
--	
--	getDimensions _FFDBox
--	
--	for i = 1 to active_axises.count do
--	(
--		index	= findItem axises (active_axises[i])
--		
--		if( segments[ index ] > 2 ) then 
--			segments[ index ]	-= 1 
--	)
--	
--	print ( "segments = " + segments as string )
--	
--	setDimensions _FFDBox ( point3 segments[1] segments[2] segments[3] )
--)
