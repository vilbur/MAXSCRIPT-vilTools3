filein( getFilenamePath(getSourceFileName()) + "/Lib/ObjectRenamer/ObjectRenamer.ms" )

/*------------------------------------------------------------------------------
	GROUPBOX PREFIX
--------------------------------------------------------------------------------*/

/**  
  *	
  */
macroscript selection_edit_name_prefix_by_parent
category:	"Selection"
buttonText:	"by parent"
tooltip:	""
--icon:	"control:checkbox|Groupbox:Prefix|across:1"
icon:	"across:2"
(
	
)

/**  
  *	
  */
macroscript selection_edit_name_prefix_by_layer
category:	"Selection"
buttonText:	"by layer"
tooltip:	""
--icon:	"control:checkbox|Groupbox:Prefix|across:1"
icon:	"across:1"
(
	
)



--
--/**  
--  *	
--  */
--macroscript selection_edit_name
--category:	"Selection"
--buttonText:	"[base name]"
--tooltip:	"original name is used, if name is empty"
--icon:	"control:editText|Groupbox:Base Name|across:1"
----icon:"offset:[-32,16]"											 -- BUG: offset does not work in groupsbox
--(
--	
--)
--
--/*------------------------------------------------------------------------------
--	GROUPBOX SUFFIX
----------------------------------------------------------------------------------*/
--
--macroscript selection_edit_name_suffix_by_parent
--category:	"Selection"
--buttonText:	"A-Z"
--tooltip:	""
--icon:	"control:checkbox|Groupbox:Suffix|across:1"
--(
--	
--)
--
--
--/**  
--  *	
--  */
--macroscript selection_rename
--category:	"Selection"
--buttonText:	"Rename"
--tooltip:	"Load Selection"
--icon:	"across:1|height:48"
--(
--	
--	ObjectRenamer = ObjectRenamer_v()
--	
--	_selection = selection
--	
--	ObjectRenamer.rename _selection
--		
--	select _selection
--)
