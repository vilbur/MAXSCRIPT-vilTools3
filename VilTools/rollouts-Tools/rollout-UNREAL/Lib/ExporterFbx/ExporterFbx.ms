/** Fbx Exporter to Unreal engine
  
  
  HOW TO EXECUTE
  
	Exporter = ExporterFbx_v export_dir:export_dir
	
	Exporter.loadPreset()
	
	Exporter.epxort (_node)


 */
struct ExporterFbx_v
(
	export_node,	-- used node for export
	
	export_dir,
	
	preset_file = getFilenamePath(getSourceFileName()) + "\Presets\Unreal-default.fbxexportpreset",

	_export_layer,
	
	_export_layer_name ="UNREAL-ENGINE-EXPORT",
	
	

	/** Setup fbx exporter
	 */
	function loadPreset =
	(
		print "ExporterFbx_v.loadPreset()"
		FBXExporterSetParam "LoadExportPresetFile" preset_file
	),
	
	/** Export
	 */
	function epxort _node =
	(
		print "ExporterFbx_v.epxort()"
		
		if ( doesFileExist export_dir ) then 
			--for _node in nodes do 
				this._exportNode (_node)
		else
			messageBox "Directory does not exist." title:"EXPORT FAILED !" beep:true
	),

	/** Select node children
	 */
	function _exportNode _node =
	(
		print "ExporterFbx_v.selectObjectsForExport()"
		if( _node.children.count == 0 ) then
			return false
		
		select _node.children
		
		--modPanel.addModToSelection (XForm ()) ui:on

		--ConvertTo selection Editable_Poly
		
		exportFile (export_dir+"\\"+_node.name+".fbx") #noPrompt selectedOnly:true using:FBXEXP
	),
	
	private
	 
	
	/** _copy objects to export layer
	 */
	function _copyObjectsToExportLayer _objects =
	(
		--format "\n"; print "ExporterFbx_v._copyObjectsToExportLayer()"
		export_objects	= #()
		
		maxOps.cloneNodes  ( _objects as Array ) cloneType:#copy newNodes:&export_objects #nodialog
		
		for obj in export_objects do
			_export_layer.addNode obj
			
		export_objects --return
	),
	
	/** Get objects in export layer
	  * @return	collection of geometry rects in layer "Export"	
	 */
	function getObjectsInExportLayer =
	(
		for obj in objects where superClassOf obj == GeometryClass and obj.layer.name == _export_layer_name collect obj
	),
	
	/** _get export layer
	 */
	function _setExportLayer =
	(
		format "\n"; print "ExporterFbx_v._setExportLayer()"
		if( (_export_layer = LayerManager.getLayerFromName _export_layer_name) == undefined ) then
			_export_layer	= LayerManager.newLayerFromName _export_layer_name
	),
	
	/** _reset xform
	 */
	function _resetXform &export_objects=
	(
		--format "\n"; print "ExporterFbx_v._resetXform()"
		for export_object in export_objects do
			ResetXForm export_object
			
		export_objects --return
	),
	
	/** Convert to editable poly
	 */
	function _convertToEditablePoly export_object =
	(
		ConvertTo export_object Editable_Poly
	),
	
	
	/** _check export directory
	 */
	function _createExportDirectory =
	(
		print "ExporterFbx_v._createExportDirectory()"
		
		if not( doesFileExist export_dir ) then 
			if queryBox (export_dir+"\n\n Would you like to create directory ?") title:"PATH DOES NOT EXIST !"  beep:true then
				makeDir export_dir
	),
	
	on create do
	(
		this._createExportDirectory()	
	)
)