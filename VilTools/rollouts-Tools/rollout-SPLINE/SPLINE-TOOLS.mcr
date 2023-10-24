

macroscript	_spline_from_vertex_generator
category:	"Spline-Tools"
buttontext:	"Vertex To Spline"
tooltip:	"Vertex To Spline Generator"
(
	filein( getFilenamePath(getSourceFileName()) + "/Lib/VertexToSpline/VertexToSpline.ms" )	-- "./Lib/VertexToSpline/VertexToSpline.ms"

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
category:	"Spline-Tools"
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
