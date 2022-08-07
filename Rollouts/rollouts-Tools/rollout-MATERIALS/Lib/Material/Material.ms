/** Material
  *
  * 
  *
 */
struct Material_v
(
	
	_bitmaps = #(),

	
	/** Get mat from selection
	 */
	function getMaterialsOfObjects _objects =
	(
		--format "\n"; print "Material_v.getMatFromSelection()"
		for o in _objects where superClassOf o == GeometryClass collect o.material
	),
	
	/** Get diffuse bitmaps from materials
	  *
	  * @param	array	materials
	 */
	function getBitmaps materials =
	(
		--format "\n"; print "Material_v.getDiffuseTextures()"
		--textures = #()

		for mat in materials do
		(
			case classOf mat of
			(
				--Standardmaterial:	format "mat.diffuseMap	= % \n" mat.diffuseMap 
				Standardmaterial:	appendIfUnique _bitmaps mat.diffuseMap 
				--Multimaterial:	this.getDiffuseTextures(mat.materialList)
				Multimaterial:	this.getBitmaps(mat.materialList)
				--PhysicalMaterial:	format "mat.base_color_map	= % \n" mat.base_color_map
				PhysicalMaterial:	appendIfUnique _bitmaps mat.base_color_map
			)
		)	

		_bitmaps --return
	),
	
	/** Show textures in view port
	 */
	function showTexturesInViewPort materials state =
	(
		--format "\n"; print "Material_v.showTexturesInViewPort()"
		for mat in materials do
			case classOf mat of
			(
				Standardmaterial:	try ( showTextureMap mat mat.diffuseMap state ) catch()
				Multimaterial:	this.showTexturesInViewPort(mat.materialList)(state)
				PhysicalMaterial:	try ( showTextureMap mat mat.base_color_map state ) catch()
			)
	),

	/** Get material from scene by name
	  *
	  * @param	string	mat_name
	  * @return	Material|false	
	 */
	function getMatFromScene mat_name =
	(
		_materials = for mat in SceneMaterials where mat.name == mat_name collect mat
		--print ( "_materials = " + _materials.count as string )
		if( _materials.count > 0 ) then 
			_materials[1] --return
		else
			false
	),
	
	/** Create multimaterial where each material ID has different color
	  * @return multimaterial
	 */
	function getIdMaterial =
	(
		print "Material.getIdMaterial()"
		mat_name = "Multi ID"
		colors	 = 6
		
		mat_existing = this.getMat mat_name 
		format "mat_existing	= % \n" mat_existing
		if( mat_existing != false ) then
			return mat_existing
		
		RGB_darker	= this.getColorsPallete colors minmax:#(130,	170)
		RGB_dark	= this.getColorsPallete colors minmax:#(90,	130)
		RGB	= this.getColorsPallete colors minmax:#(50,	90)
		
		join RGB (join RGB_dark RGB_darker)
		
		multi_mat	= Multimaterial numsubs:RGB.count name:mat_name -- (getFilenamePath  loadedMat)
		
		for c=1 to RGB.count do
			multi_mat[c].base_color = color RGB[c][1] RGB[c][2] RGB[c][3]
		
		multi_mat --return
	),
	





	on create do
	(
		--print "Material.onCreate()"
	)
)

