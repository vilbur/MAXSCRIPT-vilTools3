

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

macroscript spline_to_maxscript
category:	"Spline-Tools"
buttontext:	"Spline To MXS"
toolTip:"splineToMXS: Returns/Prints the currently selected shape objects to MAXScript code."
--Icon:#("Maxscript",3)
(
	--
	-- splineToMXS - Michael B. Comet - comet@comet-cartoons.com - http://www.comet-cartoons.com/
	--		Copyright ©2002 Michael B. Comet  All Rights Reserved
	--
	--	For info/help read function comments below
	--
	
	-- -----------------------------------------------------------------------------------------------
	-- Helper procs
	-- -----------------------------------------------------------------------------------------------
	
	fn executeString s = (if classof s == stringstream then seek s 0; execute s)
	fn appendString s add = (format "%" add to:s)
	
	/*
	 * replaceChar() - Given a string replaces all occurences of character f (from) with
	 *					character t (to)
	 */
	fn replaceChar str f t =
	(
		if (str == "" or str == undefined) then
			return "";
	
		len = str.count;
	
		for i in 1 to len do
			(
			if (str[i] == f) then	-- replace it needed
				str[i] = t;
			)
	
		return str;
	)
	
	-- -----------------------------------------------------------------------------------------------
	--	Main Proc
	-- -----------------------------------------------------------------------------------------------
	
	/*
	 * splineTpMXS() - This will take any selected "Editable Spline Object" and will convert
	 *					it to a MAXScript Function that you can run to recreate it.  Useful
	 *					for building control objects for rigging.  Just draw whatever you want,
	 *				    then select it, and run this function.  The object must be a "line"
	 *					or be converted to "Editable Spline" before trying to export.
	 *
	 *					Note that the objects transform (ie: pos, rotation etc...) doesn't matter.
	 *						The exported function will recreate the spline shape at 0,0,0 relative
	 *						to the original object itself.  This means you MAY need to do a
	 *						"Reset XForm" on the shape before exporting.
	 *
	 *					You can then take that code and add it as a toolbar button or into
	 *					 your own scripts to easily recreate that shape.
	 *
	 *					This proc even retain the Object's name and the Wireframe color, so
	 *						that the created object will be identical.  (The name may be 01, 02, etc...)
	 *
	 *					The name of the function that it creates will be called "create<OBJNAME>Shape()".
	 *
	 *					This returns the MAXScript code as a stringstream value.  And should appear
	 *						also in the listener window.
	 */
	fn splineToMXS =
	(
		str = stringstream "";
	
		objs = getCurrentSelection();
	
		for o in 1 to objs.count do
			(
			if (classOf objs[o] == SplineShape or classOf objs[o] == line) then
				(
				format "-- Exporting %\n" objs[o].name;
	
					-- Make sure function name has no spaces.
				fnName = replaceChar objs[o].name " " "_";
	
				appendString str ("-- Start of Shape Creation Proc\n");
				appendString str ("-- \n");
				appendString str ("fn create"+fnName +"Shape = \n");
				appendString str ("(\n\n");
	
				appendString str ("\tln = line();\n");
	
				ns = numSplines objs[o]
				for si in 1 to ns do
					(
					appendString str ("\tsplIdx = addNewSpline ln;\n");
	
					nk = numKnots objs[o] si;	-- how many knots in this spline?
					for k in 1 to nk do
						(
						type = getKnotType objs[o] si k;
	
						coordsys objs[o];
							(
	
							pos = getKnotPoint objs[o] si k;
	
							appendString str ("\t\taddKnot ln splIdx #"+(type as string)+" #curve "+(pos as string));
	
							if (type == #bezier or type == #bezierCorner) then
								(
								invec = getInVec objs[o] si k;
								outvec = getOutVec objs[o] si k;
								appendString str (" "+(invec as string)+" "+(outvec as string));
								)
	
							appendString str (";\n");
	
							)  -- end off coordsys
	
						)  -- end of knot loop
	
					closed = isClosed objs[o] si;
	
					if (closed == true) then
						appendString str ("\tclose ln splIdx;\n");
					else
						appendString str ("\topen ln splIdx;\n");
	
					)	-- end of splineIndex loop
	
				appendString str ("\tupdateShape ln;\n");
				appendString str ("\tconvertToSplineShape ln;\n");
	
				origColor = objs[o].wireColor;
				appendString str ("\tln.wireColor = "+(origColor as string)+";\n");
				appendString str ("\tln.name = uniqueName \""+(objs[o].name)+"\";\n");
				appendString str ("\tselect ln;\n");
				appendString str ("\treturn ln;\n");
	
				appendString str ("\n)\n");
				appendString str ("-- \n");
				appendString str ("-- End of Shape Creation Proc\n");
				)
	
			)
	
		format "-- splineToMXS OUTPUT:\n\n"
		format "%\n" (str as string);
		format "\n\n";
	
		appendString str ("");
	
		return str;
	)
	
	-- now just do it for the macro!
	splineToMXS();

)

/*
*/
macroscript	_spline_from_vertex_generator
category:	"Spline-Tools"
buttontext:	"Vertex To Spline"
tooltip:	"Generate splines to ground from verts of object"
(
	filein( getFilenamePath(getSourceFileName()) + "/Lib/VertexToSpline/VertexToSpline.ms" )	-- "./Lib/VertexToSpline/VertexToSpline.ms"

)
