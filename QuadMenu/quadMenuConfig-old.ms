
for menu_file in getFiles (getFilenamePath(getSourceFileName()) + "\\Quads\\*.ms") do
	try(
		--menu_file	= ( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace menu_file "\\"

		filein( menu_file )
	)catch(

		format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
		format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
		format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
		format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
	)


/** Template fn
 */
function templateFn param = ()


/*------------------------------------------------------------------------------

	RIGHT CLICK QUAD

--------------------------------------------------------------------------------*/



quad_sections = #( #BOTTOM_LEFT|#BOTTOM_RIGHT|#TOP_LEFT|#TOP_RIGHT )


/** Get right click quad
 */
function getRightClickQuad =
(
	--format "\n"; print "quadMenuConfig.ms.getRightClickQuad()"

	quad_fn =


	for i = 1 to quad_sections.count by 1 do
	item = array[i]


)




function getRightClickQuad QuadMenu =
(




for i = 1 to quad_sections.count do
	QuadMenu.getMenu(quad_sections[i]



EDIT1menu		(QuadMenu.getMenu(#BOTTOM_LEFT)) -- "./Quads/EDIT1.ms"
EDIT2menu		(QuadMenu.getMenu(#BOTTOM_RIGHT)) -- "./Quads/EDIT2.ms"

HIDEPOLYmenu	(QuadMenu.getMenu(#TOP_LEFT))	-- "./Quads/HIDEPOLY.ms"
PRIMITIVESmenu	(QuadMenu.getMenu(#TOP_RIGHT))	-- "./Quads/PRIMITIVES.ms"

QuadMenu -- return
)

/*------------------------------------------------------------------------------

	CONTROL QUAD

--------------------------------------------------------------------------------*/
function getControlQuad QuadMenu =
(
	SELECTIONmenu	(QuadMenu.getMenu(#BOTTOM_LEFT))	-- "./Quads/SELECTION.ms"
	PIVOTmenu		(QuadMenu.getMenu(#BOTTOM_RIGHT))	-- "./Quads/PIVOT.ms"

	HIDEmenu		(QuadMenu.getMenu(#TOP_LEFT))	-- "./Quads/HIDE.ms"
	SNAPmenu		(QuadMenu.getMenu(#TOP_RIGHT))	-- "./Quads/SNAP.ms"
	TRANSFORMmenu	(QuadMenu.getMenu(#TOP_RIGHT))	-- "./Quads/TRANSFORM.ms"

	QuadMenu -- return
)

/*------------------------------------------------------------------------------

	SHIFT QUAD

--------------------------------------------------------------------------------*/
function getShiftQuad QuadMenu =
(
	templateFn		(QuadMenu.getMenu(#BOTTOM_LEFT))		-- "./Quads/templateFn.ms"
	templateFn		(QuadMenu.getMenu(#BOTTOM_RIGHT))		-- "./Quads/templateFn.ms"

	LAYERSmenu		(QuadMenu.getMenu(#TOP_LEFT))			-- "./Quads/LAYERS.ms"
	templateFn		(QuadMenu.getMenu(#TOP_RIGHT))		-- "./Quads/templateFn.ms"

    QuadMenu -- return
)

/*------------------------------------------------------------------------------

	ALT QUAD

--------------------------------------------------------------------------------*/
function getAltQuad QuadMenu =
(
	templateFn		(QuadMenu.getMenu(#BOTTOM_LEFT))	-- "./Quads/templateFn.ms"
	ANIMATIONmenu	(QuadMenu.getMenu(#BOTTOM_RIGHT))	-- "./Quads/ANIMATION.ms"

	templateFn		(QuadMenu.getMenu(#TOP_LEFT))	-- "./Quads/templateFn.ms"
	templateFn		(QuadMenu.getMenu(#TOP_RIGHT))	-- "./Quads/templateFn.ms"

	QuadMenu -- return
)

/*------------------------------------------------------------------------------

	CONTROL ALT QUAD

--------------------------------------------------------------------------------*/
function getControlAltQuad QuadMenu =
(
	templateFn		(QuadMenu.getMenu(#BOTTOM_LEFT))		-- "./Quads/templateFn.ms"
	templateFn		(QuadMenu.getMenu(#BOTTOM_RIGHT))		-- "./Quads/templateFn.ms"

	templateFn		(QuadMenu.getMenu(#TOP_LEFT))			-- "./Quads/templateFn.ms"
	templateFn		(QuadMenu.getMenu(#TOP_RIGHT))		-- "./Quads/templateFn.ms"

	QuadMenu -- return
)

/*------------------------------------------------------------------------------

	CONTROL SHIFT QUAD

--------------------------------------------------------------------------------*/
function getCotrolShiftQuad QuadMenu =
(
	templateFn		(QuadMenu.getMenu(#BOTTOM_LEFT))		-- "./Quads/templateFn.ms"
	SCENEmenu		(QuadMenu.getMenu(#BOTTOM_RIGHT))		-- "./Quads/SCENE.ms"

	templateFn		(QuadMenu.getMenu(#TOP_LEFT))			-- "./Quads/templateFn.ms"
	templateFn		(QuadMenu.getMenu(#TOP_RIGHT))		-- "./Quads/templateFn.ms"

	QuadMenu -- return
)


/*==============================================================================

		CREATE QUAD MENUS

================================================================================*/

--RightClickQuad = getRightClickQuad( QuadMenu_v("_RightClickQuad") )
--RightClickQuad.setRightClick() --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed
--
--ControlQuad = getControlQuad( QuadMenu_v("_ControlQuad") )
--ControlQuad.setRightClick which:#controlPressed
--
--ShiftQuad = getShiftQuad( QuadMenu_v("_ShiftQuad") )
--ShiftQuad.setRightClick which:#shiftPressed
--
--AltQuad = getAltQuad( QuadMenu_v("Animation") )
--AltQuad.setRightClick which:#altPressed
--
--ControlAltQuad = getControlAltQuad( QuadMenu_v("_ControlAltQuad") )
--ControlAltQuad.setRightClick which:#controlAndAltPressed
--
--CotrolShiftQuad = getCotrolShiftQuad( QuadMenu_v("_CotrolShiftQuad") )
--CotrolShiftQuad.setRightClick which:#shiftAndControlPressed



/*------------------------------------------------------------------------------

	SET QUAD SHORTCUTS

--------------------------------------------------------------------------------*/
