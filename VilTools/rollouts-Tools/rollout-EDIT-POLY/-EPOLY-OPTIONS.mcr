/** Ignore Backfacing
 */
macroscript epoly_tools_Ignore_Backfacing
category:	"_Epoly-Options"
buttonText:	"Ignore Backfacing"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()
	on isChecked	do (modPanel.getcurrentObject()).ignoreBackfacing == true

	on execute do
	(
		 (modPanel.getcurrentObject()).ignoreBackfacing = not (modPanel.getcurrentObject()).ignoreBackfacing
	)
)

/** Ignore Occluded
 */
macroscript epoly_tools_Ignore_Occluded
category:	"_Epoly-Options"
buttonText:	"Ignore Occluded"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	( not matchPattern ((viewport.getType index:viewport.activeViewport) as string) pattern:@"*persp*" ) -- if not perspective view
	on isChecked	do (modPanel.getcurrentObject()).ignoreOccluded == true

	on execute do
	(
		 (modPanel.getcurrentObject()).ignoreOccluded = not (modPanel.getcurrentObject()).ignoreOccluded; if viewport.isWire() then actionMan.executeAction 0 "415" -- turn on Occluded and wireframe off
	)
)

/** Select By Angle
 */
macroscript epoly_tools_Select_By_Angle
category:	"_Epoly-Options"
buttonText:	"Select By Angle"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()
	on isChecked	do (modPanel.getCurrentObject()).SelectByAngle == true

	on execute do
	(
		 (modPanel.getCurrentObject()).SelectByAngle = not (modPanel.getCurrentObject()).SelectByAngle
	)
)

