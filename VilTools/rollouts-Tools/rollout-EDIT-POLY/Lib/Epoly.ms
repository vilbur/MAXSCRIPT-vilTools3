filein( getFilenamePath(getSourceFileName()) + "/Lib/EditablePoly/EditablePoly.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/EditPoly/EditPoly.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/Lib/EpolySelection/EpolySelection.ms" )


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