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

macroscript	modifier_save_preset
category:	"_Modifiers"  
buttonText:	"Preset"
tooltip:	"Save  preset of current modifier"
(
	(Modifier_v()).savePreset()
)	

macroscript	modifier_load_preset
category:	"_Modifiers"  
buttonText:	"Preset"
tooltip:	"Load preset of current modifier\n–\nName of modifier is preset name"
(
	(Modifier_v()).loadPreset()
)	