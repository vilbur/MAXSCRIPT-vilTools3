
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
