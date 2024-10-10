clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../Color.ms" )


delete objects

/** Test single color
 */
function testSingleColor color_name =
(
	--format "\n"; print ".testSingleColor()"

	for i = 1 to 10 do
	(

		_Color 	= Color_v()

		obj = Sphere radius:4 pos:[ i*10, 0, 0]

		obj.wirecolor = _Color.randomize clr:color_name	hue:5 brightness:[128,255]  saturation:[128,255]

		format "wirecolor: %\n" obj.wirecolor
	)



)

/** Test colors
 */
function massTestHues hue: brightness: saturation: count:10 =
(
	format "\n"; print ".massTestHues()"

	_Color 	= Color_v()

	new_objects	= #()

	for y = 1 to count do
		for i = 1 to _Color.hues.keys.count do
		(
			color_name = _Color.hues.keys[i]

			obj = Sphere radius:4 pos:[ i * 20, y * -10, 0] name:(color_name as string )

			obj.wirecolor = _Color.randomize clr:color_name	hue:hue brightness:brightness saturation:saturation

			format "color_name: % \nwirecolor: %\n\n" color_name obj.wirecolor
		)
)


/*------------------------------------------------------------------------------

	RUN  TEST

-------------------------------------------------------------------------------*/
--testSingleColor #GREEN
--testSingleColor #BLUE
--testSingleColor #LIGHTBLUE
--testSingleColor #VIOLETE
--testSingleColor #MAGENTA

/*------------------------------------------------------------------------------

	RUN  MASS TEST

-------------------------------------------------------------------------------*/

/*------ HUE ------*/
--massTestHues()
--massTestHues hue:10


/*------ BRIGHTNESS ------*/
--massTestHues brightness:255
--massTestHues brightness:[0, 128]


/*------ SATURATION ------*/
--massTestHues saturation:128
--massTestHues saturation:#(64, 255)


/*------ BRIGHTNESS & SATURATION------*/
--massTestHues brightness:128	saturation:128
--massTestHues brightness:#(64, 255)	saturation:#(64, 255)

/*------ HUE, BRIGHTNESS & SATURATION------*/
--massTestHues hue:10 brightness:128	saturation:164
--massTestHues hue:5 brightness:[64, 232]	saturation:[64, 232]

/*------ RANDOM COLORS ------*/
--massTestHues hue:128 brightness:[64, 255]	saturation:[64, 255] -- RANDOM COLORS


/*------------------------------------------------------------------------------
	PRINT AVALIABLE COLOR NAMES
--------------------------------------------------------------------------------*/
for color_name in (_Color = Color_v()).hues.keys do
--format "_Color: %\n" _Color
	format "%: 	%\n" ( toUpper (color_name as string ) ) (_Color.getColor color_name)
	--format "color_name: %\n" color_name
