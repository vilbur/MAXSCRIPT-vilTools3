filein( getFilenamePath(getSourceFileName()) + "/StandartMat/StandartMat.ms" )	-- "./StandartMat/StandartMat.ms"
filein( getFilenamePath(getSourceFileName()) + "/PhysicalMat/PhysicalMat.ms" ) 	-- "./PhysicalMat/PhysicalMat.ms"
filein( getFilenamePath(getSourceFileName()) + "/MultiMat/MultiMat.ms" )	-- "./MultiMat/MultiMat.ms"

/** Material
  *
 */
struct Material_v
(

	/* construct */
	/* dependency */
	StandartMat	= StandartMat_v(),
	PhysicalMat	= PhysicalMat_v(),
	MultiMat	= MultiMat_v(),


	/* reference */
	/* inhered */
	/* properties */
	_bitmaps = #(),

	--/** Create material
	--  *
	--  * @param #standard|physical|Mutlimat
	--  */
	--function create type =
	--(
	--	--format "\n"; print "Material_v.createMaterial()"
	--	case type of
	--	(
	--		#standard:	this.StandartMat.create
	--		--default:
	--	)
	--
	--),

	/** Get mat from selection
	 */
	function getMaterialsOfObjects _objects =
	(
		format "\n"; print "Material_v.getMatFromSelection()"
		--format "_objects:	% \n" (_objects )
		makeUniqueArray (for o in _objects as Array where o.material != undefined collect o.material)
	),

	/** Get map slots
	 */
	function getMapSlots mat =
	(
		--format "\n"; print "Material_v.getMapSlots()"

		props = stringStream ""

		showProperties mat to:props

		prop_list = filterString ( props as string ) "\n"

		case classOf mat of
		(
			Standardmaterial:	StandartMat.getMapSlots	(prop_list)
			PhysicalMaterial:	PhysicalMat.getMapSlots	(prop_list)
			--Multimaterial:	this.getMapSlots	(mat)
		)
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
				Standardmaterial:	appendIfUnique _bitmaps mat.diffuseMap
				PhysicalMaterial:	appendIfUnique _bitmaps mat.base_color_map
				Multimaterial:	this.getBitmaps(mat.materialList)
			)
		)

		for _bitmap in _bitmaps where _bitmap != undefined collect _bitmap --return
	),

	/** Set texture file
	  *
	  * @param	material	mat
	  * @param	string	file_path	path to texture
	  * @param	string	map_name	name of slot E.G.: #diffuseMap|#specularMap|#bumpMap|...
	 */
	function setTextureFile mat file_path map_name =
	(
		format "\n"; print "Material_v.setTextureFile()"
		case classOf mat of
		(
			Standardmaterial:	StandartMat.setTextureFile	mat file_path map_name
			PhysicalMaterial:	PhysicalMat.setTextureFile	mat file_path map_name
			Multimaterial:	MultiMat.setTextureFile	mat file_path map_name
		)

	),

	/** Show textures in view port
	 */
	function showTexturesInViewPort materials map_name state =
	(
		--format "\n"; print "Material_v.showTexturesInViewPort()"
		for mat in materials do
			case classOf mat of
			(
				Standardmaterial:	StandartMat.showTextureInViewPort (mat) (map_name) (state)
				PhysicalMaterial:	PhysicalMat.showTextureInViewPort (mat) (map_name) (state)
				Multimaterial:	this.showTexturesInViewPort(mat.materialList)(map_name)(state)
			)
	),

	/** Get material from scene by name
	  *
	  * @param	string	mat_name
	  * @return	Material|false
	 */
	function getMat mat_name =
	(
		_materials = for mat in sceneMaterials where mat.name == mat_name collect mat
		--print ( "_materials = " + _materials.count as string )
		if( _materials.count > 0 ) then
			_materials[1] --return
	),

	--/** Create multimaterial where each material ID has different color
	--  * @return multimaterial
	-- */
	--function getIdMaterial =
	--(
	--	--print "Material.getIdMaterial()"
	--	mat_name = "Multi ID"
	--	colors	 = 6
	--
	--	mat_existing = this.getMat mat_name
	--	--format "mat_existing	= % \n" mat_existing
	--	if( mat_existing != false ) then
	--		return mat_existing
	--
	--	RGB_darker	= this.getColorsPallete colors minmax:#(130,	170)
	--	RGB_dark	= this.getColorsPallete colors minmax:#(90,	130)
	--	RGB	= this.getColorsPallete colors minmax:#(50,	90)
	--
	--	join RGB (join RGB_dark RGB_darker)
	--
	--	multi_mat	= Multimaterial numsubs:RGB.count name:mat_name -- (getFilenamePath  loadedMat)
	--
	--	for c=1 to RGB.count do
	--		multi_mat[c].base_color = color RGB[c][1] RGB[c][2] RGB[c][3]
	--
	--	multi_mat --return
	--),






	on create do
	(
		--print "Material.onCreate()"
	)
)
