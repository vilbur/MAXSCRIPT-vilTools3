
/**
 *
 */
macroscript	_spline_connect_vertices
category:	"_Edit-Spline"
buttontext:	"Connect Vertices"
toolTip:	"Connect 2 vertices"
icon:	"MENU:true"
(
	on IsVisible return Filters.Is_EditSpline()
	--on IsVisible return Filters.CanSwitchTo_Spline()

	on execute do
	(
		filein( getFilenamePath(getSourceFileName()) + "/Lib/ConnectVertices.ms" )

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
icon:	"MENU:true"
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
macroscript	_spline_material_id_by_segment
category:	"_Edit-Spline"
buttontext:	"Mat Id by Segment"
toolTip:	"Mat Id by Segment"
icon:	"MENU:true"
(
	on IsVisible return Filters.Is_EditSpline()
	--on IsVisible return Filters.CanSwitchTo_Spline()

	on execute do
	(
		--macros.run "_Edit-Spline" "_spline_weld_vertices_test"
		for spline_i = 1 to numSplines (obj = selection[1]) do
			for segment_i = 1 to numSegments obj spline_i do
				setMaterialID  obj spline_i segment_i segment_i
	)
)


/**
 *
 */
macroscript	_spline_set_interpolation
category:	"_Edit-Spline"
buttontext:	"Set Interpolation"
toolTip:	"Set spline interpolation"
icon:	"MENU:true|index:1"
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
			spinner spn_interpolation "" range:[0,64, selection.baseobject.steps] pos:[2,8] fieldwidth:32 type:#integer

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
/**
 *
 */
macroscript	_spline_from_intersect
category:	"_Edit-Spline"
buttontext:	"Spline Intersect"
tooltip:	"Create Spline From Intersect Of Geometry"
icon:	"MENU:true"
(
	on IsVisible return Filters.Is_EditSpline()
	--on IsVisible return Filters.CanSwitchTo_Spline()
	on execute do
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/Lucax3D/splineFromIntersect.mse" )	-- "./../../../Lib/vendor/Lucax3D/splineFromIntersect.mse"
)


/**
 *
 */
macroscript	_spline_explode
category:	"_Edit-Spline"
buttontext:	"Explode"
toolTip:	"Explode shape to splines"
icon:	"MENU:true"
(


	on execute do
	(
		/*
		Explode spline object to one copy per spline element.
		Original node stays unchanged, copies get suffix like -1 or -01.
		*/
		function explodeSplineToSplineElements shape_node suffix_separator:"-" =
		(
			created_nodes = #()
		
			if isValidNode shape_node then
			(
				spline_count = 0
		
				try
				(
					spline_count = numSplines shape_node
				)
				catch
				(
					spline_count = 0
				)
		
				if spline_count > 0 then
				(
					digit_count = 1
		
					if spline_count > 9 then
					(
						digit_count = (spline_count as string).count
					)
		
					for spline_index = 1 to spline_count do
					(
						suffix_number = spline_index as string
		
						while suffix_number.count < digit_count do
						(
							suffix_number = "0" + suffix_number
						)
		
						copy_node = copy shape_node
						copy_node.name = uniqueName (shape_node.name + suffix_separator + suffix_number)
		
						for delete_index = spline_count to 1 by -1 do
						(
							if delete_index != spline_index then
							(
								deleteSpline copy_node delete_index
							)
						)
		
						updateShape copy_node
						append created_nodes copy_node
					)
				)
			)
		
			created_nodes -- return
		)
			
		for obj in selection where superClassOf obj == shape do
			explodeSplineToSplineElements obj



	)


)


/**
 *
 */
macroscript	_spline_attach_selected
category:	"_Edit-Spline"
buttontext:	"Attach"
toolTip:	"Attach selected shape to spline"
icon:	"MENU:true"
(
	function AttachSplines sp splines: =
	(
		convertToSplineShape sp
		for s in splines where s != sp do addandweld sp (converttosplineshape s) -1
		sp
	)

	on execute do
	(
		if selection.count != 0 do
		(
			splObjsArr = for o in selection where canConvertTo o SplineShape collect o
			newSpl = AttachSplines splObjsArr[1] splines:splObjsArr
			newSpl.pos.z = 0
		)

	)

)
/*
***  RANDOMIZE SPLINE M,ATERIAL IDS v1.0  ***

Script Name:	randomize_spline_material_ids.ms
Compatible:	3dsMax 2012 and higher
Version:		v1.0
Release date:  November 20, 2018
Last update:	November 20, 2018
Code by:		Hernan A. Rodenstein
Website:		www.splinedynamics.com/free-3dsmax-scripts/

Description:
Randomize the material IDs in every spline of the selected shapes. Options to choose: use existing IDs or use range.

Revision History: -
*/

macroscript	_spline_randomize_material_id
category:	"_Edit-Spline"
buttontext:	"Random ID"
tooltip:	"Randomize Spline Material IDs"
(
	global rndMatIDFloater
	global rndMatIDFloaterPos = [407,77]
	global RL_randMatIDs

	rollout RL_randMatIDs "Randomize Spline Mat.IDs"
	(
		radiobuttons rbOptions "" labels:#("Use existing", "Use range") offsets:#([0,4],[4,4]) columns:2 align:#left offset:[0,8]
		spinner spnMinID "min ID" range:[1,999,1] type:#integer fieldwidth:30 align:#left offset:[0,6] across:2 enabled:false
		spinner spnMaxID "max ID" range:[1,999,10] type:#integer fieldwidth:30 align:#right offset:[0,6] enabled:false
		button btnRanSplineIDs "RANDOMIZE IDs" width:150 height:30 align:#center offset:[0,12]

		label txtAbout1 "Randomize Spline Mat.IDs V1.0" align:#center offset:[0,10]
		hyperLink hlinkAbout "www.SplineDynamics.com" color:blue hoverColor:(color 0 255 255) visitedColor:blue address:"http://www.splinedynamics.com" align:#center offset:[0,-2]

		fn randSplineMatIDs shpArr minID:1 maxID:10 useExisting:true =
		(
			for shp in shpArr do (
				nSplines = numsplines shp
				for spl=1 to nSplines do (
					nSegs = numsegments shp spl
					if useExisting then (
						idArr = #()
						for seg=1 to nSegs do appendIfUnique idArr (getMaterialID shp spl seg)
						for seg=1 to nSegs do (
							setMaterialID shp spl seg idArr[(random 1 idArr.count)]
						)
					) else (
						for seg=1 to nSegs do (
							setMaterialID shp spl seg (random minID maxID)
						)
					)
				)
				updateShape shp
			)
		)

		on rbOptions changed state do (
			if state==1 then (
				spnMinID.enabled = false
				spnMaxID.enabled = false
			) else (
				spnMinID.enabled = true
				spnMaxID.enabled = true
			)
		)

		on spnMinID changed val do (
			if val>spnMaxID.value then spnMaxID.value = val
		)

		on spnMaxID changed val do (
			if val<spnMinID.value then spnMinID.value = val
		)

		on btnRanSplineIDs pressed do (

			if selection.count>0 then (
				shpArr = (for obj in selection where (classOf obj.baseObject)==line or (classOf obj.baseObject)==splineShape collect obj) as array
				if shpArr.count>0 then (
					randSplineMatIDs shpArr minID:spnMinID.value maxID:spnMaxID.value useExisting:(if rbOptions.state==1 then true else false)
				) else (
					messageBox "Only Editable Splines allowed."
				)
			) else (
				messageBox "Nothing selected."
			)
		)
	) -- end rollout

	try (
		closerolloutfloater rndMatIDFloater
		rndMatIDFloaterPos = rndMatIDFloater.pos
	) catch()

	rndMatIDFloater = newrolloutfloater "Randomize Spline Mat.IDs V1.0" 200 200
	rndMatIDFloater.pos = rndMatIDFloaterPos
	addrollout RL_randMatIDs rndMatIDFloater rolledup:false

)
