

/**  SEARCH EDIT TEXT FIELD
  */
macroscript selection_name_add_suffix
category:	"_Object-Name"
buttonText:	"[suffix text]"
tooltip:	"Text of suffix added to objects in selection"
icon:	"control:editText|across:3"
--icon:"offset:[-32,16]"											 -- BUG: offset does not work in groupsbox
(
	--format "EventFired	= % \n" EventFired
	--search_text = ROLLOUT_selection.search_in_name.text

	--format "search_text	= % \n" search_text
)


/** REMOVE SUFIX
  */
macroscript selection_add_suffix
category:	"_Object-Name"
buttonText:	"Add suffix"
tooltip:	"Add suffix to objects in selection"
icon:	"across:3"
(
	--filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\Object Name.mcr" ) -- DEV
	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-SELECTION\SUFFIX NAME.mcr"
		--trailing_number = "[^\s]*\d+$" -- match suffix number without delimeter E.G.: "trailing-number002"
		suffix_text  = ROLLOUT_selection.ET_suffix_text.text

		undo "Add sufix" on
			for obj in selection do
			(
				RegEx = RegExer_v( obj.name )

				if not RegEx.isMatch(".*"+ suffix_text +"$") then  
					obj.name += suffix_text
			)
	)
)










/** REMOVE SUFIX
  */
macroscript selection_remove_suffix
category:	"_Object-Name"
buttonText:	"Remove sufix"
tooltip:	"Remove sufix from object name.\n\n1) Remove traling number 'FOO-BAR002' > 'FOO-BAR'\n\n2) After delinmeter 'foo-bar-sufix' > 'foo-bar'"
icon:	"MENU:true|across:3"
(
	--filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\Object Name.mcr" ) -- DEV
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-SELECTION\MANAGE NAME.mcr"
		trailing_number = "[^\s]*\d+$" -- match suffix number without delimeter E.G.: "trailing-number002"

		undo "Remove sufix" on
			for obj in selection do
			(
				RegEx = RegExer_v( obj.name )

				obj.name =  if RegEx.isMatch("[^\s]*\d+$") then  -- match suffix number without delimeter E.G.: "trailing-number002"
								RegEx.replaceInString ("\d+$")("")

							else
								RegEx.removeSufix()
			)
	)
)
