/*
*	
*/	
macroscript	modifiers_create_test_objects
category:	"_Modifiers"  
buttonText:	"Create Test Objects"
--tooltip:	"Disable modifiers above current pinned modifier if suobject != 0"
icon:	"columns:8"
(
	delete objects
	
	--Box lengthsegs:1 widthsegs:1 heightsegs:1 length:33.8732 width:36.4541 height:38.1323 mapcoords:on pos:[-16.6444,-115.727,0] isSelected:on

	_box = box()
	
	select _box
	
	
	modPanel.addModToSelection (Chamfer ()) ui:on
	
	modPanel.addModToSelection (Edit_Poly ()) ui:on
	
	modPanel.setCurrentObject _box.modifiers[#Edit_Poly]
	
	maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
	select nnl
	move $ [0, 50, 0]
	
	select objects
	
	modPanel.addModToSelection (meshsmooth ()) ui:on -- ADD INSTANCED MODIFIERS
	modPanel.addModToSelection (meshsmooth ()) ui:on


		
	--modpanel.setPinStack true
	
	deselect selection
	
	redrawViews()
	actionMan.executeAction 0 "310" -- zoom on selection

)