clearListener(); print("Cleared in:"+getSourceFileName())

global GetShapeNotification

fn GetShapeNotification =
(
	local hwnd = dialogMonitorOps.getWindowHandle()
	local dialogTitle = uiAccessor.getWindowText hwnd
	if (dialogTitle == "Pick Object") then (
		local dialogChildren = windows.getChildrenHWND hwnd
		UIAccessor.SetWindowText dialogChildren[15][1]  stShapeName
		UIAccessor.PressDefaultButton()
	)
	true
) --end fn GetShapeNotification =

fn GenerateLoft nodePath =
(
	--constants for windows messages
	select nodePath

	--loft creation
	macros.run "Objects Compounds" "Loft"
	local mainHWND = windows.getDesktopHWND()

	local children = windows.getChildrenHWND mainHWND
	local stToSearch = "Get Shape"
	local btnGetShape = undefined
	for child in children where child[5] == stToSearch do btnGetShape = child
	local btnGetShape_hwnd = btnGetShape[1]
	UIAccessor.pressButton btnGetShape_hwnd

	--Get shape
	DialogMonitorOPS.RegisterNotification GetShapeNotification id:#GetShapePopUp
	DialogMonitorOPS.enabled = true
	max tool hlist
	DialogMonitorOPS.unRegisterNotification id:#GetShapePopUp --not needed more
	DialogMonitorOPS.enabled = false
	UIAccessor.pressButton btnGetShape_hwnd
	local nodeLoft = selection[1]
	--do what you want with the loft

)

 (
 	local stShapeName = "Shape"

 	delete objects
 	local nodePath = SplineShape name:"Path"

 	addNewSpline nodePath

 	for i = 0 to 50 by 10 do
 		addKnot nodePath 1 #smooth #curve [random -10 10, i,0]

    local nodeShape = splineShape name:"Shape"

 	addNewSpline nodeShape
 	addKnot nodeShape 1 #corner #curve [1, 0,0]
 	addKnot nodeShape 1 #corner #curve [1, 1,0]
 	addKnot nodeShape 1 #corner #curve [-1, 1,0]
 	addKnot nodeShape 1 #corner #curve [-1, 0,0]
 	stShapeName = nodeShape.name

 	GenerateLoft nodePath
 )

delete objects
