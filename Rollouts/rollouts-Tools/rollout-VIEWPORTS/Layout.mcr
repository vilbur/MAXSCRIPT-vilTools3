filein( getFilenamePath(getSourceFileName()) + "/Lib/ViewportLayoutManager/ViewportLayoutManager.ms" ) -- "./Lib/ViewportLayoutManager/ViewportLayoutManager.ms"

/*------------------------------------------------------------------------------
	GLOBAL
--------------------------------------------------------------------------------*/

if ViewportLayoutManager == undefined then
	ViewportLayoutManager = ViewportLayoutManager_v()

/**
*
*/
macroscript	viewport_layout_save
category:	"_Viewports"
buttontext:	"Save Layout"
(
	ViewportLayoutManager.saveCurrentLayout()
)


/* #layout_1
*/
macroscript	viewport_load_layout_1
category:	"_Viewports"
buttontext:	"layout_1"
toolTip:	"Load Viewport Layout"
icon:	"across:14|images:#('/Icons/Layouts.bmp',undefined,14, 1)"
(
	ViewportLayoutManager.resetLayout(#layout_1)
)

/* #layout_4
*/
macroscript	viewport_load_layout_4
category:	"_Viewports"
buttontext:	"layout_4"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 14)"
(
	ViewportLayoutManager.resetLayout(#layout_4)
)

/* #layout_2v
*/
macroscript	viewport_load_layout_2v
category:	"_Viewports"
buttontext:	"layout_2v"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 2)"
(
	ViewportLayoutManager.resetLayout(#layout_2v)
)

/* #layout_2h
*/
macroscript	viewport_load_layout_2h
category:	"_Viewports"
buttontext:	"layout_2h"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 3)"
(
	ViewportLayoutManager.resetLayout(#layout_2h)
)

/* #layout_2ht
*/
macroscript	viewport_load_layout_2ht
category:	"_Viewports"
buttontext:	"layout_2ht"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 4)"
(
	ViewportLayoutManager.resetLayout(#layout_2ht)
)

/* #layout_2hb
*/
macroscript	viewport_load_layout_2hb
category:	"_Viewports"
buttontext:	"layout_2hb"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 5)"
(
	ViewportLayoutManager.resetLayout(#layout_2hb)
)

/* #layout_3vl
*/
macroscript	viewport_load_layout_3vl
category:	"_Viewports"
buttontext:	"layout_3vl"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 6)"
(
	ViewportLayoutManager.resetLayout(#layout_1)
)

/* #layout_3vr
*/
macroscript	viewport_load_layout_3vr
category:	"_Viewports"
buttontext:	"layout_3vr"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 7)"
(
	ViewportLayoutManager.resetLayout(#layout_3vr)
)

/* #layout_3ht
*/
macroscript	viewport_load_layout_3ht
category:	"_Viewports"
buttontext:	"layout_3ht"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 8)"
(
	ViewportLayoutManager.resetLayout(#layout_3ht)
)

/* #layout_3hb
*/
macroscript	viewport_load_layout_3hb
category:	"_Viewports"
buttontext:	"layout_3hb"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 9)"
(
	ViewportLayoutManager.resetLayout(#layout_3hb)
)

/* #layout_4vl
*/
macroscript	viewport_load_layout_4vl
category:	"_Viewports"
buttontext:	"layout_4vl"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 10)"
(
	ViewportLayoutManager.resetLayout(#layout_4vl)
)

/* #layout_4vr
*/
macroscript	viewport_load_layout_4vr
category:	"_Viewports"
buttontext:	"layout_4vr"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 11)"
(
	ViewportLayoutManager.resetLayout(#layout_4vr)
)

/* #layout_4ht
*/
macroscript	viewport_load_layout_4ht
category:	"_Viewports"
buttontext:	"layout_4ht"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 12)"
(
	ViewportLayoutManager.resetLayout(#layout_4ht)
)

/* #layout_4hb
*/
macroscript	viewport_load_layout_4hb
category:	"_Viewports"
buttontext:	"layout_4hb"
toolTip:	"Load Viewport Layout"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14, 13)"
(
	ViewportLayoutManager.resetLayout(#layout_4hb)
)


