filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/miauu_connecttolastselvert.mcr" )

/**  
 *	
 */
macroscript	edit_poly_merge_faces
category:	"_Epoly-Vertex"  
buttonText:	"Connect To Last vertex"
toolTip:	"Connect To Last vertex"
icon:	"Menu:_Epoly-Vertex"
(
	--on IsVisible return Filters.Is_EPolySpecifyLevel #{2..3}
	on IsVisible return Filters.Is_EPolySpecifyLevel #{2}
	
	on execute do
		macros.run "miauu" "miauu_ConnectToLastSelVertAlt"
)

/**  
 *	
 */
macroscript	edit_poly_weld
category:	"_Epoly-Vertex"  
buttonText:	"Weld"
toolTip:	"Weld vertices"
icon:	"Menu:_Epoly-Vertex"
(
	
	--on IsVisible return Filters.Is_EPolySpecifyLevel #{2..3}
	on IsVisible return Filters.Is_EPolySpecifyLevel #{2}

	on execute do
		(Epoly_v()).weld 0.0001
		
		
	on AltExecute type do (
		Try (
			If SubObjectLevel == undefined then Max Modify Mode
			local A = Filters.GetModOrObj()
			if Filters.Is_This_EditPolyMod A then
			(
				if (subobjectLevel == 1) then A.PopupDialog #WeldVertex
				else A.popupDialog #WeldEdge
			)
			else A.popupDialog #WeldSelected
		)
		catch()
	)

)

