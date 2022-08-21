filein( getFilenamePath(getSourceFileName()) + "/Lib/ObjectRenamer/ObjectRenamer.ms" )



/**  SEARCH
  *	
  */
macroscript selection_edit_search_in_name
category:	"Selection"
buttonText:	"[search in name]"
tooltip:	"Search in selection names"
icon:	"control:editText|across:3"
--icon:"offset:[-32,16]"											 -- BUG: offset does not work in groupsbox
(
	
)

/**  REPlACE
  *	
  */
macroscript selection_edit_replace_in_names
category:	"Selection"
buttonText:	"[replace in name]"
tooltip:	"Replace in selection names"
icon:	"control:editText|across:3"
(
	
)



/**  
  *	
  */
macroscript selection_search_and_replace
category:	"Selection"
buttonText:	"Search & Replace"
tooltip:	"Search & Replace in names of selection"
icon:	"across:3"
(
	messageBox "Placeholder" title:"" 
				
)
