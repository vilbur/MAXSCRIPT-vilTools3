clearListener(); print("Cleared in:\n"+getSourceFileName())


		view_tm = Inverse ( viewport.getTM() )
		
		view_type = viewport.getType()
		
		
		record_viewport = viewport.activeViewport


		--record_camera = Freecamera transform:view_tm name:(uniquename "GifRecorderCamera") isHidden:true
		viewport.setType #view_persp_user

		macros.run "Lights and Cameras" "StandardCamera_CreateFromView"
	
		record_camera = cameras[cameras.count]
		
		
		viewport.setCamera record_camera
		delete record_camera
		viewport.setType view_type