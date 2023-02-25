clearListener()



function getFacesByMatID obj =
(
	--getfacematid = polyop.getFaceMatID
	
	ids=#{}
	faces=#()
	
	format "numFaces	= % \n"  ( polyop.getNumFaces obj)
	
	for f = 1 to polyop.getNumFaces obj do
	(
		id = polyop.getFaceMatID obj f

		if not ids[id] then faces[id]=#{f} else faces[id][f]=true; ids[id]=true
	)
	
	face_ids = for id in ids collect #(id, faces[id])
	format "face_ids	= % \n" face_ids
)


select $Plane001
obj	= selection[1]



for i = obj.modifiers.count to 1 by -1 where classOf obj.modifiers[i] == Edit_Poly do
(
	_modifier = obj.modifiers[i]
	
	format "\n"; format "_modifier	= % \n" _modifier.name
	
	modPanel.setCurrentObject obj.modifiers[i]
	
	
	getFacesByMatID obj
	
)
