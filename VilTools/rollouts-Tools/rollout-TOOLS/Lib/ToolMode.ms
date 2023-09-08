/** Tool mode
 *
 *	FEATURES:
 *
 *	 Tools: Move|Scale
 *		ALLOWS #x|#y|#xy axises in ortho view
 *
 *
 */
struct ToolMode_v
(
	tool_mode,

	tool_modes	= #( #SELECT, #MOVE, #ROTATE, #NUSCALE, #USCALE, #SQUASH ),

	axises =  #( #x, #y, #z, #xy, #zx, #yz  ), -- axises used for cyclicng

	ortho,	-- axises allowed in ortho view,	if undefined then axises are used
	perspective,	-- axises allowed in perspective view,	if undefined then axises are used

	/* dependency */


	/** Set tool or change axis
	 */
	function setToolOrChangeAxis =
	(
		this._setAxisesByViewAndCoordSystem()

		this._setToolOrCircleAxis()
	),

	/** Allow #x|#y|#z for rotate tool in ortho
	 */
	function setRotateToolOrChangeAxisInOrtho =
	(
		this._setToolOrCircleAxis()
	),

	/** Set tool or change selection type
	 */
	function setToolOrChangeSelectionType selection_types =
	(
		if not ( this._setTool() ) then
			this.circleSelectionTypes (selection_types)
	),

	/** Circle axis modes axises in array
	  * @param	#( #x, #y, #z, #xy, #zx, #yz )	axises
	 */
	function circleAxis  =
	(
		next_axis_index	= this._findNextIndex axises (findItem axises (this.activeAxis()))

		toolMode.axisConstraints = axises[next_axis_index]
	),

	/** Selection types
	  * @param	array	selection_types	Customized #( #Rectangle, #Circle, #Fence, #Lasso, #Paint )
	 */
	function circleSelectionTypes selection_types =
	(
		if( current_selection_type == undefined ) then
			global current_selection_type

		next_index	= this._findNextIndex selection_types (findItem selection_types current_selection_type)
		current_selection_type	= selection_types[next_index]

		case current_selection_type of
		(
			#Circle:	actionMan.executeAction 0 "59233" -- Selection: Circular Selection Region
			#Fence:	actionMan.executeAction 0 "59234" -- Selection: Fence Selection Region
			#Lasso:	actionMan.executeAction 0 "59235" -- Selection: Lasso Selection Region
			#Paint:	actionMan.executeAction 0 "59236" -- Selection: Paint Selection Region
			default:	actionMan.executeAction 0 "59232" -- Selection: Rectangular Selection Region
		)
	),

	/** Active mode
	 */
	function activeMode =
	(
		toolMode.commandmode	 --return
	),

	/** Active axis
	 */
	function activeAxis =
	(
		toolMode.axisConstraints	 --return
	),

	private

	/** Get next axis
	 */
	function _getNextAxis =
	(
		--format "\n"; print "ToolMode_v.getNextAxis()"
		next_axis_index	= this._findNextIndex axises (findItem axises (this.activeAxis()))

		axises[next_axis_index] --return
	),

	/** _set tool or circleAxis axis
	 */
	function _setToolOrCircleAxis =
	(
		if not ( this._setTool() ) then
			this.circleAxis()
	),

	/** Set axises by type of view - Ortho or Perspective
	  *
	  * Allow only X|Y in ortho view BUT NOT IF #local coordsystem is active
	  *
	 */
	function _setAxisesByViewAndCoordSystem =
	(

		if ( GetRefCoordSys() != #local and  this._isOrthoView() and this.ortho != undefined ) then
			this.axises = this.ortho


		else if ( not this._isOrthoView() and this.perspective != undefined ) then
			this.axises = this.perspective

		this._disableWorldSystemInOrthoView()
	),

	/** _is ortho view
	 */
	function _isOrthoView =
	(

		matchPattern ( viewport.getType() as string ) pattern:@"*user" == false --return
	),

	/** Allow only x,y axis in ortho view
	 */
	function _disableWorldSystemInOrthoView =
	(
		cord_sys = getRefCoordSys()

		if ( cord_sys == #world and this._isOrthoView() ) then
			toolMode.coordSys #view
	),

	/** Find next index
	 */
	function _findNextIndex array current_index =
	(
		next_index	= current_index + 1

		if( next_index<=array.count or next_index <= 0 ) then next_index else 1 --return
	),

	/** Set tool
	 */
	function _setTool =
	(
		if( this.activeMode() != tool_mode ) then
		(
			toolMode.commandmode = tool_mode

			true --return
		) else
			false --return

	),

	/**
	 */
	on create do
	(

	)
)