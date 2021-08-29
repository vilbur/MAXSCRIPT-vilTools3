filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/EditPolyModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/ChamferModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/NoiseModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/NormalModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/RelaxModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/ShellModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/VolumeSelectModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/XFormModifier.ms" )



/** Modifiers
 */
struct Modifiers_v
(
	
	Edit_Poly	= (EditPoly_Modifier_v()).get(),
	XForm	= (XForm_Modifier_v()).get(),
	Chamfer	= (Chamfer_Modifier_v()).get(),
	Shell	= (Shell_Modifier_v()).get(),
	Relax	= (Relax_Modifier_v()).get(),
	Noise	= (Noise_Modifier_v()).get(),
	VolumeSelect	= (VolumeSelect_Modifier_v()).get(),
	Normal	= (Normal_Modifier_v()).get(),
	
	/** Delete
	 */
	function delete =
	(
		
	),
	/** Search for first edit poly modifier from top
	 */
	function search obj _modifier =
	(
		
		for obj_modifier in (this._getModifiers obj) where obj_modifier==_modifier collect obj_modifier

		
		
		--if( _modifiers.count > 0 ) then
			--_modifiers[1] --return
		--print ( "_modifiers=" + _modifiers as string )
	),
	/** Get edit poly modifiers
	 */
	function _getModifiers obj =
	(
		max modify mode
		
		obj.modifiers --return
			--allInstanced = (for o in objects where (refhierarchy.isRefTargetInstanced _modifier ) collect o)

			--allInstanced --return 
		
		
		
		--modifiers_current	= obj.modifiers
		--format "\nobj.modifiers = % \n" obj.modifiers
		--
		--_modifiers	= #()
		--print ( "modifiers_current=" + modifiers_current as string )
		--
		----for m=1 to modifiers_current.count where  classOf modifiers_current[m] == _modifier do
		----	append _modifiers modifiers_current[m]
		--
		----for modifier_current in modifiers_current where  classOf modifier_current == _modifier do 
		--for modifier_current in modifiers_current do
		--(
		--	format "modifier_current = % \n" modifier_current
		--	
		--)
		--	--append _modifiers modifier_current
		--
		--
		--
		--_modifiers --return
	),
	
	on create do
	(
		--messagebox "Modifiers.onCreate()"
	)
)
