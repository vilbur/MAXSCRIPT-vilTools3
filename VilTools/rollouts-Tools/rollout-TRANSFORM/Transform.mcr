filein( getFilenamePath(getSourceFileName()) + "/Lib/Transform.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/SnapManager/SnapManager.ms" )	-- "./Lib/SnapManager/SnapManager.ms"


/**
 *
 */
macroscript	_transform_randomizer
category:	"_Transform"
buttontext:	"Randomizer"
toolTip:	"Open Transform Randomizer Rollout"
--icon:	"#(path, index)"
(
	filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/Random-Transform/random_transform_v1.ms" )
)

/**
 *
 */
macroscript	_transform_reset_xform
category:	"_Transform"
buttontext:	"Reset xForm"
toolTip:	"Reset xForm of selected objects"
--icon:	"#(path, index)"
(
	for obj in selection where superClassOf obj == GeometryClass do
	(
		ResetXForm obj

		modPanel.addModToSelection (XForm ()) ui:on

		convertTo obj Editable_Poly
	)
)

/*
*/
macroscript	rotate_toos_rotate
category:	"_Transform"
buttontext:	"Rotate"
toolTip:	"Rotate selection active axis of angle snap value"
--icon:	"#(path, index)"
(
	(Transform_v()).rotateSelection( (SnapManager_v()).getSnapAngle() )
)

/*
*/
macroscript	rotate_toos_rotate_reverse
category:	"_Transform"
buttontext:	"Rotate"
--toolTip:	"Rotate about active axis"
--icon:	"#(path, index)"
(
	(Transform_v()).rotateSelection( (SnapManager_v()).getSnapAngle() * -1 )
)


/**
 *
 */
macroscript	_transform_type_in
category:	"_Transform"
buttontext:	"Type in"
toolTip:	"Mini Transform Type In\n\nDOUBLECLICK: Change window Postion"
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
toolTip:	"Close dialog"
--icon:	"#(path, index)"
(
	hwndMove = windows.getChildHWND 0 "Move Transform Type-In"
	UIAccessor.CloseDialog hwndMove[1]
)