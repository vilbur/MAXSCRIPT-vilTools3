/** Platform modifiers
 */
struct PlatformModifiers_v
(
	/* construct */
	Options,
	mat_ids,

	/* properties */


	/* options */


	/* dependency */
	/* reference */
	/* inhered */

	/** Add modifiers
	  *
	  */
	function addModifiers =
	(
		--format "\n"; print "PlatformGenerator_v._addModifiers()"

		this._sanitizeMaxChamferValue()
		--format "this.Options:	% \n" this.Options
		max modify mode

		this._addEditSpline()

		this._addSweepModifier("Bar Width")

		this._selectFace("Select Base")(mat_ids[#BASE])

		this._extrude("Extrude Base") (this.Options.base_extrude)

		this._chamfer("Chamfer Base") ( this.Options.chamfer_base )

		this._chamfer("Chamfer Bar") ( this.Options.chamfer_top ) selection_option:#ALL materialoption:#DIFFERENT

		this._selectFace("Select Top Face")(mat_ids[#TOP])

		this._extrude("Extrude Top")(this.Options.extrude_top)
	),

	private

	/** Make sure that chamfer value is less then radius
	  */
	function _sanitizeMaxChamferValue =
	(
		--format "\n"; print "PlatformModifiers_v._sanitizeMaxChamferValue()"

		if this.Options.bar_width / 2 == this.Options.chamfer_top then
			this.Options.chamfer_top -= 0.05

	),

	/** Add edit spline
	  *
	  */
	function _addEditSpline =
	(
		format "\n"; print "PlatformModifiers_v._addEditSpline()"
		modPanel.addModToSelection (Edit_Spline ())
	),

	/** SWEEP Modifier
	  *
	  */
	function _addSweepModifier name =
	(
		format "\n"; print "PlatformGenerator_v._addSweepModifier()"

		--format "Adding Sweep\n"
		--format "bar_width:	% \n" this.Options.bar_width
		--format "bar_radius:	% \n" (this.Options.bar_width / 2)

		sweep_mod = sweep name:name

		modPanel.addModToSelection ( sweep_mod ) --ui:on

		sweep_mod.CurrentBuiltInShape = 4 -- Set cylinder

		redrawViews() -- IMPORTANT TO UPDATE AFTER SETTING SHAPE AND BEFORE EDITING ITS PROPERTIES

		sweep_mod[#Cylinder_Section].radius	= this.Options.bar_width / 2
		sweep_mod[#Cylinder_Section].steps	= 6 -- Interpolation

		--sweep_mod[#Bar_Section].cornerRadius = 0

		/* GENERATE MATERIAL ID */
		sweep_mod.UseSectionIDs	= false
		sweep_mod.UsePathIDs	= true

	),

	/** Add SELECT modifier
	  *
	  */
	function _selectFace name mat_id  =
	(
		format "\n"; print "PlatformGenerator_v._selectFace()"
		--format "Adding Volume Select\n"

		volume_sel_mod = Vol__Select name:name

		volume_sel_mod.level	= 2	-- select face
		volume_sel_mod.volume	= 5	-- select by material ID
		volume_sel_mod.matID	= mat_id	-- select face by mat ID

		modPanel.addModToSelection ( volume_sel_mod ) --ui:on
	),

	/** Chamfer
	  *
	  */
	function _chamfer name amount selection_option:#STACK materialoption:#OFF /* minangle:  */ =
	(
		format "\n"; print "PlatformGenerator_v._chamfer()"
		--format "%:	% \n" name amount

		chamfer_mod = Chamfer name:name

		chamfer_mod.selectionoption = case selection_option of
		(
			#STACK:	0 -- from stack
			#ALL:	5 -- all edges
		)

		/* SET CHAMFER VALUES */
		chamfer_mod.amount 	 = amount

		chamfer_mod.segments = 0

		/* UNSMOOTH OBJECT */
		chamfer_mod.smooth 	= true

		chamfer_mod.SmoothType = 0

		chamfer_mod.smooththreshold = 0

		chamfer_mod.materialoption = case materialoption of -- CHAMFER MATERIAL
			(
				#OFF:	0 -- mat_ids off
				#DIFFERENT:	1 -- different mat_ids
			)


		/* BACKUP MAYBE IT WILL BE NEEDE NEEDED

			--chamfer_mod.minangle = minangle


			--chamfer_mod.setmaterial	= true
			--chamfer_mod.materialID	= mat_ids[#CHMAFER]

		*/

		modPanel.addModToSelection ( chamfer_mod ) --ui:on
	),

	/** Add extrude modifier
	  *
	  */
	function _extrude name amount scale: =
	(
		format "\n"; print "PlatformGenerator_v._extrudeBase()"
		extrude_mod = Face_Extrude name:name

		extrude_mod.amount	= amount

		--if scale != unsupplied then
			--extrude_mod.scale	= scale

		modPanel.addModToSelection ( extrude_mod ) --ui:on
	),


	/**
	 */
	on create do
	(
		--format "\n"; print "PlatformModifiers.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)
)
