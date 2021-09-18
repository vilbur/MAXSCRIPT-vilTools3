/** Tool mode
 *
 *	FEATURES:
 *
 *	 Tools: Move|Scale
  *		ALLOWS #x|#y|#xy axises in ortho view 
 *
 *	 Tools: Rotate
 *		ALLOWS #z axis in ortho view
 *		ALLOWS #x|#y|#z axis in perspective views
 *
 */
struct ToolMode_v
(
	tool_mode,
	viewport_type,
	
	tool_modes	= #( #SELECT, #MOVE, #ROTATE, #NUSCALE, #USCALE, #SQUASH ),

	axises =  #( #x, #y, #z, #xy, #zx, #yz  ),
	
	/** Set tool or change axis
	 */
	function setToolOrChangeAxis =
	(
		this._setAxisesByTypeOfView()
		
		if not ( this._setTool() ) then 
			this.circle()
			
		format "axises = % \n" axises
	),
	
	/** Set rotate tool or change axis
	 */
	function setRotateToolOrChangeAxisInOrtho =
	(
		
		
		if not ( this._setTool() ) then 
			this.circle()
		
	),
	
	/** Set tool or change selection type
	 */
	function setToolOrChangeSelectionType selection_types =
	(
		if not ( this._setTool() ) then 
			this.circleSelectionTypes selection_types
		
	),
	
	/** Circle axis modes axises in array
	  * @param	#( #x, #y, #z, #xy, #zx, #yz )	axises	 
	 */
	function circle  =
	(		
		next_axis	= this.findNextIndex axises (findItem axises (this.activeAxis()))

		toolMode.axisConstraints = axises[next_axis]
	),
	
	/** Selection types
	  * @param	array	selection_types	Customized #( #Rectangle, #Circle, #Fence, #Lasso, #Paint )
	 */
	function circleSelectionTypes selection_types =
	(
		if( current_selection_type == undefined ) then
			global current_selection_type
		
		next_index	= this.findNextIndex selection_types (findItem selection_types current_selection_type)
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
	
	/** _set axises by type of view
	 */
	function _setAxisesByTypeOfView =
	(
		viewport_type = viewport.getType();		

		format "tool_mode = % \n" tool_mode
		if( tool_mode != #Rotate ) then
			this._setAxisesNonRotate()

		else 
			this._setAxisesRotate()

		
		
		this._disableWorldSystemInOrthoView viewport_type
	),
	
	/** _is ortho view
	 */
	function _isOrthoView =
	(
		viewport_type != #view_persp_user and viewport_type != #view_iso_user
	),
	
	/**  For Move|Rotate|Scale Tools Allow only #x|#y|#xy axises in ortho view 
	 */
	function _setAxisesNonRotate =
	(
		if ( this._isOrthoView() ) then 
			axises =  #( #x, #y, #xy )
	),
	
	/** For Rotate tool
	  *		Allow only #z axis in ortho view
	  *		Allow only ##x|#y|#z axis in perspective views
	 */
	function _setAxisesRotate =
	(
		--axises =  if( this._isOrthoView()) then #( #z ) else #( #x, #y, #z )
		
		 if( this._isOrthoView()) then
			axises = #( #z )
		
		
	),
	
	/** Allow only x,y axis in ortho view
	 */
	function _disableWorldSystemInOrthoView viewport_type =
	(
		cord_sys = getRefCoordSys() 		

		if ( cord_sys == #world and viewport_type != #view_persp_user and viewport_type != #view_iso_user ) then 
			toolMode.coordsys #view
	),
	
	/** Find next index
	 */
	function findNextIndex array current_index =
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
	function test =
	(
		messagebox "ToolMode.test()"
	)
)
