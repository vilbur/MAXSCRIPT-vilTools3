clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../SelectionSetsManager.ms" )	--"./../SelectionSetsManager.ms"

delete objects

_box	   = Box()
_teapot = Teapot()
_shpere = Sphere()



SelSets = SelectionSetsManager_v()

SelSets.openDialog()

SelSets.addObj _box	"first_set"
SelSets.addObj _teapot	"first_set" 
SelSets.addObj _shpere	"first_set" replace:true
