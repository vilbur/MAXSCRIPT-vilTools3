
global CBX_FIX_POSITION_TRISTATE = 0

/**
  *
  */
macroscript	_export_fixed_position
category:	"_Export"
buttontext:	"Fix Position"
toolTip:	"For objects to keep position on export\n\n(Create boxes in corners of print plane to keep exported position)"
icon:	"control:checkbox|across:2|offset:[ 16, 8 ]"
(
	--format "EventFired	= % \n" EventFired
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
icon:	"control:checkbox|across:2|offset:[ 16, 8 ]"
(
	format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)


/**
  *
  */
macroscript	_export_open_in_final_file
category:	"_Export"
buttontext:	"Project File Open"
--toolTip:	"For objects to keep position on export\n\n(Create boxes in corners of print plane to keep exported position)"
icon:	"control:checkbox|across:2|offset:[ 16, 0 ]"
(
	--format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)


/**
  *
  */
macroscript	_export_open_in_close_instances
category:	"_Export"
buttontext:	"Single Instance"
toolTip:	"Close other instances of open in program"
icon:	"control:checkbox|across:2|offset:[ 16, 0 ]"
(
	format "EventFired	= % \n" EventFired

	--(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)

/**
  *
  */
macroscript	_export_export_exclude
category:	"_Export"
buttontext:	"Exclude"
toolTip:	"Do not export objects matching name.\n\nE.G.: 'do-no-export-this|or-this-object-name'"
icon:	"control:editText|across:1|offset:[ 0, 4 ]|value:support-source"
(
	format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)
