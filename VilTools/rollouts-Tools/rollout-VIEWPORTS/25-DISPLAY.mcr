

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
		toggleViewportShadeModes #WIREFRAME 
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
		toggleViewportShadeModes #WIREFRAME index:viewport.activeViewport
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
		toggleViewportShadeModes #SHADEDWIRE 
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
	
		toggleViewportShadeModes #SHADEDWIRE index:viewport.activeViewport
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

