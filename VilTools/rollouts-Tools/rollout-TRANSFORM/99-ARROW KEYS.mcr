

/** 
  *	
  */
macroscript transform_arrow_key_left
category: 	"_Transform"
buttontext:	"◄"
tooltip:	"Transform selection LEFT"
icon:	"id:BTN_arrow_key_left|tooltip:A) MOVE by grid size\n\nB) ROTATE by value of angle snap"
(
	on execute do undo "Move LEFT" on
		transformByArrowKey #LEFT
)


/** 
  *	
  */
macroscript transform_arrow_key_right
category: 	"_Transform"
buttontext:	"►"
tooltip:	"Transform selection RIGHT"
icon:	"id:BTN_arrow_key_right|tooltip:A) MOVE by grid size\n\nB) ROTATE by value of angle snap"
(
	on execute do undo "Move RIGHT" on
		transformByArrowKey #RIGHT
)

/** 
  *	
  */
macroscript transform_arrow_key_up
category: 	"_Transform"
buttontext:	"▲"
tooltip:	"Transform selection UP"
icon:	"id:BTN_arrow_key_up|tooltip:A) MOVE by grid size\n\nB) ROTATE by value of angle snap"
(
	on execute do undo "Move UP" on
		transformByArrowKey #UP
)

/** 
  *	
  */
macroscript transform_arrow_key_down
category: 	"_Transform"
buttontext:	"▼"
tooltip:	"Transform selection DOWN"
icon:	"id:BTN_arrow_key_down|tooltip:A) MOVE by grid size\n\nB) ROTATE by value of angle snap"
(
	on execute do undo "Move DOWN" on
		transformByArrowKey #DOWN
)


































