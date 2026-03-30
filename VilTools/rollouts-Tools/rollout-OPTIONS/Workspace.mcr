/**  
 */
macroscript	_workspace
category:	"_Workspace"
buttontext:	"workspace"
toolTip:	"workspace"
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
	--
	--on execute do (
	--	try (
	--		messageBox "Execute" beep:false
	--	)
	--	catch()
	--)
	--
	--on AltExecute type do (
	--	try (
	--		messageBox "Alt execute" beep:false
	--	)
	--	catch()
	--)
)
