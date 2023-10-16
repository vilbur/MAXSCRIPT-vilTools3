filein( getFilenamePath(getSourceFileName()) + "/HudDisplays/HudDisplays.ms" )	-- "./HudDisplays/HudDisplays.ms"


/** Viewport hud
 */
struct ViewportHud_v
(
	/* construct */


	/* properties */
	Displays	= #(), -- #( ViewportHud_v )


	/* dependency */
	/* reference */
	/* inhered */



	private


	/**
	 */
	on create do
	(
		--format "\n"; print "ViewportHud.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)
)
