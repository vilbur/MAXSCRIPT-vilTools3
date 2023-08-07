
/** Test if is Editable_Poly or Edit_Poly
 */
function isEpoly =
(
	matchPattern (( modPanel.getCurrentObject()) as string ) pattern:"Edit* Poly"
)

/** Test if is Editable_Poly or Edit_Poly
 */
function isEditPoly =
(
	classOf ( modPanel.getCurrentObject()) == Edit_Poly
)

/** Test if is Editable_Poly or Edit_Poly
 */
function isEditablePoly =
(
	classOf ( modPanel.getCurrentObject()) == Editable_Poly
)

/** Test if is sub object
 *
 * @param integer|#(integer)|#() numbers of subobjects, if empty array, then all subobjects are taken
 */
function isSubObject subobjects =
(
	--format "\n"; print "EpolyFilter.ms.isSubObject()"

	if subObjectLevel != undefined then
	(
		if classOf subobjects == integer then
			subobjects == subObjectLevel --return
		else
			findItem subobjects subObjectLevel > 0

	)
	else
		false --return
)

