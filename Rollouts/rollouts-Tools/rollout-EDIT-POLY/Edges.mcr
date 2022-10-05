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










