clearListener(); print("Cleared in:\n"+getSourceFileName())



	--if selection[1].layer.nodes &theNodes do
	--	for obj in theNodes do
	--
	--		obj.displayByLayer = true


	for i = objects.count to 1 by -1 where matchPattern objects[i].name pattern:("flames-support-*") do
	(

		format "objects[i].name: %\n" objects[i].name
		delete objects[i]

	)