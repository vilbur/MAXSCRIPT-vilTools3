
plugin shape Export_Node

name:	"Export Node"
extends:	text
classID:	#(0x133067, 0x54375)
version:	1.1
category:	"Splines"
replaceUI:	true
(
	/*------------------------------------------------------------------------------
		METHODS
	--------------------------------------------------------------------------------*/

	/** Get animation keys of node
	  *
	  * @param name controller_type #position|#rotation|#scale
	  *
	  * @return array of used frames
	 */
	function getAnimationKeys controller_type =
	(
		--format "\n"; print ".getAnimationKeys()
		Export_node = this._getNodeObejct()


		controller	= case controller_type of
		(
			#position:	Export_node.position.controller
			#rotation:	Export_node.rotation.controller
			#scale:	Export_node.scale.controller
			default:	return false
		)

		anim_keys = #()

		if (num_keys = numKeys controller ) > 0 then
			anim_keys = for i = 1 to num_keys collect ((getKeyTime controller i) as string ) as integer

		anim_keys --return
	)

	/** Get all nested node children
	 */
	function getAllChildren =
	(
		--format "\n"; print "NodeList_v.selectChildNodes()"
		all_children	= #()

		all_children += this._getAllChildren(this._getNodeObejct())

		all_children --return
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

				if ( _node =  this._getNodeObejct()) != undefined then
					_node.name = val
			)
	)

	parameters export_dir_params rollout:export_dir_rollout
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

	rollout export_name_rollout "Display Text" rolledUp:false
	(
		edittext node_name ""
	)

	rollout export_dir_rollout "Export Directory" rolledUp:false
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

	on load  do
	(
		Delegate.render_useViewportSettings = false
		Delegate.render_displayRenderMesh  = false
	)


	/*------------------------------------------------------------------------------

		PRIVATE

	--------------------------------------------------------------------------------*/

	/** Get node obejct
	 */
	function _getNodeObejct =
	(
		--format "\n"; print "._getNodeObejct()"
		nodes = for o in refs.dependents this where isvalidnode o collect o

		nodes[1] --return
	)

	/**  Get all nested children
	  */
	function _getAllChildren obj &arr:#() =
	(
		for child in obj.children do
		(
			append arr child

			this._getAllChildren child arr:arr
		)
		arr --return
	)

)