clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../CommandPanel.ms" )	-- "./../CommandPanel.ms"



/** Prepare scene
  *
  */
function prepareScene =
(
	--format "\n"; print "errorTest.ms.prepareScene()"
	delete objects

	_box = box()

	addModifier _box  (Poly_Select ())
	addModifier _box  (Materialmodifier ())
	addModifier _box  (FFDBox ())
	addModifier _box  (meshsmooth ())

	select _box
)

prepareScene()


/* SET INSTANCE */
CommandPanel 	= CommandPanel_v()


/* GET ITEMS COUNT */
format "ITEMS COUNT:	% \n" (CommandPanel.itemsCount())

/* DESELECT ITEMS */
CommandPanel.unselect()
CommandPanel.selectItem false #all

/* SELECT ITEMS */
CommandPanel.selectItem true 2
CommandPanel.selectItem true 3 clear:false -- add to selection
CommandPanel.selectItem true #(1, 3)
CommandPanel.selectAll()


/* GET SELECTED ITEMS */
format "SELECTED MODIFIERS:	% \n" (CommandPanel.getSelectedModifiers())

/* SELECT LAST ITEM (Base object) */
CommandPanel.selectLastItem( true)
CommandPanel.selectLastItem( false ) -- deselect last item (bseobject if selection.count == 1 )
