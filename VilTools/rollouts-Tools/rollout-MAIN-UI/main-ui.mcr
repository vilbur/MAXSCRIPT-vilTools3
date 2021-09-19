/**  Show\Hide time slider
 *	
 */
macroscript	main_ui_hide_animation_tools
category:	"_Main"
buttontext:	"Timeslider"
toolTip:	"Show\Hide time slider"
icon:	"type:checkbox"
(
   state = EventFired.value == false
	 
	trackbar.visible =    state
	timeSlider.setVisible state
)
