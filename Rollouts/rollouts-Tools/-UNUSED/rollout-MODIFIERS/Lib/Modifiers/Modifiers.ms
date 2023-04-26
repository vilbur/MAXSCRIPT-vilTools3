--filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/EditPolyModifier.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/ChamferModifier.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/NoiseModifier.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/NormalModifier.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/RelaxModifier.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/ShellModifier.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/VolumeSelectModifier.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/ModifierTypes/XFormModifier.ms" )



/** Modifiers
 */
struct Modifiers_v
(
	
	--Edit_Poly	= (EditPoly_Modifier_v()).get(),
	--XForm	= (XForm_Modifier_v()).get(),
	--Chamfer	= (Chamfer_Modifier_v()).get(),
	--Shell	= (Shell_Modifier_v()).get(),
	--Relax	= (Relax_Modifier_v()).get(),
	--Noise	= (Noise_Modifier_v()).get(),
	--VolumeSelect	= (VolumeSelect_Modifier_v()).get(),
	--Normal	= (Normal_Modifier_v()).get(),
	
	
	/** Get instanced modifiers
	 */
	function getInstancedModifiers obj =
	(
		for modifier in (this._getModifiers obj) where refhierarchy.isRefTargetInstanced modifier collect modifier
	),

	/** Search for modifier
	 */
	function search obj _modifier =
	(
		--format "\n"; print "Modifiers_v.search()"
		_modifiers = for obj_modifier in obj.modifiers where obj_modifier==_modifier collect obj_modifier
		
		if( _modifiers.count > 0 ) then
			_modifiers[1] --return
	),
	
	on create do
	(
	)
)