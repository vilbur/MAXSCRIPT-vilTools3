/** Multimaterial
  *
  * 
  *
 */
struct MultiMat_v
(
	
	/* construct */
	/* dependency */
	/* reference */
	--_Material = Material_v(),
	
	/* inhered */
	/* properties */
	
	/** Set texture file
	 */
	function setTextureFile mat file_path map_name =
	(
		--format "\n"; print "MultiMat_v.setTextureFile()"

		messageBox "METHOD: MultiMat_v.setTextureFile()\n\nIS NOT SUPPORTED YET" title:"MultiMat_v"
		
		
		--setProperty mat map_name (Bitmaptexture filename:file_path)
		
		
		
		--ids = this._getIdsOfSlectedFaces()
		
		--if ids.count == 0 then 	
		 -- use all ids on object
		
	),
	

	
	private
	
	/** Get ids of slected faces
	 */
	function _getIdsOfSlectedFaces =
	(
		--format "\n"; print "MultiMat_v._getIdsOfSlectedFaces()"
		
	),
	
	on create do
	(
		--print "PhysicalMat_v.MultiMat_v()"
	)
)