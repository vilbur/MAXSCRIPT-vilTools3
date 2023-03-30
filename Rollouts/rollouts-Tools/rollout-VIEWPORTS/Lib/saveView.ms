

try(destroyDialog ::saveViewDialog)catch()

rollout saveViewDialog "Store & Restore Views"
(
	global vpData = Dictionary #string

	local views = #(#view_persp_user, #view_iso_user, #view_top, #view_bottom, #view_left, #view_right, #view_front, #view_back, #view_spot, #view_camera)

	struct ViewData_v
	(
		vpType	= #view_none,
		vpGroupType	= #user,
		vpStartCoord	= [0,0,0],
		vpEndCoord	= [0,0,0],
		vpVS	= [0,0],
		vpFOV	= 0,
		vpFD	= 0,
		vpTM	= undefined,
		vpNode	= undefined
	)


	fn checkVT views vt =
	(
		local idx = (findItem views vt)
		case of
		(
			(idx > 0 and idx < 3): #user
			(idx > 2 and idx < 9): #ortho
			(idx > 8): #camlight
			(idx == 0):  undefined
		)
	)

	fn minmaxSwap p3min p3max =
	(
		if p3min.x > p3max.x do swap p3min.x p3max.x
		if p3min.y > p3max.y do swap p3min.y p3max.y
		if p3min.z > p3max.z do swap p3min.z p3max.z
		#(p3min, p3max)
	)

	fn collectViewportData supportedViews:views mark: =
	(
		local ViewData = ViewData_v()
		local bounds = minmaxSwap ((MapScreenToView [0,0] 0) * Inverse(getViewTM())) ((MapScreenToView (GetViewSize()) 0) * Inverse(getViewTM()))

		ViewData.vpType	= viewport.getType()
		ViewData.vpGroupType	= checkVT supportedViews ViewData.vpType
		ViewData.vpStartCoord	= bounds[1]
		ViewData.vpEndCoord	= bounds[2]
		ViewData.vpVS	= GetViewSize()
		ViewData.vpFOV	= getViewFOV()
		ViewData.vpFD	= viewport.getFocalDistance()
		ViewData.vpTM	= viewport.getTM()
		ViewData.vpNode	= if (node = viewport.getCamera()) != undefined do (setUserProp node "vpdProp" mark ; node)
		ViewData
	)

	fn restoreViewport ViewData =
	(
		local deadData = off
		viewport.SetType ViewData.vpType
		case ViewData.vpGroupType of
		(
			#user:
			(
				viewport.setTM ViewData.vpTM
				if ViewData.vpType == #view_persp_user then (viewport.SetFOV ViewData.vpFOV ; viewport.SetFocalDistance ViewData.vpFD)
				else (viewport.ZoomToBounds off ViewData.vpStartCoord ViewData.vpEndCoord ; viewport.zoom (ViewData.vpFOV/(viewport.getFOV())))
			)
			#ortho:
			(
				viewport.ZoomToBounds off ViewData.vpStartCoord ViewData.vpEndCoord
				viewport.zoom (ViewData.vpFOV/(viewport.getFOV()))
			)
			#camlight: (if isValidNode ViewData.vpNode and viewport.canSetToViewport ViewData.vpNode then viewport.setCamera ViewData.vpNode else deadData = on)
		)
		completeredraw()
		deadData
	)

	fn p2Top3 value = (point3 value.x value.y 0)

	fn p3Top2 value = (point2 value.x value.y)

	fn checkRN = isProperty rootNode #vpKeys

	fn checkDICT dict = (dict.keys.count != 0)

	fn loadVPD = if (checkDICT()) then rootNode.vpData.keys else #()

	fn addCA =
	(
		if not (checkRN()) do
		(
			local vpdCA = attributes viewportDataAtt version:17 attribID:(genClassID returnValue:on)
			(
				parameters vdp
				(
					vpRollPos	type:#point2	default:[0,0]
					vpKeys	type:#stringTab	tabSizeVariable:on
					vpTypes	type:#stringTab	tabSizeVariable:on
					vpGroupTypes	type:#stringTab	tabSizeVariable:on
					vpStartCoords	type:#point3Tab	tabSizeVariable:on
					vpEndCoords	type:#point3Tab	tabSizeVariable:on
					vpVSs	type:#point3Tab	tabSizeVariable:on
					vpFOVs	type:#floatTab	tabSizeVariable:on
					vpFDs	type:#floatTab	tabSizeVariable:on
					vpTMs	type:#matrix3Tab	tabSizeVariable:on
					vpNodes	type:#nodeTab	tabSizeVariable:on
				)
			)
			custAttributes.add rootNode vpdCA
		)
	)

	fn deleteCA = if (checkRN()) do
	(
		local caVPD
		if (c = custAttributes.count rootNode) > 0 do (for i = 1 to c where (vpdCA = custAttributes.getdef rootNode i).name == #viewportDataAtt do (caVPD = vpdCA))
		if isKindOf caVPD AttributeDef do custAttributes.delete rootNode caVPD
	)

	fn findNode nodes ks: = (for n in nodes where (getUserProp n "vpdProp" == ks) collect n)[1]

	fn freeVPData =
	(
		rootNode.vpKeys = #() ; rootNode.vpTypes = #() ; rootNode.vpGroupTypes = #() ; rootNode.vpStartCoords = #() ; rootNode.vpEndCoords = #()
		rootNode.vpVSs = #() ; rootNode.vpFOVs = #() ; rootNode.vpFDs = #() ; rootNode.vpTMs = #() ; rootNode.vpNodes = #()
	)

	fn getVPData dict =
	(
		free dict

		for k = 1 to rootNode.vpKeys.count do PutDictValue dict rootNode.vpKeys[k] \
		(
			ViewData	= ViewData_v()
			ViewData.vpType	= rootNode.vpTypes[k] as name
			ViewData.vpGroupType	= rootNode.vpGroupTypes[k] as name
			ViewData.vpStartCoord	= rootNode.vpStartCoords[k]
			ViewData.vpEndCoord	= rootNode.vpEndCoords[k]
			ViewData.vpVS	= p3TOp2 rootNode.vpVSs[k]
			ViewData.vpFOV	= rootNode.vpFOVs[k]
			ViewData.vpFD	= rootNode.vpFDs[k]
			ViewData.vpTM	= rootNode.vpTMs[k]
			if ViewData.vpGroupType == #camlight and isValidNode (node = findNode rootNode.vpNodes ks:rootNode.vpKeys[k]) do (ViewData.vpNode = node) ; ViewData
		)
		dict
	)


	fn setVPData dict =
	(
		freeVPData()

		rootNode.vpRollPos = getDialogPos saveViewDialog

		for k in dict.keys do
		(
			ViewData = dict[k]
			append rootNode.vpKeys k
			append rootNode.vpTypes (ViewData.vpType as string)
			append rootNode.vpGroupTypes (ViewData.vpGroupType as string)
			append rootNode.vpStartCoords ViewData.vpStartCoord
			append rootNode.vpEndCoords ViewData.vpEndCoord
			append rootNode.vpVSs (p2TOp3 ViewData.vpVS)
			append rootNode.vpFOVs ViewData.vpFOV
			append rootNode.vpFDs ViewData.vpFD
			append rootNode.vpTMs ViewData.vpTM

			if ViewData.vpGroupType == #camlight and isValidNode ViewData.vpNode and (getUserProp ViewData.vpNode "vpdProp" == k) do append rootNode.vpNodes ViewData.vpNode
		)
	)





	button btn_add "Add View" pos:[5,5] width:72 height:21 tooltip:"Store or Update View"
	button btn_delete "Remove" pos:[80,5] width:72 height:21 tooltip:"LMB - Remove Selected View From List\nRMB - Remove All Stored Vievs"
	combobox cbx_views "" pos:[5,30] width:148 height:15 selection:0



	on btn_add pressed do if (vt = viewport.getType()) == undefined then messageBox "This view is not supported" title:"Warning" beep:off else
	(
		if cbx_views.text != "" do
		(
			if not (checkRN()) do addCA()

			value = vpData.keys.count

			if (checkVT views vt) != undefined do PutDictValue vpData cbx_views.text (collectViewportData mark:cbx_views.text)

			if value < vpData.keys.count do cbx_views.items = sort (GetDictKeys vpData)

			cbx_views.selection = 0 ; setVPData vpData
		)
	)



	on btn_delete pressed do if (checkDICT vpData and cbx_views.text != "") do
	(
		if (ViewData = GetDictValue vpData cbx_views.text).vpGroupType == #camlight do (if isValidNode ViewData.vpNode do setUserProp ViewData.vpNode "vpdProp" "")
		RemoveDictValue vpData cbx_views.text ; cbx_views.selection = 0
		if (checkDICT vpData) then (cbx_views.items = sort (GetDictKeys vpData) ; setVPData vpData)
		else (freeVPData() ; free vpData ; cbx_views.items = #())
	)
	on btn_delete rightclick do if (checkDICT vpData) do
	(
		for k in vpData.keys do
		(
			ViewData = GetDictValue vpData k
			if ViewData.vpGroupType == #camlight and isValidNode ViewData.vpNode do setUserProp ViewData.vpNode "vpdProp" ""
		)
		freeVPData() ; free vpData ; cbx_views.items = #() ; cbx_views.selection = 0
	)
	on cbx_views doubleClicked idx do if (checkDICT vpData) do
	(
		if (HasDictValue vpData cbx_views.items[idx]) do
		(
			if restoreViewport (GetDictValue vpData cbx_views.items[idx]) do btn_delete.pressed()
		)
	)
	on saveViewDialog open do
	(
		if (checkRN()) do
		(
			setDialogPos saveViewDialog rootNode.vpRollPos ; getVPData vpData ; cbx_views.items = sort (GetDictKeys vpData)
		)
	)
	on saveViewDialog moved pos do if (checkRN()) do rootNode.vpRollPos = pos
)

CreateDialog saveViewDialog 158 245 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)