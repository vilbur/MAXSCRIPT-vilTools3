macroscript	selection_test
category:	"_Selection"
buttontext:	"Create Objects"
toolTip:	"Test"
--icon:	"#(path, index)"
(
	--Selection 	= Selection_v()
	--Selection.test()
	
	--pos_x = 0
	
	--for i = 1 to 5 do
		--b = box pos:[pos_x+=50, 0, 0]
	
	del = for obj_old in objects collect obj_old
	
	delete del
	
	obj_types	= #( "box", "sphere")
	pos_y = 0
	
	for o in obj_types do 
	(
		
		obj = execute (o+" pos:[0, "+(pos_y+=100) as string +", 0] wirecolor:" + (color 8 (random 32 128) (random 32 128)) as string )
		select obj
		
		maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
		select nnl
		$.wirecolor = (color (random 128 200) (random 128 200) (random 128 200))
		
		
		move $ [50, 0,0]
			
		for i = 1 to 5 do
		(
			maxOps.cloneNodes $ cloneType:#instance newNodes:&nnl
			move $ [50, 0,0]
		)
		
	)
	
)

