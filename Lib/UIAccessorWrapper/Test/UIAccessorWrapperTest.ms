clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../UIAccessorWrapper.ms" )	-- "./../UIAccessorWrapper.ms"


/** Prepare scene
  *
  */
function prepareScene =
(
	--format "\n"; print "errorTest.ms.prepareScene()"
	--delete objects
	--
	----_box	= Box()
	--_sphere	= Sphere pos:[100, 0, 0]
	--
	----addModifier _box  (Poly_Select ())
	----addModifier _box  (Materialmodifier ())
	--select _sphere
	--
	--macros.run "Modifier Stack" "Convert_to_Poly"


	delete objects

	/* CREATE PATH */
	loftPath = SplineShape name:"Path"

 	addNewSpline loftPath

 	for i = 0 to 30 by 10 do
 		addKnot loftPath 1 #smooth #curve [random -10 10, i,0]

 	--addKnot loftPath 1 #smooth #curve [ 0 , 0 ,0 ]
 	--addKnot loftPath 1 #smooth #curve [ 100 , 0 ,0 ]


	/* CREATE SHAPE */
	nodeShape = Circle  name:"ShapeBig" radius:10 pos:[ -100 , 0 ,0 ]

	select loftPath

	--max create mode

	macros.run "Objects Compounds" "Loft"

	--max modify mode
)



--prepareScene()



UIAccess = UIAccessorWrapper_v( #CommandPanel )

--UIAccess.press "Path Steps"
--UIAccess.setVal "Path Steps:" 0
controls_by_type = UIAccess.getControls ( #BUTTON )

--format "\n-----------\nARRAY:controls_by_type:\n";  for ctrl in controls_by_type do format "ctrl:	%\n" ctrl

--format "controls_by_type:	% \n" controls_by_type

controls_values = UIAccess.getVal ( controls_by_type )

--format "\n-----------\nARRAY:controls_values:\n";  for val in controls_values do format "val:	%\n" val

UIAccess.list()