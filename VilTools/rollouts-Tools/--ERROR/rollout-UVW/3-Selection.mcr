

/**  LINK TO NODE
 */
macroscript	_uvw
category:	"_UVW-selection"
buttontext:	"Select Element"
toolTip:	"Select UV element by selected faces"
--icon:	"Across:2"
icon:	"MENU:true"
(
	on execute do
	(
		if classOf ( _mod = modPanel.getCurrentObject() ) == Unwrap_UVW then
	
		_mod.unwrap2.selectElement() 
	)
	
)

