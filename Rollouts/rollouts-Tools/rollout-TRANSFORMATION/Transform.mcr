filein( getFilenamePath(getSourceFileName()) + "/Lib/Transform.ms" )


/*
*/ 
macroscript	rotate_toos_rotate
category:	"_Transform"
buttontext:	"Rotate 90°"
toolTip:	"Rotate about active axis"
--icon:	"#(path, index)"
(
	(Transform_v()).rotateSelection(90)
)

/*
*/ 
macroscript	rotate_toos_rotate_reverse
category:	"_Transform"
buttontext:	"Rotate 90°"
toolTip:	"Rotate about active axis"
--icon:	"#(path, index)"
(
	(Transform_v()).rotateSelection(-90)
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