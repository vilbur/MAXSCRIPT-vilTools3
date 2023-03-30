filein( getFilenamePath(getSourceFileName()) + "/Lib/viewportChangeCallback/viewportChange.ms" )


/**
*
*/
macroscript	viewport_rotate_top_view
category:	"_Viewports"
buttontext:	"Rotate Top"
tooltip:	"Keep top view rotated by 90°"
icon:	"control:checkbox"
(
	if( EventFired.val ) then
		viewportChangeCallback()
	else
		viewportChangeKill()
)


--
-- /**
-- *
-- */
--macroscript	viewport_test
--category:	"_Viewports"
--buttontext:	"Test"
----tooltip:	"Keep top view rotated by 90°"
----icon:	"control:checkbox"
--(
--	viewport_matrix = viewport.getTM()
--
--	--format "viewport_matrix = % \n" viewport_matrix
--
--	is_top = (ViewportSwitcher_v())._isThisRotatedTopView(viewport.getTM())
--
--	format "is_top = % \n" is_top
--
--)