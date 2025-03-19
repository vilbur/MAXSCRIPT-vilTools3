
/**  LINK TO NODE
 */
macroscript	_options_paths_photoshop_label
category:	"_Otions"
buttontext:	"Photoshop path"
icon:	"control:label"
(
)



/**
 */
macroscript	_options_paths_photoshop
category:	"_Otions"
buttontext:	"[Photoshop exe]"
toolTip:	"Browse path to Photoshop.exe"
icon:	"control:browsePath|mode:#getOpenFileName|across:1"
(
	--format "EventFired	= % \n" EventFired

	on execute do
		if EventFired.val != "" then
			if not matchPattern EventFired.val pattern:"*photoshop.exe*" then
			(
				messageBox ("This is not path to Photoshop.exe\n\n"+EventFired.val) title:"WRONG PATH TO PHOTOSHOP"  beep:true
	
				ROLLOUT_options.BP_photoshop_exe.text = ""
	
				ROLLOUT_options.BP_photoshop_exe.tooltip = "Browse path to Photoshop.exe"
			)
)
