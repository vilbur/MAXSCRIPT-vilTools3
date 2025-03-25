clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../ViewportLayoutManager.ms" )	--"./../ViewportLayoutManager.ms"


ViewportLayoutManager = ViewportLayoutManager_v()
	
	
--ViewportLayoutManager.restoreLayout(#layout_4)
--ViewportLayoutManager.restoreLayout(#layout_3vl)
--ViewportLayoutManager.restoreLayout(#layout_3vr)



ViewportLayoutManager.restoreSplitBars()