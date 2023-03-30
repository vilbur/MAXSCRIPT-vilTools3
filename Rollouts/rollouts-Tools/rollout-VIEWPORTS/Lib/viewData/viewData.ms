/** View data
 */
struct ViewData_v
(
	/* construct */
	/* properties */
	vpType	= #view_none,
	--vpGroupType	= #user,
	vpStartCoord	= [0,0,0],
	vpEndCoord	= [0,0,0],
	vpVS	= [0,0],
	vpFOV	= 0,
	vpFD	= 0,
	vpTM	= undefined,
	vpNode	= undefined,

	/* dependency */
	/* reference */
	/* inhered */


	/** Collect data
	 */
	function collectData =
	(
		format "\n"; print "ViewData_v.collectData()"

		view_bounds = this.minMaxSwap (( MapScreenToView [0,0] 0) * Inverse(getViewTM())) ((mapScreenToView (getViewSize ()) 0) * Inverse(getViewTM()))

		this.vpType	= viewport.getType()
		--this.vpGroupType	= checkVT supportedViews this.vpType
		this.vpStartCoord	= view_bounds[1]
		this.vpEndCoord	= view_bounds[2]
		this.vpVS	= getViewSize ()
		this.vpFOV	= getViewFOV()
		this.vpFD	= viewport.getFocalDistance()
		this.vpTM	= viewport.getTM()
		--this.vpNode	= if (node = viewport.getCamera()) != undefined do ( setUserProp node "vpdProp" mark ; node)
		format "this	= % \n" this
	),

	/** restore Viewport
	 */
	function restoreViewport =
	(
		format "\n"; print "ViewData_v.restoreViewport()"

		viewport.SetType this.vpType

		view_type_split	= filterString ( this.vpType as string ) "_"

		case view_type_split[view_type_split.count] of
		(
			#user:
			(
				viewport.setTM this.vpTM

				if this.vpType == #view_persp_user then
					( viewport.SetFOV this.vpFOV ; viewport.SetFocalDistance this.vpFD)
				else
				(
					viewport.ZoomToBounds off this.vpStartCoord this.vpEndCoord

					viewport.zoom (this.vpFOV / (viewport.getFOV()))
				)
			)

			#camera: (if isValidNode this.vpNode and viewport.canSetToViewport this.vpNode then viewport.setCamera this.vpNode else deadData = on)

			default: -- ORTHO
			(
				viewport.ZoomToBounds off this.vpStartCoord this.vpEndCoord

				viewport.zoom (this.vpFOV/(viewport.getFOV()))
			)

		)

		CompleteRedraw()

	),

	private

	function minMaxSwap p3min p3max =
	(
		if p3min.x > p3max.x then swap p3min.x p3max.x

		if p3min.y > p3max.y then swap p3min.y p3max.y

		if p3min.z > p3max.z then swap p3min.z p3max.z

		#(p3min, p3max) -- return
	),

	/**
	 */
	on create do
	(

	)

)
