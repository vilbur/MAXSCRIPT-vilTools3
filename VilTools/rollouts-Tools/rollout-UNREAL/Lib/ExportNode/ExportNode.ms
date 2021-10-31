/** export node
 */
struct ExportNode_v
(
	_node,
	_scene_name	= if( maxFileName != "" ) then ( ( dotNetObject "System.Text.RegularExpressions.Regex" @"[_-]\d+$" ).Replace (getFilenameFile maxFileName) "" ) else "UnrealExport",
	--_name	= "Export Node",
	_name	= _scene_name,
	
	user_prop = "unreal-engine-export-node",
	--path	= @"c:\Test Prototype Internal Assets\Assets\FBX - MODEL\_vilbur\ExportTest",
	--
	--/* PRIVATE */
	--_export_layer,
	--_export_layer_name = "Export-Unity",
	--

	/** Create
	 */
	function create =
	(
		global _ExportNodeThis = this

		this._askNameDialog()
	),
	
	/** _add to default layer
	 */
	function _addToDefaultLayer =
	(
		default_layer = LayerManager.getLayer 0
		
		default_layer.addnode _node
		
		default_layer.on = true
	),
	
	/** Get node object
	 */
	function _getNodeObject =
	(
		getNodeByName _name
	),
	
	/** Ask name dialog
	 */
	function _askNameDialog =
	(
		try(destroyDialog node_name_rollout) catch()
				
		rollout node_name_rollout "Set export node name"
		(
			dotNetControl TextBox "TextBox"
		
			on node_name_rollout open do
			(
				TextBox.Text = _scene_name
				TextBox.BackColor = ( dotNetClass "System.Drawing.Color").FromArgb 180 180 180
			)
			
			on TextBox KeyUp s e do
			(
				if e.KeyCode == e.KeyCode.Enter then
				(
					_ExportNodeThis._createNodeObject TextBox.Text 
					
					--destroyDialog node_name_rollout
				)
				else if e.KeyCode == e.KeyCode.Escape then
					destroyDialog node_name_rollout
			)
		)
		
		CreateDialog node_name_rollout width:256 height:40
			
		setFocus node_name_rollout.TextBox
	),

	/** Create
	 */
	function _createNodeObject _name =
	(
		this._name = _name

		if( this._getNodeObject() == undefined ) then
		(
			_node = text name:_name text:_name isSelected:off size:10

			this._setUserProp user_prop	true

			this._addToDefaultLayer()

			select _node

			try(destroyDialog node_name_rollout) catch()

			_ExportNodeThis = undefined
			
			(NodeList_v()).loadNodes()
		)
		else
			return this._exception()
	),
	
	/** Set user prop
	 */
	function _setUserProp key value =
	(
		setUserProp _node key	value
	),
	
	/** _exception
	 */
	function _exception =
	(
		node_name_rollout.Title = "! EXPORT NODE EXISTS ALREADY !"
		
		setFocus node_name_rollout.TextBox
	),
	
	on create do ()
	
	--/** Assign
	-- */
	--function assign =
	--(
	-- 
	--),
	--
	--/** Set node
	--  * @return	self
	-- */
	--function setNode __node =
	--(
	--	print "setNode()"
	--
	--	if( __node == undefined ) then
	--	(
	--		if not( this.isExportNodeSelected()  ) then
	--			this.createNodeObject()
	--	)
	--	else
	--		_node == __node
	--	
	--   this.fillObject()
	--
	--   this --return
	--),
	--/** Create node object
	-- */
	--function createNodeObject =
	--(
	--	_node = text name:name text:name isSelected:on size:1000
	--	--print ( "path = " + path as string ) 
	--	this._setUserProp "unity-export-node"	true
	--	this.setExportDir path
	--
	--	(SelectionSets_v()).create name _node
	--	
	--	--_node --return
	--),
	--/** Set selected node
	-- */
	--function fillObject =
	--(
	--	--print ( "fillObject = " + fillObject as string )
	--	--print ( "selection = " + selection[1] as string )
	--	--_node = selection[1]
	--	if( _node == undefined ) then
	--		return ()
	--	
	--	
	--	name	= _node.name
	--	path	= getUserProp _node "export-dir"
	--	
	--	_node.text = name
	--),
	----/** Set prop
	---- */
	----function setProp key value =
	----(
	----	setUserProp _node key value
	----),
	--/** Is export node selectedtt
	-- */
	--function isExportNodeSelected =
	--(
	--	classOf selection[1] == text and getUserProp selection[1] "unity-export-node" != undefined 
	--),
	--/** Get selected export nodes
	-- */
	--function getSelectedExportNodes =
	--(
	--	for _shape in selection where classOf _shape == text and getUserProp _shape "unity-export-node" != undefined collect _shape		
	--),
	--/*------------------------------------------------------------------------------
	--	PRIVATE
	----------------------------------------------------------------------------------*/
	--
	----/** Remove callback
	---- */
	----function removeCallback =
	----(
	----	try( callbacks.removeScripts #selectionSetChanged id:#onUnityExportNodeSelected )catch()
	----),
	----/** Add callback
	---- */
	----function addCallback =
	----(
	----	this.removeCallback()
	----	
	----	try( callbacks.addScript #selectionSetChanged "onUnityExportNodeSelected()" id:#onUnityExportNodeSelected )catch()
	----),
	----
	--/*---------------------------------------
	--	NODE USER PROPERTIES
	-------------------------------------------*/
	--/** Set export dir
	-- */
	--function setExportDir dir =
	--(
	--	this._setUserProp "export-dir"	dir
	--),
	
		
	

)
