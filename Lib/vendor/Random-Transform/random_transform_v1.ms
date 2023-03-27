

try( DestroyDialog(randomTransformRollout) )catch()

rollout randomTransformRollout "" width:583 height:218
(
	label lbl1 "RANDOM TRANSFORM" pos:[233,10] width:114 height:18
	label lbl3 "X" pos:[152,37] width:12 height:20
	label lbl4 "Y" pos:[324,37] width:12 height:20
	label lbl5 "Z" pos:[493,37] width:12 height:20
	label lbl2 "POSITION" pos:[19,63] width:57 height:14
	spinner pos_x_min "min" pos:[92,62] width:59 height:16 range:[-10000,10000,0] type:#float
	spinner pos_x_max "max" pos:[169,62] width:59 height:16 range:[-10000,10000,0] type:#float
	spinner pos_y_min "min" pos:[258,62] width:59 height:16 range:[-10000,10000,0] type:#float
	spinner pos_y_max "max" pos:[334,63] width:59 height:16 range:[-10000,10000,0] type:#float
	spinner pos_z_min "min" pos:[430,62] width:59 height:16 range:[-10000,10000,0] type:#float
	spinner pos_z_max "max" pos:[509,61] width:59 height:16 range:[-10000,10000,0] type:#float
	label lbl6 "ROTATION" pos:[19,104] width:57 height:14
	spinner spn7 "min" pos:[92,103] width:59 height:16 range:[-10000,10000,0] type:#float
	spinner spn8 "max" pos:[169,104] width:59 height:16 range:[-10000,10000,0] type:#float
	spinner spn9 "min" pos:[258,103] width:59 height:16 range:[-10000,10000,0] type:#float
	spinner spn10 "max" pos:[334,103] width:59 height:16 range:[-10000,10000,0] type:#float
	spinner spn11 "min" pos:[430,103] width:59 height:16 range:[-10000,10000,0] type:#float
	spinner spn12 "max" pos:[509,103] width:59 height:16 range:[-10000,10000,0] type:#float
	label lbl7 "SCALE" pos:[19,148] width:57 height:14
	spinner spn13 "min" pos:[92,147] width:59 height:16 range:[-10000,10000,1] type:#float
	spinner spn14 "max" pos:[169,147] width:59 height:16 range:[-10000,10000,1] type:#float
	spinner spn15 "min" pos:[258,147] width:59 height:16 range:[-10000,10000,1] type:#float
	spinner spn16 "max" pos:[334,147] width:59 height:16 range:[-10000,10000,1] type:#float
	spinner spn17 "min" pos:[430,147] width:59 height:16 range:[-10000,10000,1] type:#float
	spinner spn18 "max" pos:[509,147] width:59 height:16 range:[-10000,10000,1] type:#float
	label lbl8 "RSJ 2013" pos:[518,11] width:56 height:16
	checkbox additivePosCB "Additive Pos" pos:[19,187] checked:True
	checkbox additiveRSCB "Additive Rot/Scale" pos:[110,187] checked:True
	button btn5 "Apply" pos:[414,187] width:72 height:22
	button btn6 "Store Curr" pos:[240,187] width:72 height:22
	button btn7 "Apply Curr" pos:[315,187] width:72 height:22
	button btn8 "Close" pos:[489,187] width:72 height:22

	on btn5 pressed do
	(
		rot = eulerangles 0 0 0

		undo "Randomize transformation" on
		(

			local_coord_system = getRefCoordSys() == #local

			for i in selection do
			(
				if  additivePosCB.checked == True then
				(
					move i [random pos_x_min.value pos_x_max.value,random pos_y_min.value pos_y_max.value,random pos_z_min.value pos_z_max.value]

				)
				else
				(
					i.pos = [random pos_x_min.value pos_x_max.value,random pos_y_min.value pos_y_max.value,random pos_z_min.value pos_z_max.value]
				)

				if additiveRSCB.checked == True then
				(
					rotX = random spn7.value	spn8.value
					rotY = random spn9.value	spn10.value
					rotZ = random spn11.value	spn12.value

					rot = EulerAngles rotX rotY rotZ


					if local_coord_system then
						in coordsys local Rotate i rot

					else
						Rotate i rot

					scale i [ random spn13.value spn14.value, random spn15.value spn16.value, random spn17.value spn18.value]
				)
				else
				(
					i.rotation.x_rotation = random spn7.value spn8.value
					i.rotation.y_rotation = random spn9.value spn10.value
					i.rotation.z_rotation = random spn11.value spn12.value

					i.scale = [random spn13.value spn14.value,random spn15.value spn16.value,random spn17.value spn18.value]

				)
			)

		)

	)

	on btn6 pressed do
	(
		--max spacebar
		a = #()
		num = 1
		for i in selection do
			(
			a[num] = #(i.pos[1],i.pos[2],i.pos[3],i.rotation.x_rotation,i.rotation.y_rotation,i.rotation.z_rotation,i.scale[1],i.scale[2],i.scale[3])
			num=num+1
			)
	)

	on btn7 pressed do
	(
		--max spacebar
		num=1
		for j in selection do
		(
			j.pos = [a[num][1],a[num][2],a[num][3]]
			j.rotation.x_rotation=a[num][4]
			j.rotation.y_rotation=a[num][5]
			j.rotation.z_rotation=a[num][6]
			j.scale = [a[num][7],a[num][8],a[num][9]]
			num=num+1
		)
	)

	on btn8 pressed do
	(
		--closeRolloutFloater randomTransformRolloutFloater
		--removeRollout randomTransformRollout
		DestroyDialog(randomTransformRollout)
	)
)



CreateDialog randomTransformRollout


