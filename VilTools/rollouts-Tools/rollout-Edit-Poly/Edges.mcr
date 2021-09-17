/**  
 *	
 */
macroscript	edges_select_hard_edges
category:	"_Epoly-Edges"  
buttontext:	"Hard"
toolTip:	"Select Hard Edges"
--icon:	"#(path, index)"
(
	--local _Mod = Filters.GetModOrObj()

	--format "Filters.Is_EPoly 	= % \n" (Filters.Is_EPoly()	)
	--format "Filters.Is_EditPoly	= % \n" (Filters.Is_EditPoly())
	--format "Filters.Is_EditPolyMod 	= % \n" (Filters.Is_EditPolyMod())
	--format "Filters.Is_This_EditPolyMod _Mod	= % \n" (Filters.Is_This_EditPolyMod _Mod)

	
	
	on isEnabled return Filters.Is_EPolySpecifyLevel #{2..3}
	on isVisible return Filters.Is_EPolySpecifyLevel #{2..3}
	
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
buttontext:	"Hard"
toolTip:	"Show Hard Edges"
--icon:	"#(path, index)"
(
	on isEnabled return Filters.Is_EPolySpecifyLevel #{2..3}
	on isVisible return Filters.Is_EPolySpecifyLevel #{2..3}
	
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


--(
--    obj = modPanel.getCurrentObject()
--    if obj != undefined then
--    (
--        case (classof obj) of
--        (
--        Edit_Poly:obj.setoperation #SelectHardEdges 
--        Editable_Poly:obj.selectHardEdges()
--        )
--    )
--     
--)

--macroscript	edges_epoly_test
--category:	"_Epoly-Edges"  
--buttontext:	"epoly_test"
--toolTip:	"epoly_test"
----icon:	"#(path, index)"
--(
--			local _Mod = Filters.GetModOrObj()
--
--	format "Filters.Is_EPoly 	= % \n" (Filters.Is_EPoly()	)
--	format "Filters.Is_EditPoly	= % \n" (Filters.Is_EditPoly())
--	format "Filters.Is_EditPolyMod 	= % \n" (Filters.Is_EditPolyMod())
--	format "Filters.Is_This_EditPolyMod _Mod	= % \n" (Filters.Is_This_EditPolyMod _Mod)
--
--	
--	
--	on isEnabled return Filters.Is_EPolySpecifyLevel #{2..3}
--	on isVisible return Filters.Is_EPolySpecifyLevel #{2..3}
--	
--	on execute do (
--		try (
--			max modify mode
--			local _Mod = Filters.GetModOrObj()
--
--			--if (Filters.Is_This_EditPolyMod _Mod) then
--				_Mod.hardedgedisplay = (_Mod.hardedgedisplay == false)
--				--$.modifiers[#Edit_Poly].hardedgedisplay = 1
--
--
--				--print "Edit Poly"
--			
--			--else if (Filters.Is_EditPoly()) then
--				--_Mod.hardedgedisplay = 1
--				--$.hardedgedisplay = 1
--			
--				--print "Editable Poly"
--		)
--		catch ()
--	)
--)


--macroscript	edges_test
--category:	"rollouts-Tools-Edges"
--buttontext:	"test"
--toolTip:	"test"
----icon:	"#(path, index)"
--(
--	
--)


--macroscript	epoly_select_hard_edges
--category:	"_Epoly-Edges"
--buttonText:	"Select hard Edges"
--tooltip:	"Select HARD edges on all objects"
--(
--	_selection = (Selection_v()).get()
--	--print ( "_selection=" + _selection[1] as string )
--	--print ( "_selection=" + _selection.count as string )
--	
--	for i=1 to _selection.count do
--		(Epoly_v()).selectHardEdges _selection[i]
--	
--	select _selection
--	subObjectLevel = 2
--
--)
--
--macroscript	epoly_split_by_hard_edges
--category:	"_Epoly-Edges"  
--buttonText:	"Split hard Edges"
--tooltip:	"Split HARD edges on all objects"
--(
--	_selection = (Selection_v()).get()
--	
--	for i=1 to _selection.count do
--		((Epoly_v()).selectHardEdges _selection[i]).splitEdges()
--	
--	select _selection
--	subObjectLevel = 2
--	
--)
--
--macroscript	epoly_select_corner_edges
--category:	"_Epoly-Edges"  
--buttonText:	"Corner Edges"
--tooltip:	"Select Corner Edges, edges where meets 3 polygons"
--(
--	
--	Epoly 	= (Epoly_v())
--	--(Epoly_v()).selectCornerEdges()
--	verts = Epoly.getAWhereB #vertex #edge "==" 3
--	--print ( "verts = " + verts as string )
--	subObjectLevel = 1
--	Epoly.setSel #Vertex verts
--	Epoly.convertSelection #edge
--	
--)