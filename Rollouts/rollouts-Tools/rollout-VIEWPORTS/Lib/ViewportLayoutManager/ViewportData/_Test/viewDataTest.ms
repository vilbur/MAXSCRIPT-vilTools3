filein( getFilenamePath(getSourceFileName()) + "/../viewData.ms" ) -- "./../viewData.ms"

clearListener()

/*
----------------------------------

   TEST copy viewport 1 to viewport 2

----------------------------------
*/

if not viewport.getLayout ==  #layout_2h then
	viewport.setLayout ( #layout_2h )

viewport.activeViewportEx 1


/** GET VIEWPORT 1
  */
ViewData 	= ViewData_v()
ViewData.collectData()

--format "ViewData	= % \n" ViewData

/** SET VIEWPORT 2 BY VIEWPORT 1
  */

viewport.activeViewportEx 2

ViewData.restoreViewport()