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

--macroscript	modifier_save_preset
--category:	"_Modifiers"  
--buttonText:	"Save Preset"
----tooltip:	"Select objects with instance of current modifier"
--(
--	Modifier 	= Modifier_v()
--	--
--	--Modifier.setCurrent()
--	--
--	--instaneces_in_objects	= Modifier.getObjectsWithInstance objects
--	--
--	--select instaneces_in_objects
--)
--

macroscript	modifier_save_preset
category:	"_Modifiers"  
buttonText:	"Preset save"
tooltip:	"left"
(
	--Modifier 	= Modifier_v()
	--
	--Modifier.setCurrent()
	--
	--Modifier.savePreset()
	print "shhit"

)	

macroscript	modifier_load_preset
category:	"_Modifiers"  
buttonText:	"Preset savex"
tooltip:	"left"
(
	--Modifier 	= Modifier_v()
	--
	--Modifier.setCurrent()
	--
	--Modifier.savePreset()
	print "shhit"

)	
