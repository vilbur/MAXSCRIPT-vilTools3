/** Set symmetry modifier
 */
function setSymmetryModifier obj axis: object_space:false =
(
	format "\n"; print ".setSymmetryModifier()"
	--format "axis	= % \n" axis
	SymetryMod = if obj.modifiers[#Symmetry] == undefined then
	(
		_modifier = symmetry ()

		addModifier obj _modifier

		_modifier

	) else
		 obj.modifiers[#Symmetry]

	case axis of
	(
		#X:	SymetryMod.PlanarX = not SymetryMod.PlanarX
		#Y:	SymetryMod.PlanarY = not SymetryMod.PlanarY
		#Z:	SymetryMod.PlanarZ = not SymetryMod.PlanarZ
	)

	if object_space == false then -- set mirror to world [0,0,0]
	(

		--mirror_positon = [0,0,0]
		case axis of
		(
			#X:	SymetryMod.PlanarFlipX = (obj.pos.x < 0)
			#Y:	SymetryMod.PlanarFlipY = (obj.pos.y < 0)
			#Z:	SymetryMod.PlanarFlipZ = (obj.pos.z < 0)
		)

		mirror_positon = [ (obj.pos.x * -1) ,  (obj.pos.y * -1),  (obj.pos.z * -1)]

	)
	else
	(
		SymetryMod.PlanarFlipX = false
		SymetryMod.PlanarFlipY = false
		SymetryMod.PlanarFlipZ = false

		mirror_positon = [0,0,0]
	)

	--SymetryMod.flip = not SymetryMod.flip
	--format "mirror_positon	= % \n" mirror_positon
	SymetryMod.mirror.position = mirror_positon

)