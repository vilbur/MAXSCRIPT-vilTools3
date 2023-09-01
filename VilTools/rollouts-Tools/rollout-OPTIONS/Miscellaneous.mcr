/*------------------------------------------------------------------------------
	SCENE EXPLORER
--------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
	MEMORY
--------------------------------------------------------------------------------*/
/**
 */
macroscript	_options_free_memory
category:	"_Otions"
buttontext:	"Free Memory"
tooltip:	"Remove Undo\n\nClean Texture Memory"
(

	gc()	--Garbage Collection.
	freeSceneBitmaps()	--Cleans up in texture memory.
	clearUndoBuffer()	--Removes your Undo’s

	messageBox "Memory CLeaned" title:"Memory Clean"
)
