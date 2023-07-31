filein( getFilenamePath(getSourceFileName()) + "/EditablePoly/EditablePoly.ms" )
filein( getFilenamePath(getSourceFileName()) + "/EditPoly/EditPoly.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/EpolySelection/EpolySelection.ms" )


/** Epoly_v
 */
function Epoly_v =
(
	case classof ( _mod = modPanel.getCurrentObject()) of
	(
		Editable_Poly: EditablePoly_v(_mod)
		Edit_Poly:     EditPoly_v(_mod)
		default:       false
	)
)