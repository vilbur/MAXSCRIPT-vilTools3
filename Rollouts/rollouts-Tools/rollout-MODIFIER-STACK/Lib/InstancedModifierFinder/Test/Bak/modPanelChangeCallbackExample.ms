clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ModifyStack.ms" )

/** Create test objets
 */
function createTestObjets =
(
	delete objects
	
	_box = box()
	
	select _box
	
	modPanel.addModToSelection (Edit_Poly ()) ui:on
	
	modPanel.addModToSelection (Chamfer ()) ui:on
	
	modPanel.setCurrentObject _box.modifiers[#Edit_Poly]
	
	deselect selection
	
	redrawViews()
)


createTestObjets()

/** Mod panel obj post change callback
 */
function modPanelObjPreChangeCallback =
(
	print "\nmodPanelObjPreChange"
	print ( modPanel.getCurrentObject() )
)

function modPanelObjPostChangeCallback =
(
	print "\nmodPanelObjPostChange"
	format "selection.count = % \n" selection.count
	--print ( modPanel.getCurrentObject() )
	if ( ( cutrent_obj = modPanel.getCurrentObject() ) == undefined ) then
		print "Modifier Unselected"		
	
	else
		print ("Modifier "+ cutrent_obj as string +" Selected")		
)

function modPanelSelChangedCallback =
(
	print "\nmodPanelSelChanged"
	format "selection.count = % \n" selection.count
	print ( modPanel.getCurrentObject() )
)

try(callbacks.removeScripts #modPanelObjPreChange id:#modPanelObjPreChangeCallback)catch()
try(callbacks.removeScripts #modPanelObjPostChange id:#modPanelObjPostChangeCallback)catch()
try(callbacks.removeScripts #modPanelSelChanged id:#modPanelSelChangedCallback)catch()



callbacks.addScript #modPanelObjPreChange "modPanelObjPreChangeCallback()" id:#modPanelObjPreChangeCallback
callbacks.addScript #modPanelObjPostChange "modPanelObjPostChangeCallback()" id:#modPanelObjPostChangeCallback
callbacks.addScript #modPanelSelChanged "modPanelSelChangedCallback()" id:#modPanelSelChangedCallback


/**   RESULT

	callbacks "pre" "change" and "post" are fired twice at one time, but they are different in  modPanel.getCurrentObject()
	only one useful seem to be "modPanelObjPostChange"


	"modPanelObjPreChange"
	Chamfer:Chamfer
	
	"modPanelObjPostChange"
	undefined
	
	"modPanelObjPreChange"
	undefined
	
	"modPanelObjPostChange"
	Edit_Poly:Edit Poly
	
	"modPanelSelChanged"
	Edit_Poly:Edit Poly




 */
