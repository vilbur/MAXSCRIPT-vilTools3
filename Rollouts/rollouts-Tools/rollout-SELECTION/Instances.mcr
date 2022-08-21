macroscript	selection_select_instances
category:	"_Selection"
buttontext:	"Select instances"
toolTip:	"Select instances of object"
--icon:	"#(path, index)"
(
	only_visible   = false
	global instances = #()
	
	for obj in selection do
	(	
		local obj_instance
		InstanceMgr.GetInstances obj &obj_instance
		join instances obj_instance	
	)
	
	if only_visible == 1 then
		for o in instances where  o.visibility == false do deleteitem instances (finditem instances o )
	
	select instances	
)



macroscript	selection_filter_unique_objects
category:	"_Selection"
buttontext:	"Unique objects"
toolTip:	"Select only Unique objects.\nDeselect mutliple instances"
--icon:	"#(path, index)"
(
	(Selection_v()).filterUniqueObjects()
)

macroscript	selection_reinstancer
category:	"_Selection"
buttontext:	"Reinstance"
toolTip:	"Reinstance selection"
--icon:	"#(path, index)"
(
	
	if selection.count < 2 then
    (
      messagebox "Make selection for reinstance"
    )
    else
    (
		undo on
		(
			--main_obj = selection[1]

			--_selection = (for o in selection  collect o )as Array
			--format "_selection[1]	= % \n" _selection[1]
			--format "_selection	= % \n" _selection
			--deleteItem _selection 1 
			
			_selection=  getCurrentSelection()
			for_instance = _selection
			instancer = _selection[_selection.count]
			deleteItem for_instance for_instance.count
			
		
		
	
			-- 	select instancer
	-- 		i=1
	-- 		for o in _selection do
	-- 		(
	-- 			if i < (_selection.count) do append for_instance o		
	-- 			i=i+1
	-- 		)
	-- 		select for_instance
	-- 		for o in for_instance do maxOps.CollapseNode o off
	
	-- 		o = for_instance[1]
			for o in for_instance do 
			(
				o.baseObject = instancer.baseObject
				o.wirecolor = instancer.wirecolor
				o.parent	   = instancer.parent

			)
	
			print "Reinstanced"
		
		)
    )
	
	
)
