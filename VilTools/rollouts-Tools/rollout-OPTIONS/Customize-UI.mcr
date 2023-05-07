

/**  LINK TO NODE
 */
macroscript	_options_trackbar_show
category:	"_Otions"
buttontext:	"Trackbar Toggle"
--icon:	"control:label"
(
	state = not trackbar.visible

	trackbar.visible = state

	timeSlider.setVisible (state)


)
