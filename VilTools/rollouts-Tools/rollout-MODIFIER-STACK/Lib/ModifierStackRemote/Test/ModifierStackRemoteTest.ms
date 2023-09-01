clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../ModifierStackRemote.ms" )	-- "./../ModifierStackRemote.ms"

/** Prepare scene
  *
  */
function prepareScene =
(
	--format "\n"; print "errorTest.ms.prepareScene()"
	delete objects

	_box	= Box()
	_sphere	= Sphere pos:[100, 0, 0]

	--addModifier _box  (Poly_Select ())
	--addModifier _box  (Materialmodifier ())

	--select _sphere
	select _box
	--select objects


	addModifier _sphere  (Poly_Select ())

	modPanel.addModToSelection (Materialmodifier materialID: 3)
	modPanel.addModToSelection (Materialmodifier materialID: 2)
	modPanel.addModToSelection (Materialmodifier materialID: 1)

	addModifier _box  ( meshsmooth name:"Box" )

	modPanel.addModToSelection  (Poly_Select ())

)


prepareScene()


/* SET INSTANCE */
ModifierStack = ModifierStackRemote_v()


--/* SELECT ITEMS */
--ModifierStack.selectItem true 1
--ModifierStack.selectItem true 2
--ModifierStack.selectItem true 3
--ModifierStack.selectItem true 3 clear:false -- add to selection
--ModifierStack.selectItem true #(2, 3)

/* GET SELECTED ITEMS */
--format "SELECTED ITEMS:	% \n" (ModifierStack.getSlectedItems()) -- include baseobejct if selection == 1
--format "SELECTED MODIFIERS:	% \n" (ModifierStack.getSelectedModifiers())
--format "SELECTED MODIFIERS:	% \n" (ModifierStack.getSelectedModifiers obj: selection[2])
--

--modPanel.setCurrentObject( $.modifiers[(ModifierStack.getSelectedModifiers())[1]] ) -- refresh modifier stack


/* SELECT ALL */
--ModifierStack.selectAll()

/* DESELECT ITEMS */
--ModifierStack.unselect()
--ModifierStack.selectItem false #all



--/* SELECT LAST ITEM (Base object) */
--ModifierStack.selectLastItem( true)
--ModifierStack.selectLastItem( false ) -- deselect last item (bseobject if selection.count == 1 )

/* FIND MODIFIER IN STACK */
-- format "BASEOBJECT INDEX:	% \n" ( ModifierStack.findModInStack( selection[1].baseobject) )
 --format "MODIFIER INDEX:	% \n" ( ModifierStack.findModInStack( selection[1].modifiers[#Material]) )
--format "MODIFIER INDEX:	% \n" ( ModifierStack.findModInStack( selection[1].modifiers[2]) )

