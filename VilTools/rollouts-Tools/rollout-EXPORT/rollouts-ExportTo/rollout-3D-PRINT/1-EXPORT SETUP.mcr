
global CBX_FIX_POSITION_TRISTATE = 0

/**
  *
  */
macroscript	_export_fixed_position
category:	"_Export"
buttontext:	"Fix Position"
toolTip:	"For objects to keep position on export\n\n(Create boxes in corners of print plane to keep exported position)"
icon:	"control:checkbox|across:2|offset:[ 16, 0 ]"
(
	format "EventFired	= % \n" EventFired
	--format "EventFired.Control.triState	= % \n" EventFired.Control.triState
	----format "CBX_FIX_POSITION_TRISTATE	= % \n" CBX_FIX_POSITION_TRISTATE
	----(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
	--if EventFired.val == false and CBX_FIX_POSITION_TRISTATE != 2 then
	--	EventFired.Control.triState = CBX_FIX_POSITION_TRISTATE = 2
	--else
	--	CBX_FIX_POSITION_TRISTATE = 0

)

/**
  *
  */
macroscript	_export_turn_on_meshmooth
category:	"_Export"
buttontext:	"Meshsmooth"
toolTip:	"Auto turn on first Meshmooth modifier on exported object.\n\nMeshmooth is ONLY ENABLED, NOT ADDED."
icon:	"control:checkbox|across:2|offset:[ 16, 0 ]"
(
	format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)
