
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
icon:	"menu:_Context Spline"
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
--icon:	""
(
	--format "superClassOf $[1]	= % \n" (superClassOf selection[1])
	--if superClassOf selection[1] == shape then
	--(
	--	undo "Explode Shape" on
	--	(
	--		obj = selection[1]
	--
	--		Nsplines	= obj.numSplines
	--
	--		progressStart "Exploding"
	--
	--		for spl = 1 to Nsplines do
	--		(
	--			ns	= splineShape ()
	--			addnewspline ns
	--
	--			for k = 1 to (numKnots obj spl) do
	--			(
	--
	--				knot_pos 	= getKnotPoint obj spl k
	--				seg_type	= getSegmentType obj spl k
	--				knot_type	= getKnotType obj spl k
	--
	--				if knot_type == #bezier or knot_type== #bezierCorner then
	--					addKnot ns 1 knotype seg_type knot_pos (getInVec obj spl k) (getOutVec obj spl k)
	--
	--				 else
	--					 addKnot ns 1 knot_type seg_type knot_pos
	--
	--			)
	--
	--			if (isClosed theobj spl) then close ns 1
	--
	--			updateShape ns
	--
	--			progressUpdate (100.0*spl/Nsplines)
	--
	--		)
	--		progressEnd()
	--	)
	--)
	--else
	--	messageBox "Splines Only"

	local compilerParams = dotNetObject "System.CodeDom.Compiler.CompilerParameters" #(
		getDir #maxRoot + "Autodesk.Max.dll",
		getDir #maxRoot + "\bin\assemblies\Autodesk.Max.Wrappers.dll")
	compilerParams.GenerateInMemory = true

	local compilerResults = (dotNetObject "Microsoft.CSharp.CSharpCodeProvider").CompileAssemblyFromSource compilerParams #(
		"using System;
		using Autodesk.Max;
		using Autodesk.Max.Wrappers;
		using System.Collections.Generic;
		using System.Runtime.InteropServices;

		public static class Const {
			public static readonly IGlobal Global = Autodesk.Max.GlobalInterface.Instance;
		}

		public class ShapeActions {
			public static readonly IClass_ID spline3DClassID = Const.Global.Class_ID.Create((uint)BuiltInClassIDA.SPLINE3D_CLASS_ID, 0);
			public static readonly IClass_ID splineShapeClassID = Const.Global.Class_ID.Create((uint)BuiltInClassIDA.SPLINESHAPE_CLASS_ID, 0);

			public static ISplineShape GetSplineShape() {
				return (ISplineShape)Const.Global.COREInterface14.CreateInstance(SClass_ID.Shape, splineShapeClassID);
			}

			public static IBezierShape GetBezierShapeFromNode(System.UIntPtr animHandle, int time) {
				IINode node = (IINode)Const.Global.Animatable.GetAnimByHandle(animHandle);
				var obj = node.EvalWorldState(time, true).Obj;
				return GetBezierShapeFromShape(obj, time);
			}

			public static IBezierShape GetBezierShapeFromShape(Autodesk.Max.IObject shape, int time) {
				if (shape.CanConvertToType(splineShapeClassID) > 0) {
					ISplineShape spShape = (ISplineShape)shape.ConvertToType(time, splineShapeClassID);
					return (IBezierShape)spShape.Shape;
				}
				else return null;
			}

			public static bool DeleteSplines(System.UIntPtr animHandle, int[] splineIndices, int time) {
				IBezierShape bezShape = GetBezierShapeFromNode(animHandle, time);

				var handle = GCHandle.Alloc(splineIndices, GCHandleType.Pinned);
				bool success = bezShape.DeleteSplines(handle.AddrOfPinnedObject(), (uint)splineIndices.Length);
				if (handle.IsAllocated) handle.Free();

				return success;
			}
		}"
	)

	for err = 0 to compilerResults.errors.count - 1 do print (compilerResults.errors.item[err].ToString())

	shapeActions = compilerResults.CompiledAssembly.CreateInstance "ShapeActions"
	deleteSplines = fn deleteSplines obj splineIndices = with undo off
		(success = shapeActions.DeleteSplines (getHandleByAnim obj) splineIndices currentTime.ticks; updateShape obj; success)

	if isKindOf $ Line or isKindOf $ SplineShape then with undo on
	(
		obj = $
		if isKindOf obj Line do with redraw off (addModifier obj (Edit_Spline()); maxOps.CollapseNode obj on)

		splineCount = numSplines obj
		detachedSplines = for s = 1 to splineCount collect
		(
			newSpline = copy obj isHidden:on
			otherSplines = for ss = 1 to splineCount where ss != s collect ss - 1

			format "success: %\n" (deleteSplines newSpline otherSplines)
			newSpline
		)
		unhide detachedSplines
		select detachedSplines
		gc light:on
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
buttontext:	"Rand ID"
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

	/*
Spline Select Tool v1.0 (05/2012)

tested on 3ds Max 2013
Dot selection allows to select vertices or segments with gaps specified in the n-space spinner.
Random selection use a percent value.
By angle selection use a min-max value in degree.
The selection is only applied on the splines that have at least one vertex or segment selected.
*/
macroscript	_spline_select_tools
category:	"_Edit-Spline"
buttontext:	"Select Tools"
tooltip:	"Spline Select Tools"
(


	fn dotVertSelect dotSpace splID knotID nKnots =
	(
		knotsArr = #()
		for i = knotID to nKnots by dotSpace do append knotsArr i
		setknotselection $ splID knotsArr
	)

	fn dotSegSelect dotSpace splID segID nSegs =
	(
		segArr = #()
		for i = segID to nSegs by dotSpace do append segArr i
		setsegselection $ splID segArr
	)

	fn randVertSelect splID nKnots prc =
	(
		selPrc = nKnots * prc / 100
		randVerts = #()
		if selPrc > 0 do
		(
			for i = 1 to selPrc do
			(
				append randVerts (random 1 nKnots)
			)
			setknotselection $ splID randVerts
		)
	)

	fn randSegSelect splID nSegs prc =
	(
		selPrc = nSegs * prc / 100
		randSegs = #()
		if selPrc > 0 do
		(
			for i = 1 to selPrc do
			(
				append randSegs (random 1 nSegs)
			)
			setsegselection $ splID randSegs
		)
	)

	fn selVertsbyAngle splID degMin degMax =
	(
		TabAngle = #()
		vertArr = #()
		for i = 1 to numknots $ splID do
		(
			if i == 1 then a = numknots $ splID else a = i-1
			b = i
			if i == numknots $ splID then c = 1 else c = i+1
			a = getknotpoint $ splID a
			b = getknotpoint $ splID b
			c = getknotpoint $ splID c
			v1 = a-b
			v2 = c-b
			N1 = normalize V1
			N2 = normalize V2
			An = acos (dot N1 N2)
			TabAngle[i] = An
		)
		id = 0
		for j in TabAngle do
		(
			id += 1
			if id > 1 and id < numknots $ splID do
			(
				if j < degMax and j > degMin  do append vertArr id
			)
		)
		setknotselection $ splID vertArr
	)

	fn isSpline obj = classof obj == splineshape or classof obj == line

	rollout SplineSelectTool "Spline Select Tool" width:162 height:308
	(
		button dotVerts "Select every n-vertices" pos:[10,46] width:141 height:27
		button dotSegs "Select every n-segments" pos:[10,77] width:141 height:27
		spinner nspace "n-Space" pos:[69,23] width:82 height:16 type:#integer
		spinner percentSel "Percent selected" pos:[35,139] width:117 height:16 range:[0,100,0] type:#integer
		button RandVert "Random vert. selection" pos:[10,160] width:141 height:27
		button RandSegs "Random seg. selection" pos:[10,191] width:141 height:27
		spinner degmin "min" pos:[21,276] width:56 height:16 range:[0,180,0] type:#integer
		spinner degmax "max" pos:[92,276] width:56 height:16 range:[0,180,180] type:#integer
		button AnVerts "Select vert. by angle" pos:[10,244] width:141 height:27
		groupBox grp1 "Dot Selection" pos:[6,6] width:151 height:104
		groupBox grp2 "Random selection" pos:[6,120] width:150 height:103
		groupBox grp3 "By Angle Selection" pos:[7,228] width:149 height:72
		on dotVerts pressed  do
		(
			if isSpline $ do
			(
				for i = 1 to numsplines $ do if (knotSel = getknotselection $ i).count > 0 do dotVertSelect nspace.value i knotSel[1] (numknots $ i)
			)
		)
		on dotSegs pressed  do
		(
			if isSpline $ do
			(
				for i = 1 to numsplines $ do if (segSel = getsegselection $ i).count > 0 do dotSegSelect nspace.value i segSel[1] (numsegments $ i)
			)
		)
		on RandVert pressed  do
		(
			if isSpline $ do
			(
				for i = 1 to numsplines $ do if (getknotselection $ i).count > 0 do randVertSelect i (numknots $ i) percentSel.value
			)
		)
		on RandSegs pressed  do
		(
			if isSpline $ do
			(
				for i = 1 to numsplines $ do if (getsegselection $ i).count > 0 do randSegSelect i (numsegments $ i) percentSel.value
			)
		)
		on AnVerts pressed  do
		(
			if isSpline $ do
			(
				for i = 1 to numsplines $ do if (getknotselection $ i).count > 0 do selVertsbyAngle i degmin.value degmax.value
			)
		)
	)
	createdialog SplineSelectTool

)
