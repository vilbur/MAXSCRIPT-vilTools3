/**
 *
 */
macroscript	scene_layers_create
category:	"_Scene-Layers"
buttontext:	"Create"
toolTip:	"Create"
--icon:	"#(path, index)"
(

	--on IsEnabled return Filters.Is_EPolySpecifyLevel #{2..5}
	--on IsVisible return Filters.Is_EPolySpecifyLevel #{2..5}
	--on IsChecked Do (
	--	try (
	--
	--	)
	--	catch ( false )
	--)

	on execute do (
		filein( getFilenamePath(getSourceFileName()) + "/Lib/SceneLayers/SceneLayers.ms" )	--"./Lib/SceneLayers/SceneLayers.ms"

		try (
			messageBox "Execute" beep:false
		)
		catch()
	)
	--
	--on AltExecute type do (
	--	try (
	--		messageBox "Alt execute" beep:false
	--	)
	--	catch()
	--)
)
