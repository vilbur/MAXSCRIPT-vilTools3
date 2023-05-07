filein( getFilenamePath(getSourceFileName()) + "/Lib/ConnectVertices.ms" )

/**  
 *	
 */
macroscript	_spline_connect_vertices
category:	"_Edit-Spline"
buttontext:	"Connect Vertices"
toolTip:	"Connect 2 vertices"
icon:	"menu:_Context Spline"
(
	on IsVisible return Filters.Is_EditSpline()
	--on IsVisible return Filters.CanSwitchTo_Spline()
	
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
buttontext:	"Weld Vertices"
toolTip:	"Weld vertices with 0 treshold"
icon:	"menu:_Context Spline"
(
	on IsVisible return Filters.Is_EditSpline()
	--on IsVisible return Filters.CanSwitchTo_Spline()
	
	on execute do
	(
		--macros.run "_Edit-Spline" "_spline_weld_vertices_test"
				
		if classOf (_mod = modPanel.getCurrentObject()) == Edit_Spline then 
		(
			--set_weld_treshold_ahk = ((getDir #userScripts)+"/vilTools3/Rollouts/rollouts-Tools/rollout-SPLINE/Lib/Ahk/reset-weld-treshold.ahk")
			set_weld_treshold_ahk = ((getDir #userScripts)+"/vilTools3/Rollouts/rollouts-Tools/rollout-SPLINE/Lib/Ahk/set-weld-treshold.ahk")
		
			ShellLaunch set_weld_treshold_ahk "0,01"
			
			sleep 0.1
						
			splineOps.weld _mod			
		)
		else if classOf _mod == SplineShape then
			weldSpline selection[1] 0.0
	)
)


/**  
 *	
 */
macroscript	_spline_set_interpolation
category:	"_Edit-Spline"
buttontext:	"Set Interpolation"
toolTip:	"Set spline interpolation"
icon:	"menu:_Context Spline|index:1"
(
	on IsVisible return Filters.Is_EditSpline()
	--on IsVisible return Filters.CanSwitchTo_Spline()
	
	on execute do
	(
		global roll_spline_interpolation
		
		try(destroyDialog roll_spline_interpolation)catch()
		
		rollout roll_spline_interpolation ""
		(
			--spinner spn_interpolation "" range:[0,64,3] pos:[2,8] fieldwidth:32 type:#integer
			spinner spn_interpolation "" range:[0,64, $.baseobject.steps] pos:[2,8] fieldwidth:32 type:#integer
			
			on spn_interpolation entered inSpin_arg inCancel_arg do
			(
				$.baseobject.steps = spn_interpolation.value
				
				
				if inSpin_arg == false then 
					try(destroyDialog roll_spline_interpolation)catch()
					
			)

		)
		
		CreateDialog roll_spline_interpolation width:52 height:32 style:#() pos:(mouse.screenpos) modal:true bgcolor:( color 0 255 0 )
		
		setFocus roll_spline_interpolation.spn_interpolation
	)
)












