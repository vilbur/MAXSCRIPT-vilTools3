plugin shape Export_Node

name:	"Export Node"
extends:	text
classID:	#(0x133067, 0x54375)
version:	1.1
category:	"Splines"
replaceUI:	true
(

	/** Get node obejct
	 */
	function getNodeObejct =
	(
		--format "\n"; print ".getNodeObejct()"
		nodes = for o in refs.dependents this where isvalidnode o collect o

		nodes[1] --return
	)

	/*------------------------------------------------------------------------------
		PARAMETERS
	--------------------------------------------------------------------------------*/
	parameters export_name rollout:export_name_rollout
	(
		text  type:#string default:"Export Node"	ui:node_name

		on text set val do
			if val != undefined and val != "" then
			(
				Delegate.text = val

				if ( _node =  this.getNodeObejct()) != undefined then
					_node.name = val
			)
	)

	parameters _node rollout:export_dir_rollout
	(
		export_dir  type:#string default:""	ui:edit_export_path
	)

	parameters main rollout:params
	(
		size  type:#integer default:100 	ui:node_size align:#left

		on size set val do
			Delegate.size = val
	)

	/*------------------------------------------------------------------------------
		ROLLOUTS
	--------------------------------------------------------------------------------*/
	rollout export_name_rollout "Export Name" rolledUp:false
	(
		edittext node_name ""
	)

	rollout export_dir_rollout "Export Path" rolledUp:false
	(
		edittext edit_export_path ""
	)

	rollout params "Parameters"
	(
		spinner node_size	"Size" range:[0,999,20] type:#integer offset:[0,16]
	)

	on create do
	(
  		--format "\n"; print ".onCreate()"
		Delegate.size = this.size
	)

	on attachedToNode _node  do
	(
		_node.name = "Export Node"
	)
)