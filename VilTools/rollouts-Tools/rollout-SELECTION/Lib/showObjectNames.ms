
unregisterRedrawViewsCallback displayObjectNames

fn displayObjectNames =
(
	--gw.setTransform ( Matrix3 1)

	for o in objects where not o.isHiddenInVpt do
	(
		--gw.text o.pos (o as string ) color:yellow
	  --gw.enlargeUpdateRect #whole

		/*
			https://forums.cgsociety.org/t/unregister-a-redrawviewscallback-in-scripted-modifier/2048394/4
		*/
		setTransform	= gw.setTransform
		hTransPoint 	= gw.hTransPoint
		--htext	= gw.hText
		htext	= gw.text o.pos ( toUpper( o.name as string )) color:red applyUIScaling:false
		enlargeUpdateRect	= gw.enlargeUpdateRect
		updateScreen	= gw.updateScreen


	)
)
