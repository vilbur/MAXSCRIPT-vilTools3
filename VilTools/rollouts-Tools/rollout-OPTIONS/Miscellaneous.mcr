

/*------------------------------------------------------------------------------
	MEMORY
--------------------------------------------------------------------------------*/
/**
 */
macroscript	_miscellaneous_free_memory
category:	"_miscellaneous"
buttontext:	"Free Memory"
tooltip:	"Remove Undo\n\nClean Texture Memory"
(

	gc()	--Garbage Collection.
	freeSceneBitmaps()	--Cleans up in texture memory.
	clearUndoBuffer()	--Removes your Undo’s

	messageBox "Memory CLeaned" title:"Memory Clean"
)


/*------------------------------------------------------------------------------

	TEST

--------------------------------------------------------------------------------*/



/**
 */
macroscript	_maxscript_test
category:	"_miscellaneous"
buttontext:	"TEST"
icon:	"control:checkbutton"
(

	on execute do
	(

	--	unregisterRedrawViewsCallback showGWtextTest
	--
	--
	--	if EventFired.val then
	--	(
	--		global showGWtextTest_TEXT = "WHOOOOOOOOOOOOOOA"
	--	startTextTimer()
	--
	----format "showGWtextTest_TEXT:	% \n" showGWtextTest_TEXT
	--
	--	registerRedrawViewsCallback showGWtextTest
	--	)
	--
	--	else
	--		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Miscellaneous.mcr"



	)

)