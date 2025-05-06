
/*------------------------------------------------------------------------------
	FACES \ SMOOTH
--------------------------------------------------------------------------------*/
macroscript	viewport_faces_smooth_toggle
category:	"_Viewports-Setup"
buttontext:	"Faces \ Smooth"
tooltip:	"Toggle FACES \ SMOOTH in ALL VIEWPORTS"
icon:	"ACROSS:4|height:32"
(
	on execute do
	(
		render_levels = #(
			#facethighlights,
			--#wireFrame,
			--#flat,
			--#facet,
			--#smooth,
			#smoothhighlights
		)
		
		current_level = viewport.GetRenderLevel()
		
		idx = findItem render_levels current_level
		next_idx = if idx == 0 or idx == render_levels.count then 1 else idx + 1
		
		format "SET RENDER LEVEL: %\n" render_levels[next_idx]
		
		viewport.SetRenderLevel render_levels[next_idx]
	)
)


/*------------------------------------------------------------------------------
	TOGGLE WIREFRAME \ REALISTIC
--------------------------------------------------------------------------------*/
macroscript	viewport_wireframe_shade_toggle
category:	"_Viewports-Setup"
buttontext:	"Wire \ Shaded"
tooltip:	"Toggle WIREFRAME \ SHADED in ALL VIEWPORTS"
--icon:	"ACROSS:2"
(
	on execute do
		toggleViewportShadeModes #WIREFRAME 
)

/** 
*/
macroscript	viewport_wireframe_shade_toggle_current_viewport
category:	"_Viewports-Setup"
buttontext:	"Wire \ Shaded"
tooltip:	"Toggle WIREFRAME \ SHADED in ACTIVE VIEWPORT"
(
	on execute do
		toggleViewportShadeModes #WIREFRAME index:viewport.activeViewport
)


/*------------------------------------------------------------------------------
	SHADE \ OUTLINE
--------------------------------------------------------------------------------*/
macroscript	viewport_shade_wire_toggle
category:	"_Viewports-Setup"
buttontext:	"Shade \ Outline"
tooltip:	"Toggle SHADEDWIRE \ SHADED in ALL VIEWPORTS"
(
	on execute do
		toggleViewportShadeModes #SHADEDWIRE 
)

/** 
*/
macroscript	viewport_outline_wire_toggle_current_viewport
category:	"_Viewports-Setup"
buttontext:	"Shade \ Outline"
tooltip:	"Toggle SHADEDWIRE \ SHADED in ACTIVE VIEWPORT"
(
	on execute do
		toggleViewportShadeModes #SHADEDWIRE index:viewport.activeViewport
)



/*------------------------------------------------------------------------------
	PERFORMANCE | HIGHQUALITY | STANDARD
--------------------------------------------------------------------------------*/
global VIEWPORT_LIGHTING_MODE_CURRENT

/** 
  *	
  */
macroscript	viewport_performance_highquality_standard
category:	"_Viewports-Setup"
buttontext:	"Stadard \ High"
tooltip:	"Toggle STADARD \ PERFORMANCE \ HIGHQUALITY in ALL VIEWPORTS"
icon:	"ACROSS:4"
(
	on execute do
	(
		render_levels = #( #PERFORMANCE, #STANDARD, #HIGHQUALITY )
		
	
		idx = findItem render_levels VIEWPORT_LIGHTING_MODE_CURRENT
		next_idx = if idx == 0 or idx == render_levels.count then 1 else idx + 1
		
		format "Viewport Lighting and Shadows: %\n" render_levels[next_idx]
		
		VIEWPORT_LIGHTING_MODE_CURRENT = render_levels[next_idx]
		
		case render_levels[next_idx] of
		(
			#PERFORMANCE: actionMan.executeAction -844228238 "14"  -- Viewport Lighting and Shadows: Performance
	
			--"standard":
			#HIGHQUALITY: actionMan.executeAction -844228238 "12"  -- Viewport Lighting and Shadows: High Quality
	
	
			default:
			   actionMan.executeAction -844228238 "13"  -- Viewport Lighting and Shadows: Standard
	
		)
	)
)



/*------------------------------------------------------------------------------
	SHOW FACE ID
--------------------------------------------------------------------------------*/
macroscript	viewport_show_face_index
category:	"_Viewports-Setup"
buttontext:	"Show Face ID"
toolTip:	"Show selected faces' index in the viewport"
icon:	"ACROSS:2"
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







/*------------------------------------------------------------------------------
	Sel Brackets
--------------------------------------------------------------------------------*/
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

