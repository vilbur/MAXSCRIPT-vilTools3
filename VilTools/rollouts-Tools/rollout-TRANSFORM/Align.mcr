filein( getFilenamePath(getSourceFileName()) + "/Lib/Gizmo.ms" )

/** SCALE DOES NOT WORK
  *
  */
macroscript	_Transform_align
category:	"_Transform-Align"
buttontext:	"Quick Align"
--toolTip:	"Align by current active tool."
icon:	"Tooltip:ALIGN BY current active TOOL and AXIS.\n  \nLast object is King (\"THIS & THIS TO HERE\")\n  \nMove Tool:   Align position \nRotate Tool: Align rotation \nSelect Tool: Align all transform."

(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\Align.mcr"

	if( selection.count < 2 ) then
		return messageBox "Select 2 obejcts at least" title:"QUICK ALIGN"  beep:false

	master_object = selection[ selection.count ]

	align_objects = deleteItem ( selection as Array ) selection.count

	axises = #( #x, #y, #z )

	active_axises = toolMode.axisConstraints

	transform_type = case toolMode.commandmodeID of
						(
							1: #position
							2: #rotation
							--3: #scale
							--4: #scale
							--5: #scale
							6: #all -- select tool
							default: #all
						)

	master_position = master_object.position

	undo "Quick Align" on
	(
		for align_obj in align_objects do
			for i = 1 to ( active_axises_string = active_axises as string ).count do
			(
				axis_index = findItem axises (active_axises_string[i] as name )

				case transform_type of
				(
					#all:      align_obj.transform = master_object.transform

					#position: align_obj.position.controller[axis_index].value = master_object.position.controller[axis_index].value
					#rotation: align_obj.rotation.controller[axis_index].value = master_object.rotation.controller[axis_index].value
					--#scale:    align_obj.transform.scale     = master_object.transform.scale
				)

			)
	)

	redrawViews()
)



/** Screen: http://www.breidt.net/scripts/pics/3pt_align.gif
  *
  */

macroscript ThreePointAlign
ButtonText:"3Pt Align"
Category:"_Transform-Align"
Tooltip:"3Pt Align"

-- ThreePointAlign v 1.31 - 04.09.17 - (c) M. Breidt (martin@breidt.net)
--
-- This code is released under "Quote ware" license:
--      If you use this tool in a production environment with a group of more than two people,
--      or have used it in the past under such conditions, then you are obliged to tell
--      me (martin@breidt.net) about it and allow me to list that project title and your
--      company name as a reference on my website http://scripts.breidt.net
--
-- Installation:
-- After executing this file (MAXScript > Run Script), there will be a new
-- entry named '3Pt Align' in Customize > Customize User Interface in the
-- category 'MB Tools'. Just assign a hotkey, or put it in a quad menue or
-- toolbar.
--
-- Usage:
-- Select any object, then invoke macro. Pick three source points (1-3)
-- in the viewport (you might want to turn on vertex snap); then select
-- three target points (4-6).
-- The selected object will be realigned in 3D space in such a way that
--   * Point 1 and Point 4 will coincide
--   * Point 1-3 will be on the plane of Point 4-6
--   * The line (Point 1->2) will be parallel to line (Point 4->5)
-- After you picked the last point, a dialog will be presented that allows
-- for further modification: you can flip the orientation of the aligment,
-- you can offset the aligned object along the alignment plane's normal,
-- and you can apply a uniform scaling around the first point (or have it
-- computed automatically based on the distance between points 1 and 2)
--
-- Known limitations:
-- If you invert the alignment, the aligned object will have negative scaling
-- which might cause problems at a later stage.

(
	struct pointdata (pos, txt, col)		-- Data structure for storing viewport marker data
	global ThreePtAlignMarkers = #()	-- viewport marker list
	global ThreePtAlignActive = false	-- flag for isChecked() (e.g. button highlighting)

	-- callback function that draws all viewport markers found in ThreePtAlignMarkers
	fn drawCoord = (
		gw.setTransform(Matrix3 1)
		local i
		-- print "--- Redraw"
		for i in ThreePtAlignMarkers do (
			-- print i.txt
			p = gw.hTransPoint i.pos
			gw.hText p i.txt color:i.col
			gw.hMarker p #smallHollowBox color:[255,255,255]
		)
		if ThreePtAlignMarkers.count > 1 then (
			gw.SetColor #line [255,255,0]
			gw.hPolyline #(gw.hTransPoint ThreePtAlignMarkers[1].pos, gw.hTransPoint ThreePtAlignMarkers[2].pos) false
		)
		if ThreePtAlignMarkers.count > 2 then (
			gw.SetColor #line [0,255,255]
			gw.hPolyline #(gw.hTransPoint ThreePtAlignMarkers[1].pos, gw.hTransPoint ThreePtAlignMarkers[3].pos) false
		)
		if ThreePtAlignMarkers.count > 3 then (
			gw.SetColor #line [255,0,0]
			gw.hPolyline #(gw.hTransPoint ThreePtAlignMarkers[1].pos, gw.hTransPoint ThreePtAlignMarkers[4].pos) false
		)
		if ThreePtAlignMarkers.count > 4 then (
			gw.SetColor #line [255,255,0]
			gw.hPolyline #(gw.hTransPoint ThreePtAlignMarkers[4].pos, gw.hTransPoint ThreePtAlignMarkers[5].pos) false
		)
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
	)

	-- returns the transformation matrix which will transform a point from world into
	-- the coordinate system derived from p1-p2 and p1-p3
	fn localMatrix p1 p2 p3 = (
		v1 = normalize (p2 - p1)
		v3 = normalize (cross v1 (normalize (p3 - p1)))
		v2 = normalize (cross v3 v1)
		return matrix3 v1 v2 v3 p1
	)

	-- returns the scaling factor needed to scale a02-a01 into b02-b01
	fn computeAutoScale = (
		if ThreePtAlignMarkers.count>4 then (
			length(ThreePtAlignMarkers[5].pos-ThreePtAlignMarkers[4].pos)/length(ThreePtAlignMarkers[2].pos-ThreePtAlignMarkers[1].pos)
		) else 1.0
	)

	-- creates a temporary marker (red sphere, green box, blue box) at position p
	fn createMarker p type = (
		return case type of (
			#sphere:	(undo off Sphere pos:p radius:5 segments:8 wirecolor:[255,0,0])
			#box1:		(undo off Box pos:(p-[0,0,5]) width:10 length:10 height:10 wirecolor:[0,255,0])
			#box2:		(undo off Box pos:(p-[0,0,5]) width:10 length:10 height:10 wirecolor:[0,0,255])
		)
	)

	local myObj			-- local global variable which object should be moved
	local dialog_ok		-- local global variable with result of dialog (OK/Cancel)
	local trgtPlane, srcPlane, old_transform
	local uniScale = 1.0

	-- Dialog for transformation after six points have been selected
	-- expects: node in myObj, original transformation in old_transform,
	--          source and target matrix in srcPlane and trgtPlane
	rollout option_ro "3Pt Align Options" (
		local start_transform		-- object transformation upon start of dialog
		local scale = 1
		local trans = 0

		-- transformation update function including mirroring and offset
		fn transformObj = (
			myObj.transform = start_transform * (inverse trgtPlane) * transMatrix [0,0,trans] * scaleMatrix [uniScale, uniScale, (uniscale*scale)] * trgtPlane
		)

		-- User Interface
		label l1 "3Pt Align v1.31" align:#center
		label l2 "© 03-18 M. Breidt" align:#center
		hyperLink hl "(martin@breidt.net)" address:"mailto:martin@breidt.net" align:#center
		checkbox inv_align "Invert alignment" align:#center
		spinner offset_s "Z Offset:" type:#worldunits range:[-1e10, 1e10, 0] align:#center tooltip:"Offset along the z axis (direction perpendicular to p1-p2 and p1-p3)"

		spinner scale_s "Scale:" type:#float range:[-1e8, 1e8, 100*uniScale] align:#center enabled:false tooltip:"Uniform scaling of object"
		checkbox autoscale "Auto Scale" align:#center checked:true tooltip:"Enable to automatically compute uniform scaling based on the distance between points 1 and 2"

		button ok_b "OK" across:2 width:65 tooltip:"Complete alignment process"
		button cancel_b "Cancel" width:65 tooltip:"Cancel aligment and restore original transformation"

		-- Event Handler
		on option_ro open do (
			if autoscale.checked then uniScale = computeAutoScale() 		-- compute autoscale factor
			scale_s.value = uniScale*100
			-- do initial transform
			myObj.transform = old_transform * (inverse srcPlane) * trgtPlane
			-- store start values
			start_transform = myObj.transform
			scale = 1
			trans = 0
			transformObj()
		)
		on inv_align changed checkstate do (
			scale *= -1
			transformObj()
		)
		on offset_s changed val do (
			trans = val
			transformObj()
		)
		on autoscale changed checkstate do (
			scale_s.enabled = not checkstate
			if checkstate then (
				-- recompute scaling
				uniScale = computeAutoScale()
				scale_s.value = uniScale*100
				transformObj()
			) else (
				-- switch to 100% scale (= original size)
				uniScale = 1
				scale_s.value = 100
				transformObj()
			)
		)
		on scale_s changed val do (
			uniScale = val/100.0
			transformObj()
		)
		on ok_b pressed do (
			dialog_ok = true
			format "3Pt Align done.\n"
			ThreePtAlignActive = false
			destroyDialog option_ro
		)
		on cancel_b pressed do (
			dialog_ok = false
			myObj.transform = old_transform 	-- restore original transformation
			format "\n*** 3Pt Align canceled ***\n"
			ThreePtAlignActive = false
			destroyDialog option_ro
		)
	)

	on isEnabled do (selection.count > 0)

	on isChecked do ThreePtAlignActive

	on execute do (
		local canceled = true	-- we assume the user has canceled the operation until we know otherwise
		local oldSnapMode = snapMode.active
		snapMode.active = true
		ThreePtAlignActive = true

		-- clean viewport marker list
		ThreePtAlignMarkers = #()
		unregisterRedrawViewsCallback drawCoord
		registerRedrawViewsCallback drawCoord

		dialog_ok = false
		if (classOf (a01 = pickPoint prompt:"Pick 1st source point" snap:#3D) == Point3) then (
			format "%\n" a01
			append ThreePtAlignMarkers (pointdata pos:a01 txt:"Point A1" col:[255,0,0])
			if (classOf (a02 = pickPoint prompt:"Pick 2nd source point" snap:#3D rubberBand:a01) == Point3) then (
				format "%\n" a02
				append ThreePtAlignMarkers (pointdata pos:a02 txt:"Point A2" col:[0,255,0])
				if (classOf (a03 = pickPoint prompt:"Pick 3rd source point" snap:#3D rubberBand:a01) == Point3) then (
					format "%\n\n" a03
					append ThreePtAlignMarkers (pointdata pos:a03 txt:"Point A3" col:[0,0,255])
					-- next 3 points
					if (classOf (b01 = pickPoint prompt:"Pick 1st destination point" snap:#3D) == Point3) then (
						format "%\n" b01
						append ThreePtAlignMarkers (pointdata pos:b01 txt:"Point B1" col:[255,0,0])
						if (classOf (b02 = pickPoint prompt:"Pick 2nd destination point" snap:#3D rubberBand:b01) == Point3) then (
							format "%\n" b02
							append ThreePtAlignMarkers (pointdata pos:b02 txt:"Point B2" col:[0,255,0])
							if (classOf (b03 = pickPoint prompt:"Pick 3rd destination point" snap:#3D rubberBand:b01) == Point3) then (
								format "%\n" b03
								append ThreePtAlignMarkers (pointdata pos:b03 txt:"Point B3" col:[0,0,255])
								myObj = selection[1]					-- store object that will be transformed
								while (isGroupMember myObj) do
									myObj=myObj.parent					-- find group head
								if (isValidNode myObj) then (
									old_transform = myObj.transform		-- backup current transformation for dialog cancel
									-- get local coordinate systems
									srcPlane = localMatrix a01 a02 a03
									trgtPlane = localMatrix b01 b02 b03
									-- clean up viewport markers once markers have been defined
									unregisterRedrawViewsCallback drawCoord
									-- open modeless dialog that handles transformation and options
									createDialog option_ro
									canceled = false
								) else (
									format "Error! Cannot find parent object!\n"
								) -- end: if isValidNode
							) -- end: if b03
						) -- end: if b02
					) -- end: if b01
				) -- end: if a03
			) -- end: if a02
		) -- end: if a01
		if canceled then (	-- user has not entered all 6 points
			unregisterRedrawViewsCallback drawCoord
			ThreePtAlignActive = false
			format "\n*** 3Pt Align canceled ***\n"
		)
		snapMode.active = oldSnapMode
	) -- on execute
) -- macroscript

macroscript ThreePointAlign_help
ButtonText:"3Pt Align"
category:	"_Transform-Align"
Tooltip:"3Pt Align"
(
     image_path = ( getFilenamePath(getSourceFileName()) + "/Help/3point_align_help.png" )	-- "./Help/3point_align_help.png"

	DOSCommand ("start \"\" \""+image_path+"\"")
)


/**
  *
  */
macroscript	_Transform_move_objects_to_selection_center
category:	"_Transform-Align"
buttontext:	"Move To Center"
toolTip:	"Move selected objects to selection center"
icon:	"MENU:true"

(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\Align.mcr"

	if( selection.count < 2 ) then
		return messageBox "Select 2 obejcts at least" title:"Move To Center"  beep:false


	selection_center = selection.center


	for obj in selection do
		obj.pos = selection_center
)

