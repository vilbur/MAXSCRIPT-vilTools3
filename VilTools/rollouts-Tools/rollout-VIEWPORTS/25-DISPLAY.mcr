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
		toggleShadeModes #WIREFRAME
		toggleShadeModes #SHADEDWIRE
  
 */
function toggleShadeModes shade_mode index: =
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


 /** TOGGLE WIREFRAME \ REALISTIC
 *
 */
macroscript	viewport_wireframe_shade_toggle
category:	"_Viewports-Setup"
buttontext:	"Wire \ Shaded"
tooltip:	"Toggle WIREFRAME \ SHADED in ALL VIEWPORTS"
icon:	"ACROSS:2"
(
	on execute do
		toggleShadeModes #WIREFRAME 
)

/** TOGGLE WIREFRAME \ REALISTIC
*
*/
macroscript	viewport_wireframe_shade_toggle_current_viewport
category:	"_Viewports-Setup"
buttontext:	"Wire \ Shaded"
tooltip:	"Toggle WIREFRAME \ SHADED in ACTIVE VIEWPORT"
(
	on execute do
		toggleShadeModes #WIREFRAME index:viewport.activeViewport
)





macroscript	viewport_show_face_index
category:	"_Viewports-Setup"
buttontext:	"Show Face ID"
toolTip:	"Show selected faces' index in the viewport"
--icon:	"width:72"

(
	local FaceIndexShow = false
	local lastviewport
	global Laca_callbacks
	global redrawscr_laca()

	fn redrawscr_laca = gw.updatescreen()

	fn FaceShow = (
		try (
			if viewport.activeViewport != lastviewport do (
				completeredraw()
				lastViewport = viewport.activeViewport
			)
			if (selection.count == 1) and ((classof $.baseobject == Editable_Mesh) or (classof $.baseobject == Editable_Poly)) then
			(
				gw.setTransform (matrix3 1)
				if (classof $ == Editable_Mesh) then
					for gw_i in (getfaceselection $) do (
						local posss = [0,0,0]
						local face_i = meshop.getfacecenter $ gw_i
						gw.wtext ((gw.wtransPoint face_i)+[0,0,100]) (gw_i as string) color:[255,255,255]
					)
				else (
					for gw_i in (polyop.getfaceselection $.baseobject) do (
						local face_i = polyop.getfacecenter $ gw_i
						gw.wtext ((gw.wtransPoint face_i)+[0,0,100]) (gw_i as string) color:[255,255,255]
					)
				)
				gw.enlargeupdaterect #whole
			)
		)
		catch()
	)

	on ischecked return FaceIndexShow

	on Execute do (
		if FaceIndexShow then (
			Laca_callbacks -= 1
			unregisterRedrawviewscallback FaceShow
			if Laca_callbacks == 0 then unregisterRedrawViewsCallback redrawscr_laca
		)
		else (
			if Laca_callbacks != undefined then Laca_callbacks += 1
			if Laca_callbacks == undefined then Laca_callbacks = 1
			registerRedrawviewscallback FaceShow
			unregisterRedrawviewsCallback redrawscr_laca
			registerRedrawviewsCallback redrawscr_laca
		)
		FaceIndexShow = not FaceIndexShow
		forcecompleteredraw()
		updateToolbarbuttons()
	)
)





/** TOGGLE SHADEDWIRE \ REALISTIC
*
*/
macroscript	viewport_shade_shade_toggle
category:	"_Viewports-Setup"
buttontext:	"Shade \ Outline"
tooltip:	"Toggle SHADEDWIRE \ SHADED in ALL VIEWPORTS"
icon:	"ACROSS:2"
(
	on execute do
		toggleShadeModes #SHADEDWIRE 
)

/** TOGGLE SHADEDWIRE \ REALISTIC
*
*/
macroscript	viewport_shade_shade_toggle_current_viewport
category:	"_Viewports-Setup"
buttontext:	"Shade \ Outline"
tooltip:	"Toggle SHADEDWIRE \ SHADED in ACTIVE VIEWPORT"
(
	on execute do
	
		toggleShadeModes #SHADEDWIRE index:viewport.activeViewport
)





/**
*
*/
macroscript	viewport_selection_bracets
category:	"_Viewports-Setup"
buttontext:	"Sel Brackets"
tooltip:	"Toogle Selection Brackets"
icon:	"MENU:true"
(
	current_state = (NitrousGraphicsManager.GetActiveViewportSetting()).ShowSelectionBracketsEnabled

	 for i = 1 to viewport.numViews do
		(NitrousGraphicsManager.GetViewportSetting i).ShowSelectionBracketsEnabled = not current_state

)

