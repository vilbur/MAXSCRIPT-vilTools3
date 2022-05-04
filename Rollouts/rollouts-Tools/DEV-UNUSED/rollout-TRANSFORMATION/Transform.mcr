filein( getFilenamePath(getSourceFileName()) + "/Lib/Transform.ms" )


/*
*/ 
macroscript	rotate_toos_rotate
category:	"_Transform"
buttontext:	"Rotate 90°"
toolTip:	"Rotate about active axis\nDefault 	90\nCtrl	180"
--icon:	"#(path, index)"
(
	_angle = 90
	
	ctrl = keyboard.controlPressed; alt = keyboard.altPressed; shift = keyboard.shiftPressed
	
	--if ctrl == true  and alt == true and shift == true then
	--	print "Control and Alt and Shift"
	--else if ctrl == true  and alt then
	--	print "Control and Alt"
	--else if ctrl == true  and shift == true  then
	--	print "Control and Shift"
	--else
	if ctrl == true then
		_angle = 180 
	--else if alt == true then
	--	print "Alt"
	--else if shift == true  then
	--	print "Shift"
	--else
	--	print "Nothing"
	--print ( "tramsform = " + (tramsform as Point3) as string )
	
	(Transform_v()).rotateSelection _angle
)

/*
*/ 
macroscript	rotate_toos_rotate_back
category:	"_Transform"
buttontext:	"Rotate 90°"
toolTip:	"Rotate about active axis\nDefault	-90\nCtrl	-180"
--icon:	"#(path, index)"
(
	_angle = -90
	
	ctrl = keyboard.controlPressed; alt = keyboard.altPressed; shift = keyboard.shiftPressed
	
	--if ctrl == true  and alt == true and shift == true then
	--	print "Control and Alt and Shift"
	--else if ctrl == true  and alt then
	--	print "Control and Alt"
	--else if ctrl == true  and shift == true  then
	--	print "Control and Shift"
	--else
	if ctrl == true then
		_angle = -180 
	--else if alt == true then
	--	print "Alt"
	--else if shift == true  then
	--	print "Shift"
	--else
	--	print "Nothing"
	--print ( "tramsform = " + (tramsform as Point3) as string )
	
	(Transform_v()).rotateSelection _angle
)

/**  
 *	
 */
macroscript	_transform_type_in
category:	"_Transform"
buttontext:	"Type in"
toolTip:	"Mini Transform Type In"
--icon:	"#(path, index)"
(
	filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/Mini-Transform-Type-In.ms" )
)
/**  
 *	
 */
macroscript	_transform_type_in_close
category:	"_Transform"
buttontext:	"Type in"
toolTip:	"Close dialog\nDOUBLECLICK: Show window border"
--icon:	"#(path, index)"
(
	hwndMove = windows.getChildHWND 0 "Move Transform Type-In"
	UIAccessor.CloseDialog hwndMove[1]
)