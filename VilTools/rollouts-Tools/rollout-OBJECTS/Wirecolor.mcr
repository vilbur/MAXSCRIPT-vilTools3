
/**  
 *	
 */
macroscript	wirecolor_wirecolor_select_by
category:	"_Objects"
buttontext:	"Select by"
toolTip:	"Select by wirecolor of selection"
--icon:	"#(path, index)"
(
	sel_colors = for obj in selection collect obj.wirecolor
	
	makeUniqueArray sel_colors

	for _color in sel_colors do
		for obj in objects where obj.wirecolor == _color and obj.isNodeHidden == false and obj.layer.on == true do selectmore obj
)
