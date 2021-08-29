macroscript	modifier_get_instances_in_objects
category:	"_Modifiers"  
buttonText:	"Select Instances"
tooltip:	"Select objects with instance of current modifier"
(
	Modifier 	= Modifier_v()
	
	Modifier.setCurrent()
	
	instaneces_in_objects	= Modifier.getObjectsWithInstance objects
	
	select instaneces_in_objects
)

