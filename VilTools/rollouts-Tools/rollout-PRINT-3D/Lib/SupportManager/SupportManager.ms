

/** Support manager
 */
struct SupportManager_v
(
	/* construct */
	export_size,

	/* properties */


	/* dependency */
	Options = SupportOptions_v(),



	/* reference */
	/* inhered */

	/** Generate instanced point helpers from selected verts
	  *
	  */
	function generatePointHelpers source_objects =
	(
		format "\n"; print "PlatformGenerator_v.generatePointHelpers()"

		for source_obj in source_objects do
		(
			verts_data = (MeshVertexGetter_v(source_obj)).getVetexData()

			points_helpers = for i = 1 to (verts_to_generate = verts_data[1] as Array ).count collect
				(HelperObject_v Options:Options source_obj:source_obj vertex_index:verts_to_generate[i] pos:verts_data[2][i] normal:verts_data[3][i] wirecolor:verts_data[4][i] ).createOrUpdateHelper()


			format "POINTS_HELPERS	= % \n" points_helpers
		)
			--this._setPlatformObjects( source_obj )

		--Options.init()

		--max create mode
		--
		--points_created	= for PlatformObject in PlatformObjects collect
		--(
		--	--format "PlatformObject	= % \n" PlatformObject
		--	--PlatformObject.deleteOldPointsAndPlatforms()
		--
		--	PlatformObject.generatePointHelper()
		--
		--	--EditablePolyVertexGetter.addPointHelper(PlatformObject.vertex_index)(PlatformObject.point_helper)
		--
		--	--PlatformObject.point_helper
		--)
		----
		--this._reinstancePoints()
		--
		--redrawViews()
		--format "POINTS_CREATED	= % \n" points_created
		----if points_created.count > 0 then  points_created else #() --return
		--
		gc()

		#()--dev
		--for point_created in points_created where point_created != undefined collect point_created  -- return created points
	),


	private


	/**
	 */
	on create do
	(
		--format "\n"; print "SupportManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
