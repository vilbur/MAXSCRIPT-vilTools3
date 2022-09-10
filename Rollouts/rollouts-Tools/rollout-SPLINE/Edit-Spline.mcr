filein( getFilenamePath(getSourceFileName()) + "/Lib/ConnectVertices.ms" )

/**  
 *	
 */
macroscript	_spline_connect_vertices
category:	"_Edit-Spline"
buttontext:	"Connect"
toolTip:	"Connect 2 vertices"
icon:	"menu:_Context Spline"
--icon:	"menu:Context Spline Tools 2"
(
	on IsVisible return Filters.Is_EditSpline()
	on IsVisible return Filters.CanSwitchTo_Spline()
	
	on execute do
	(
		(ConnectVertices_v(for o in selection where superClassOf o == shape collect o)).connect()
	)
)

/**  
 *	
 */
macroscript	_spline_weld_vertices
category:	"_Edit-Spline"
buttontext:	"Weld"
toolTip:	"Weld vertices with 0 treshold"
icon:	"menu:_Context Spline"
--icon:	"menu:Context Spline Tools 2"
(
	on IsVisible return Filters.Is_EditSpline()
	on IsVisible return Filters.CanSwitchTo_Spline()
	
	on execute do
	(
		--macros.run "_Edit-Spline" "_spline_weld_vertices_test"
				
		if classOf (_mod = modPanel.getCurrentObject()) == Edit_Spline then 
		(
			set_weld_treshold_ahk = ((getDir #userScripts)+"/vilTools3/Rollouts/rollouts-Tools/rollout-SPLINE/Lib/Ahk/reset-weld-treshold.ahk")
		
			ShellLaunch set_weld_treshold_ahk ""
			
			sleep 0.1
						
			splineOps.weld _mod			
		)
		else if classOf _mod == SplineShape then
			weldSpline selection[1] 0.0
	)
)