/** Material id
 */
struct MaterialId_v
(
	/* construct */


	/* properties */


	/* dependency */
	/* reference */
	/* inhered */

	/** Create multimaterial where each material ID has different color
	  * @return multimaterial
	 */
	function createtMultiIdMaterial =
	(
		--print "Material.createtMultiIdMaterial()"
		mat_name = "Multi ID"

		colors	 = 6

		if( (mat_existing = this.getMat mat_name) != undefined ) then
			return mat_existing

		RGB_darker	= this.getColorsPallete colors minmax:#(130,	170)
		RGB_dark	= this.getColorsPallete colors minmax:#(90,	130)
		RGB	= this.getColorsPallete colors minmax:#(50,	90)

		join RGB (join RGB_dark RGB_darker)

		multi_mat	= Multimaterial numsubs:RGB.count name:mat_name -- (getFilenamePath  loadedMat)

		/* SET PROPS FOR EACH SUB MATERIAL */
		for c = 1 to RGB.count do
		(
			std_mat = standardMaterial()

			std_mat.diffuse = color RGB[c][1] RGB[c][2] RGB[c][3]
			std_mat.name = ("mat_id_" + c as string )
	
			multi_mat.materialList[c] = std_mat
			multi_mat.materialIDList[c] = c
		)

		multi_mat --return
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

	private

	/** Get array of rgb values
	  * @param	integer	colors	Number of generated colors
	  * @param	array	minmax	Min and Max color value, high values produce lighter colors
	  * @return [rgb]
	 */
	function getColorsPallete colors minmax:#(0 ,255) =
	(
		_min	= minmax[1]
		_max	= minmax[2]

		increment	= ceil ( _max/(colors/3/2))
		--print ( "increment=" + increment as string )
		_value	= 0

		RGB	= #()
		RGB_all	= #()

		for c=1 to colors do
		(
			if( c>1 and c<=colors/3 ) then
				_value += increment

			else if( c>colors/3+2 ) then
				_value -= increment

			append RGB (this._rgb _value _min _max)
			--append RGB c
			--print ( "_value "+c as string +"	" + RGB[c] as string )
		)

		third_1 = ceil (colors/3)
		third_2 = ceil (colors/3*2)

		rgb_g	= RGB
		rgb_r	= for i = third_1+1	to colors	collect RGB[i]
		rgb_b	= for i = third_2+1	to colors	collect RGB[i]

		join rgb_r (for i = 1	to third_1	collect RGB[i])
		join rgb_b (for i = 1	to third_2	collect RGB[i])

		for c=1 to colors do
			append RGB_all #( rgb_r[c], rgb_g[c], rgb_b[c] )

		RGB_all --return
	),

	/** get rgb Rgb
	 */
	function _rgb rgb_value _min _max =
	(
		if( rgb_value > _max ) then
			rgb_value = _max --return
		else if( rgb_value < _min ) then
			rgb_value = _min --return

		rgb_value as float --return
	),


	/**
	 */
	on create do
	(
		--format "\n"; print "MaterialId.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
