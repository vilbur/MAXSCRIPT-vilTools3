
/**
 *
 */
macroscript	edges_select_hard_edges
category:	"_Epoly-Hard-Edges"
buttontext:	"Select"
toolTip:	"Select Hard Edges"
icon:	"Menu:_Epoly-Hard-Edges"
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
toolTip:	"Show Hard Edges"
icon:	"Menu:_Epoly-Hard-Edges"
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
toolTip:	"Make Hard Edges"
icon:	"Menu:_Epoly-Hard-Edges"
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
toolTip:	"Make Smooth Edges"
icon:	"Menu:_Epoly-Hard-Edges"
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