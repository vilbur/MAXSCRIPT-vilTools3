global NODE_NAME_ROLLOUT


/** export node
 */
struct ExportNode_v
(
	_node,
	_scene_name	= if( maxFileName != "" ) then ( ( dotNetObject "System.Text.RegularExpressions.Regex" @"[_-]\d+$" ).Replace ( getFilenameFile maxFileName ) "" ) else "UnrealExport",
	_name	= _scene_name,
	_selection,

	/** Create
	 */
	function create =
	(
		--print "ExportNode_v.create()"
		global ThisExportNode = this

		this._selection = for obj in selection where obj.parent == undefined and classOf obj != Export_Node collect obj
		format "this._selection	= % \n" this._selection
		this._createNodeDialog()
	),

	/** _add to default layer
	 */
	function _addToDefaultLayer =
	(
		default_layer = LayerManager.getLayer 0

		default_layer.addnode _node

		default_layer.on = true
	),


	/** Ask name dialog
	 */
	function _createNodeDialog =
	(
		try(destroyDialog NODE_NAME_ROLLOUT) catch()

		rollout NODE_NAME_ROLLOUT "Set export node name"
		(
			dotNetControl TextBox "TextBox"

			on NODE_NAME_ROLLOUT open do
			(
				TextBox.Text	= _scene_name
				TextBox.BackColor	= ( dotNetClass "System.Drawing.Color").FromArgb 180 180 180
			)

			on TextBox KeyUp s e do
			(
				if e.KeyCode == e.KeyCode.Enter then
				(
					if( ThisExportNode._createNodeObject(TextBox.Text) ) then
						destroyDialog NODE_NAME_ROLLOUT
				)
				else if e.KeyCode == e.KeyCode.Escape then
					destroyDialog NODE_NAME_ROLLOUT
			)
		)

		CreateDialog NODE_NAME_ROLLOUT width:256 height:40

		setFocus NODE_NAME_ROLLOUT.TextBox
	),

	/** Create
	 */
	function _createNodeObject _name =
	(
		this._name = _name

		--format "node_exists	= % \n" node_exists
		if( this._getNodeByName(_name) == undefined ) then
		(

			this._node = Export_Node name:_name text:_name export_dir:(this._getExportDir()) size:(this._getNodeSize()) isSelected:on

			this._addToDefaultLayer()

			this._linkSelectedObejctsToNode()

			try(destroyDialog NODE_NAME_ROLLOUT) catch()

			ThisExportNode = undefined

			(NodeList_v(ROLLOUT_export.ML_nodes)).loadNodes()

			true --return
		)
		else
			this._exception() --return
	),

	/** Link selected obejcts to node
	  *
	  * Only objects without parent are linked, hierarchy will be kept
	 */
	function _linkSelectedObejctsToNode =
	(
		format "\n"; print "ExportNode_v._linkSelectedObejctsToNode()"

		for obj in this._selection do
			obj.parent = this._node
	),

	/** Throw Eexception
	 */
	function _exception =
	(
		NODE_NAME_ROLLOUT.Title = "! THIS NAME EXISTS ALREADY !"

		setFocus NODE_NAME_ROLLOUT.TextBox

		false --return
	),

	/** Get nodes in scene
	 */
	function _getNodesInScene =
	(
		--format "\n"; print "ExportNode_v._getNodesInScene()"
		for obj in shapes where classOf obj == Export_Node collect obj
	),

	/** Get nodes in scene
	 */
	function _getNodeByName node_name =
	(
		--format "\n"; print "ExportNode_v._getNodesInScene()"
		for obj in shapes where classOf obj == Export_Node and obj.name == node_name do return obj

		undefined --return
	),

	/** Get export dir path
	  *
	  * @return string
	  * 		1) from other nodes in scene
	  * 		2) Max file path with "\Export" subdir
	 */
	function _getExportDir =
	(
		--format "\n"; print "ExportNode_v._getExportDir()"

		local other_node_path

		for _node in this._getNodesInScene() where _node.export_dir != "" do
			other_node_path = _node.export_dir

		if other_node_path != undefined then other_node_path else maxFilePath + "Export" -- return
	),


	/** Get
	  *
	  * @return integer
	  * 		1) biggest node size from other nodes in scene
	  * 		2) default
	 */
	function _getNodeSize =
	(
		--format "\n"; print "ExportNode_v._getNodeSize()"
		other_node_size = 0

		for _node in this._getNodesInScene() where _node.size > other_node_size do
			other_node_size = _node.size

		if other_node_size != 0 then other_node_size else 100
	),

	on create do
	(
		--print "ExportNode_v.onCreate()"
	)
)