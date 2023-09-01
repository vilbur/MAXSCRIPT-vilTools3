
/**  Set material of 1st selected object to all objects in selection
 */
macroscript	material_by_object
category:	"_Material"
buttonText:	"Mat by object"
tooltip:	"Assign material to selection by last selected object"
icon:	"MENU:true"
(
	--filein(@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-MATERIALS\Materials.mcr")
	on execute do
	(
		_selection = for o in selection where superClassOf o == GeometryClass collect o

		if _selection.count >= 2 then
		(
			source_object = _selection[_selection.count]

			if source_object.material != undefined then
			(
				target_objects = deleteItem _selection _selection.count

				for obj in target_objects do
					obj.material =  source_object.material

			)
			else
				messageBox "Last selected objects has not material" title:"SET MATERIAL"
		)
		else
			messageBox "Select 2 objects at least. \n\nMaterial will be set to objects by last obejct in selection" title:"SET MATERIAL"
	)
)



/**
 */
macroscript	material_select_objs_by_material
category:	"_Material"
buttonText:	"Select By Mat"
tooltip:	"Select objects by current material in material editor"
icon:	"MENU:true"
(
	-- <array>SelectObjectByMaterial - returns array of objects a material is assigned to
	function SelectObjectByMaterial reqMatEditOpen materialIndex = (
		objarr = #()

		-- Select ALL objects with this material
		if MatEditor.isOpen() or (reqMatEditOpen == false) then (
			if materialIndex > 0 and materialIndex < 25 then (-- start index check
				objarr = for o in objects where o.material == meditMaterials[materialIndex] collect o
				-- Check if the obj is part of a group
				for obj in objarr where isGroupMember obj AND (NOT isOpenGroupMember obj) do
				(
				  	par = obj.parent
				  	while par != undefined do
				  	(
				  		if isGroupHead par then
				  		(
				  			setGroupOpen par true
				  			par = undefined
				  		)
				  		else par = par.parent
					)
				)
			) -- end index check
		) else	-- Material Editor isn't open
			messageBox "Material Editor is not open" beep:false

		objarr
	)

	on execute do
	(
		clearSelection()

		max create mode

		if (objs = SelectObjectByMaterial true (medit.getActiveMtlSlot())) != undefined then
			select objs
	)

	--on altexecute type do (
	--	clearSelection()
	--	max create mode
	--	if (objs = SelectObjectByMaterial true (medit.getActiveMtlSlot())) != undefined then
	--		select objs
	--
	--	for o in objs where not(o.layer.on) do o.layer.on = true
	--	for o in objs where o.layer.isFrozen do o.layer.isFrozen = false
	--	for o in objs where o.isHidden do o.isHidden = false
	--	for o in objs where o.isFrozen do o.isFrozen = false
	--
	--	select objs
	--)
)

/**
 */
macroscript	material_select_faces_by_material_id
category:	"_Material"
buttontext:	"Sel Faces by Mat"
toolTip:	"Select faces by material id - PALCEHOLDER"
--icon:	"#(path, index)"
(
	--Epoly 	=  Epoly_v()
	--EditPolyMaterial 	=  EditPolyMaterial_v()
	--
	--faces_ids_merged	= #{}
	--face_count	= Epoly.count 4
	--mat_ids	= EditPolyMaterial.getMatId facelist:( Epoly.getSel #Face )
	--
	--faces_ids	= EditPolyMaterial.getFacesByMatId ( makeUniqueArray  mat_ids )
	--for faces_id in faces_ids do
	--	join faces_ids_merged faces_id
	--
	--Epoly.setSel #Face faces_ids_merged
)
