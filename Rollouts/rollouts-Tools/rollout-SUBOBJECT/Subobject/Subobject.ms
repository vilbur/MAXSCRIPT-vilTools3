/** Subobject
 */
struct Subobject_v
(
	/* construct */
	
	
	/* properties */
	
	
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Enter or quit subobject
	 */
	function enterOrQuitSubobject sub_obj =
	(
		format "\n"; print "Subobject_v.enterOrQuitSubobject()"
		
		if selection.count == 0 then
			return false
		
		max modify mode
		
		if numSubObjectLevels != 0 then
			subObjectLevel = if subObjectLevel != sub_obj then sub_obj else 0
			
		else
			this._tryAddSubobjectModier(sub_obj)
		
	),
	
	
	private
	
	
	/** Try add subobject modier
	 */
	function _tryAddSubobjectModier sub_obj =
	(
		format "\n"; print "Subobject_v._tryAddSubobjectModier()"
		if selection.count == 1 then 
		(
			obj	= selection[1]
			
			class_of_baseobject = superClassOf obj.baseObject
			
			if class_of_baseobject == GeometryClass then
				modPanel.addModToSelection (Edit_Poly ()) ui:on
			
			else if class_of_baseobject == shape then 
				modPanel.addModToSelection (Edit_Spline ()) ui:on

			if numSubObjectLevels != 0 then
				subObjectLevel = if subObjectLevel != sub_obj then sub_obj else 0
			
		)
		
	),
	
	
	/**  
	 */
	on create do
	(
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop ) 
	)
	
)