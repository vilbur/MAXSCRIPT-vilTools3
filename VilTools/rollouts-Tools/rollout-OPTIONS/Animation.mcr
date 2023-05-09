
/**  LINK TO NODE
 */
macroscript	_options_animation
category:	"_Otions"
buttontext:	"Animation keys"
icon:	"control:spinner|type:#integer|range:[0,1000,100]|across:4"
(
	animationRange = Interval 0 (EventFired.val as integer )
)

