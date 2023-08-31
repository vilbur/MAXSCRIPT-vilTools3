clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../CommandPanel.ms" )	-- "./../CommandPanel.ms"



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
CommandPanel 	= CommandPanel_v()

/* FIND MODIFIER IN STACK */
-- format "BASEOBJECT INDEX:	% \n" ( CommandPanel.findModInStack( selection[1].baseobject) )
-- format "MODIFIER INDEX:	% \n" ( CommandPanel.findModInStack( selection[1].modifiers[#Material]) )
--format "MODIFIER INDEX:	% \n" ( CommandPanel.findModInStack( selection[1].modifiers[2]) )


/* GET ITEMS COUNT */
--format "ITEMS COUNT:	% \n" (CommandPanel.itemsCount())

--/* SELECT ITEMS */
--CommandPanel.selectItem true 1
--CommandPanel.selectItem true 2
--CommandPanel.selectItem true 3
--CommandPanel.selectItem true 3 clear:false -- add to selection
--CommandPanel.selectItem true #(1, 3)

/* GET SELECTED ITEMS */
--format "SELECTED ITEMS:	% \n" (CommandPanel.getSlectedItems()) -- include baseobejct if selection == 1
--format "SELECTED MODIFIERS:	% \n" (CommandPanel.getSelectedModifiers())
--format "SELECTED MODIFIERS:	% \n" (CommandPanel.getSelectedModifiers obj: selection[2])
--

--modPanel.setCurrentObject( $.modifiers[(CommandPanel.getSelectedModifiers())[1]] ) -- refresh modifier stack
--max prev mod
--max next mod



/* SELECT ALL */
--CommandPanel.selectAll()

/* DESELECT ITEMS */
--CommandPanel.unselect()
--CommandPanel.selectItem false #all



--/* SELECT LAST ITEM (Base object) */
--CommandPanel.selectLastItem( true)
--CommandPanel.selectLastItem( false ) -- deselect last item (bseobject if selection.count == 1 )
