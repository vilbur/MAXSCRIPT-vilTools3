--clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../ViewportLayoutManager.ms" )	--"./../ViewportLayoutManager.ms"


ViewportLayoutManager = ViewportLayoutManager_v()
	
	
ViewportLayoutManager.loadAndConfigureLayout(#layout_4)

--ViewportLayoutManager.restoreLayout(#layout_4vl)
--ViewportLayoutManager.restoreLayout(#layout_4vr)

--ViewportLayoutManager.restoreLayout(#layout_3vl)
--ViewportLayoutManager.restoreLayout(#layout_3vr)

/* LAYOUT MUST BE SAVED BEFORE RESTORE */ 
--ViewportLayoutManager.saveCurrentLayout()


/* RESTORE LAYOUT */ 
--ViewportLayoutManager.restoreSplitBars()