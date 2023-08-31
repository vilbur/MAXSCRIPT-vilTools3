clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../ModifierNameUnifier.ms" )	-- "./../ModifierNameUnifier.ms"


/** Prepare scene
  *
  */
function prepareScene =
(
	--format "\n"; print "prepareScene()"
	delete objects

	global _box	= Box()

	select _box

	addModifier _box  (Poly_Select ())
	addModifier _box (Materialmodifier materialID: 3)
	addModifier _box (Materialmodifier materialID: 2)
	addModifier _box (Materialmodifier materialID: 1)

	addModifier _box  ( meshsmooth name:"Box" )
	addModifier _box  ( meshsmooth name:"Box" )
)

prepareScene()

/* SET INSTANCE */
ModifierNameUnifier 	= ModifierNameUnifier_v(_box)


/* SET UNIQUE NAMES */
--ModifierNameUnifier.unify( _box.baseObject )
--ModifierNameUnifier.unify( _box.modifiers[#Poly_Select] )
-- ModifierNameUnifier.unify( _box.modifiers[#Material] )
-- ModifierNameUnifier.unify( _box.modifiers[#Box] )


/* RESTORE ORIGINAL NAMES */
ModifierNameUnifier.restoreNames()