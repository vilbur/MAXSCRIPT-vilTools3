/** Measure & Select
 *
 * https://miauu-maxscript.com/portfolio-item/miauus-measure-and-select/
 */
macroscript	utilities_measure_floater
category:	"_Utilities"
buttonText:	"Measure"
tooltip:	"OPen meassure floater"
icon:	"across:2|width:96|height:32"
(
	on execute do
	(
		local mode = GetCommandPanelTaskMode()
		local subobjlvl = subObjectLevel
	 
		UtilityPanel.OpenUtility Measure	
		hwnd  = (windows.getChildHWND #max "Lock Selection")[1]
		state = windows.sendMessage hwnd 0xF0 0 0 -- check if locked selection state is active
	 
		if state != 1 do
		(
			windows.sendMessage hwnd 0x201 1 0
			windows.sendMessage hwnd 0x202 0 0
		)
	 
		UIAccessor.PressButton (windows.getChildHWND #max "New Floater")[1]
	 
			-- position Measure window at certain coord
		(dotNetClass "Autodesk.Max.GlobalInterface").Instance.SlideWindow (for w in UIAccessor.GetPopupDialogs() collect w)[1] 100 100
	 
		SetCommandPanelTaskMode mode
		if subobjlvl != undefined do try ( subObjectLevel = subobjlvl )catch()
	 
	)
)

/** Measure & Select
 *
 * https://miauu-maxscript.com/portfolio-item/miauus-measure-and-select/
 */
macroscript	utilities_measure_and_select
category:	"_Utilities"
buttonText:	"Measure Dialog"
tooltip:	"OPEN DIALOG\n\nSelect edges by its length or measure distance between VERTS, EDGES or OBJECTS"
--icon:	"columns:8"
(
	on execute do
	(
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/miauumeasureandselect_v11_0.ms" )

		macros.run "miauu" "miauuMeasureAndSelect"
	)
)

/** https://miauu-maxscript.com/portfolio-item/miauus-measure-and-select/
 *
 */
macroscript	utilities_measure_and_select_tutorial
category:	"_Utilities"
buttonText:	"Measure Dialog"
tooltip:	"OPEN VIDEO TUTORIAL"
--icon:	"columns:8"
(
	on execute do
		DOSCommand "start \"\"https://www.youtube.com/watch?time_continue=36&v=4N7V2BjMz6E&embeds_referring_euri=https%3A%2F%2Fmiauu-maxscript.com%2F&source_ve_path=MTM5MTE3LDI4NjYzLDEzNzcyMSwyODY2Ng"
)



/**
 *
 */
macroscript	utilities_camera_match
category:	"_Utilities"
buttonText:	"Camera Match"
icon:	"columns:8"
(
	on execute do
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/111_cameraMatch_v0.4.ms" )
)

/**
 *
 */
macroscript	utilities_rock_generator
category:	"_Utilities"
buttonText:	"Rock Generator"
icon:	"columns:8"
(
	on execute do
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/Rock-Generator1x0.ms" )	--"./../../../Lib/vendor/Rockgenerator1x0.mse"
)