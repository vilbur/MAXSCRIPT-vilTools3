

global LOOP_RING_COUNT	= 0
global LOOP_RING_LAST_DIR
global LOOP_RING_LAST_MODE


/*
 */
struct EPolyRingLoop_v
(
	/* construct */

	/* properties */
	epoly,

	loop_or_ring,
	direction,
	mode,

	move_only,
	add_remove,

	/* dependency */
	/* reference */
	/* inhered */

	/**
	  *	"param #loop|#ring	loop_or_ring
	  *	"param #up|#down	direction
	  *	"param #move|#select|#deselect	mode
	  *
	  */
	function selectLoopRing loop_or_ring direction mode =
	(
		--format "\n"; print "EditPolyRingLoop_v.selectLoopRing()"
		epoly	= modPanel.getCurrentObject()

		if (classOf epoly == Edit_Poly or classOf epoly == Editable_Poly) and subObjectLevel == 2 then
		(
			this.setProperties (loop_or_ring) (direction) (mode)

			if mode != LOOP_RING_LAST_MODE then
				this.resetGlobals()

			LOOP_RING_LAST_MODE = mode


			if classOf epoly == Editable_Poly then
				this.editablePoly()

			else
				this.editPoly()

		)

	),

	/** Reset
	  *
	  */
	function resetGlobals =
	(
		--format "\n"; print "EPolyRingLoop_v.reset()"
		LOOP_RING_COUNT	= 0
		LOOP_RING_LAST_DIR	= undefined
		LOOP_RING_LAST_MODE	= undefined
	),

	private

	/** Edit poly
	  *
	  */
	function editablePoly =
	(
		--format "\n"; print "EPolyRingLoop_v.editPoly()"
		if loop_or_ring == #loop
			then
				epoly.setLoopShift direction move_only add_remove
			else
				epoly.setRingShift direction move_only add_remove
	),

	/** Edit poly
	  *
	  */
	function editPoly   =
	(
		--format "\n"; print "EPolyRingLoop_v.editPoly()"
		if LOOP_RING_LAST_DIR != direction do LOOP_RING_COUNT = 1
			LOOP_RING_LAST_DIR = direction

		subobject_sel = epoly.GetSelection #Edge

		direction_value = LOOP_RING_COUNT*direction

		--format "direction_value:	% \n" direction_value

		undo "Edge Select" on
		(
			if loop_or_ring == #loop
				then

					epoly.LoopSelect (direction_value) true false
				else
					epoly.RingSelect (direction_value) true false



			LOOP_RING_COUNT = amin (LOOP_RING_COUNT += 1) 3
			--LOOP_RING_COUNT = direction_value

			if mode != #move then
			(
				if mode != #select then
				(
					deselected = (subobject_sel - epoly.GetSelection #Edge)

					new_selection = subobject_sel - deselected

					if ( new_selection as Array ).count > 0 then
						--undo "Edge Select" on
							epoly.SetSelection #Edge new_selection -- set new swelection
					else
						epoly.SetSelection #Edge subobject_sel -- set old selection, prevent deselection of all elements

				)
				else
					--undo "Edge Select" on
						epoly.SetSelection #Edge  (subobject_sel + epoly.GetSelection #Edge)
			)
		)

	),

	/** Set properties
	  *
	  */
	function setProperties loop_or_ring direction mode =
	(
		--format "\n"; print "EPolyRingLoop_v.setProperties()"
		this.loop_or_ring	= loop_or_ring
		this.direction	= if direction == #up then 1 else -1
		this.mode	= mode

		this.move_only	= mode == #move
		this.add_remove	= mode == #select

	),

	/**
	 */
	on create do
	(
	)
)