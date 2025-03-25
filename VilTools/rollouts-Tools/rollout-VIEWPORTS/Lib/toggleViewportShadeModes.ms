/** Toggle shade modes #REALISTIC|#SHADEDWIRE|#WIREFRAME
  
	 #WIREFRAME:
		wire:	true
		shade:	false
		outline:	false
	
	 #SHADEDWIRE:
		wire:	true
		shade:	true
		outline:	false
		
	 #SHADED:
		wire:	false
		shade:	true
		outline:	true
		
	
	execute:
		toggleViewportShadeModes #WIREFRAME
		toggleViewportShadeModes #SHADEDWIRE
  
 */
function toggleViewportShadeModes shade_mode index: =
(
	--format "\n"; print ".toggleShadeMode()"
	
	/** Toggle outline
	 */
	function toggleOutline state = (NitrousGraphicsManager.GetSelectionSetting()).SelectionOutlineEnabled = state

		
	/* GET VIEWPORTS TO SWITCH MODE */ 
	viewports = if ( index ) != unsupplied then #(index) else for i = 1 to viewport.numViews collect i
	
	/* GET REFERENCE VIEWPORT */ 
	if index == unsupplied then 
		index = viewport.activeViewport

	ViewportSettingsSource	= NitrousGraphicsManager.GetViewportSetting( index )
	SelectionEffectImpl	= NitrousGraphicsManager.GetSelectionSetting()	

	current_style = ViewportSettingsSource.VisualStyleMode

	
	
	for index in viewports do
	(
		ViewportSettings	= NitrousGraphicsManager.GetViewportSetting( index )
		
		/* SHADED MODE AS DEFAULT
		*/ 	
		ViewportSettings.VisualStyleMode = #REALISTIC
	
		if shade_mode == #WIREFRAME and current_style != #WIREFRAME then
			ViewportSettings.VisualStyleMode = #WIREFRAME
	
		if shade_mode == #SHADEDWIRE then
			ViewportSettings.ShowEdgedFacesEnabled = not ViewportSettings.ShowEdgedFacesEnabled
	)
	

	/* ENABLE SLECTION OUTLINE IF NOT #WIREFRAME OR #SHADEDWIRE */ 
	SelectionEffectImpl.SelectionOutlineEnabled =  ( ViewportSettingsSource.VisualStyleMode != #WIREFRAME and ViewportSettingsSource.ShowEdgedFacesEnabled == false)
	
	/* ENABLE PREVEW OUTLINE */ 
    SelectionEffectImpl.PreviewOutlineEnabled = true
)
