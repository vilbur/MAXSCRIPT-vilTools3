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

	select _sphere
	select _box
	select objects


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

/* SELECET BY HANDLE */
ModifierStack.selectByHandle (getHandleByAnim selection[1].modifiers[3] ) true

/* SELECT ITEMS */
--ModifierStack.selectItem 1 true
--ModifierStack.selectItem 2 true
--ModifierStack.selectItem 3 true
--ModifierStack.selectItem 4 true
--ModifierStack.selectItem 6 true
--ModifierStack.selectItem 7 true
--ModifierStack.selectItem 3 true clear:false -- add to selection
--ModifierStack.selectItem #(2, 3) true

--/* GET MODIFIERS */
--format "MODIFIERS:	% \n" (ModifierStack.getModifiers( 2 ))
--format "MODIFIERS:	% \n" (ModifierStack.getModifiers #( 2, 3 ))
--
--
--/* GET SELECTED ITEMS */
--format "SELECTED ITEMS:	% \n" (ModifierStack.ListBox.getSlectedItems()) -- include baseobejct if selection == 1
--
--/* GET SELECTED MODIFIERS */
--format "SELECTED MODIFIERS:	% \n" (ModifierStack.getSelectedModifiers())
--
--/* SELECT ALL */
--ModifierStack.ListBox.selectAll()
--
--
--/* DESELECT ITEMS */
--ModifierStack.ListBox.unselect()
--
--
--/* SET MODIIERS STATE */
--ModifierStack.setState 3 false
--ModifierStack.setState #(2, 3, 4) false
--
--/* SET STATE OF SELECTED MODIIERS  */
--ModifierStack.setState #SELECTED false
--
--/* SET STATE OF ALL MODIIERS  */
--ModifierStack.setState #ALL false
--
--/* TOGGLE STATE */
--ModifierStack.setState #ALL #TOGGLE
--
--/* SET MODIIERS SET PROPERTY */
--ModifierStack.setProp #ALL #materialID 1
--ModifierStack.setProp #SELECTED #name "RENAMED MOD"



/* FIND MODIFIER IN STACK */
-- format "BASEOBJECT INDEX:	% \n" ( ModifierStack.findModInStack( selection[1].baseobject) )
 --format "MODIFIER INDEX:	% \n" ( ModifierStack.findModInStack( selection[1].modifiers[#Material]) )
--format "MODIFIER INDEX:	% \n" ( ModifierStack.findModInStack( selection[1].modifiers[2]) )
