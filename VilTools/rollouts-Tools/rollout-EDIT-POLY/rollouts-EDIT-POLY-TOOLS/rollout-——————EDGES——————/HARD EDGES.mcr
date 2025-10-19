
/**
 *
 */
macroscript	edges_select_hard_edges
category:	"_Epoly-Hard-Edges"
buttontext:	"Select"
tooltip:	"Select Hard Edges"
icon:	"MENU:tooltip"
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
category:	"_Epoly-Hard-Edges"
buttontext:	"Show"
tooltip:	"Show Hard Edges"
icon:	"MENU:tooltip"
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
category:	"_Epoly-Hard-Edges"
buttontext:	"Make Hard"
tooltip:	"Make Hard Edges"
icon:	"MENU:true"
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
category:	"_Epoly-Hard-Edges"
buttontext:	"Make Smooth"
tooltip:	"Make Smooth Edges"
icon:	"MENU:true"
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
