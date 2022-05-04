/** ExportNodeCallback
 */
struct ExportNodeCallback_v
(

	/*------------------------------------------------------------------------------
		PRIVATE
	------------------------------------------------------------------------------*/
	
	/** Remove callback
	 */
	function removeCallback =
	(
		try( callbacks.removeScripts #selectionSetChanged id:#onUnityExportNodeSelected )catch()
	),
	/** Add callback
	 */
	function addCallback =
	(
		this.removeCallback()
		
		try( callbacks.addScript #selectionSetChanged "onUnityExportNodeSelected()" id:#onUnityExportNodeSelected )catch()
	),
	
	--/*---------------------------------------
	--	NODE USER PROPERTIES
	-------------------------------------------*/
	--/** Set export dir
	-- */
	--function setExportDir dir =
	--(
	--	this._setUserProp "export-dir"	dir
	--),
	
		
	on create do ()


)
