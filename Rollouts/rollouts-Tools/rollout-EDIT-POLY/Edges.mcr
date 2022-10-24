/**  
 *	
 */
macroscript	edges_flow_connect
category:	"_Epoly-Edges"  
buttontext:	"Flow Connect"
toolTip:	"Flow Connect Edges"
icon:	"Menu:_Epoly-Edges"
(
	--on isVisible return Filters.Is_EPolySpecifyLevel #{3}
	on isVisible return Filters.Is_EPolySpecifyLevel #{3}
	
	on execute do (
		macros.run "PolyTools" "FlowConnect"
	)
)

--/**  
-- *	
-- */
--macroscript	edges_swift_loop
--category:	"_Epoly-Edges"  
--buttontext:	"Swift Loop"
--toolTip:	"Swift Loop"
--icon:	"Menu:_Epoly-Edges"
--(
--	on isVisible return Filters.Is_EPoly()
--	
--	on execute do (
--		macros.run "PolyTools" "SwiftLoop"
--	)
--)

/**  
 *	
 */
macroscript	edges_select_hard_edges
category:	"_Epoly-Edges"  
buttontext:	"Select Hard Edges"
toolTip:	"Select Hard Edges"
icon:	"Menu:_Epoly-Edges"
(
	on isVisible return Filters.Is_EPoly()

	on execute do (
		try (
			max modify mode
			local _Mod = Filters.GetModOrObj()
			format "Filters.Is_This_EditPolyMod _Mod = % \n" (Filters.Is_This_EditPolyMod _Mod)
			if (Filters.Is_EPoly()) then
			(
				
				if( Filters.Is_This_EditPolyMod _Mod ) then 
					_Mod.setoperation #SelectHardEdges
				else
					_Mod.selectHardEdges()
						
			)
				--_Mod.hardedgedisplay = if ( _Mod.hardedgedisplay == 0 ) then 1 else 0
		)
		catch ()
	)
)


/**  
 *	
 */
macroscript	edges_show_hard_edges
category:	"_Epoly-Edges"  
buttontext:	"Show Hard Edges"
toolTip:	"Show Hard Edges"
icon:	"Menu:_Epoly-Edges"
(
	--on isEnabled return Filters.Is_EPolySpecifyLevel #{2..3}
	--on isVisible return Filters.Is_EPolySpecifyLevel #{2..3}
	on isVisible return Filters.Is_EPoly()

	on execute do (
		try (
			max modify mode
			local _Mod = Filters.GetModOrObj()

			if (Filters.Is_EPoly()) then
				_Mod.hardedgedisplay = if ( _Mod.hardedgedisplay == 0 ) then 1 else 0
		)
		catch ()
	)
)

/**  
 *	
 */
macroscript	edges_make_hard_edges
category:	"_Epoly-Edges"  
buttontext:	"Make Hard Edges"
toolTip:	"Make Hard Edges"
icon:	"Menu:_Epoly-Edges"
(
	on isVisible return Filters.Is_EPoly()

	on execute do
		try (
			max modify mode
			local _Mod = Filters.GetModOrObj()

			if (Filters.Is_EPoly()) then
			(
				if( Filters.Is_This_EditPolyMod _Mod ) then 
					_Mod.ButtonOp #MakeHardEdges
				else
					_Mod.makeHardEdges 1
			)
		)
		catch ()
)

/**  
 *	
 */
macroscript	edges_make_smooth_edges
category:	"_Epoly-Edges"  
buttontext:	"Make Smooth Edges"
toolTip:	"Make Smooth Edges"
icon:	"Menu:_Epoly-Edges"
(
	on isVisible return Filters.Is_EPoly()

	on execute do
		try (
			max modify mode
			local _Mod = Filters.GetModOrObj()

			if (Filters.Is_EPoly()) then
			(
				if( Filters.Is_This_EditPolyMod _Mod ) then 
					_Mod.ButtonOp #MakeSmoothEdges
				else
					_Mod.makeSmoothEdges 1
			)
		)
		catch ()
)

/*
	Select Edges By Material ID
	v.0.2 (2012.11.19-21) by Anubis
	
	DESCRIPTION:
	Add separate Edit Poly modifier to each of selected objects
	and apply edge selection by selecting only edges that 
	connect faces with different material ID
	
	This is my quick attempt to fill this user request:
	http://www.scriptspot.com/forums/3ds-max/scripts-wanted/select-edge-by-material-id-borders
	
	The script is tested on 3ds Max 9
*/
macroscript edges_seelct_material_borders
category:	"_Epoly-Edges"  
buttontext:	"Select by mat ID"
tooltip:	"Select borders edges of material ID" 
(
	--filein (@"c:\GoogleDrive\Programs\CG\3DsMax\scripts\vilTools3\Rollouts\rollouts-Tools\rollout-Edit-Poly\Edges.mcr")
	
	on isEnabled return selection.count > 0
	on execute do
	(
		_selection = for obj in selection where validModifier obj Edit_Poly collect obj
		
		if _selection.count > 0 then
		(
			local selection_old = getCurrentSelection() -- preserve object selection
			--clearSelection()
			
			max modify mode -- switch to modify mode
			
			for obj in _selection do
			(
				if classOf (EditPoly	= modPanel.getCurrentObject()) == Edit_Poly then 
				(
					
					local new_edges_selection = #{} -- where to store edges selection
					--select obj -- select the object
					
					subObjectLevel = 4 -- #Face SO level
					
					local old_faces_selection = EditPoly.GetSelection #Face -- preserve face selection
					local faces_all = #{1..EditPoly.GetNumFaces()} -- get all faces
					
					for mID = 0 to 98 while faces_all.numberSet > 0 do
					(
						EditPoly.SetSelection #Face #{} -- clean old selection
						EditPoly.selectByMaterialID = mID -- set material ID to select
						EditPoly.SetOperation #SelectByMaterial -- execute selection
						
						EditPolyMod.ConvertSelectionToBorder EditPoly #Face #Edge -- convert the sel.
						
						new_edges_selection += EditPoly.GetSelection #Edge -- append edge sel. to new_edges_selection
						
						faces_all -= EditPoly.GetSelection #Face -- substract face sel. from faces_all
					)
					EditPoly.SetSelection #Face old_faces_selection -- restore old face selection
					EditPoly.SetSelection #Edge new_edges_selection -- select edges (main goal of this script)
					--subObjectLevel = 0
					subObjectLevel = 2
				)
			)
			--select selection_old -- restore old object selection
		)
	)
)









