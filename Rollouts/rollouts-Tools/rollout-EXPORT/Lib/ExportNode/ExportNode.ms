global NODE_NAME_ROLLOUT



/** export node
 */
struct ExportNode_v
(
	_node,
	_scene_name	= if( maxFileName != "" ) then ( ( dotNetObject "System.Text.RegularExpressions.Regex" @"[_-]\d+$" ).Replace ( getFilenameFile maxFileName ) "" ) else "UnrealExport",
	_name	= _scene_name,

	user_prop = "unreal-engine-export-node",


	/** Create
	 */
	function create =
	(
		--print "ExportNode_v.create()"
		global ThisExportNode = this

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

	--/** Get node object
	-- */
	--function _getNodeObject =
	--(
	--	--getNodeByName _name
	--),

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
			export_dir = this._getExportDir()

			_node = Export_Node name:_name text:_name export_dir:export_dir isSelected:on

			this._addToDefaultLayer()

			try(destroyDialog NODE_NAME_ROLLOUT) catch()

			ThisExportNode = undefined

			true --return
		)
		else
			this._exception() --return
	),


	/** _exception
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


	on create do
	(
		--print "ExportNode_v.onCreate()"

	)
)