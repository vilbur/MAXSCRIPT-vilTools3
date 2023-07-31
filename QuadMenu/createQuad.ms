for menu_file in getFiles (getFilenamePath(getSourceFileName()) + "\\Quads\\*.ms") do
	try(
		--menu_file	= ( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace menu_file "\\"

		filein( menu_file )

	)catch(

		format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
		format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
		format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
		format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())

    )



/** Add quads
 */
function createQuad quad_menu_name menu_functions =
(
	--format "\n\n\n"; print "quadMenuConfig.ms.createQuad()"

	--quads_input_order = #( #BOTTOM_LEFT,	#BOTTOM_RIGHT,	#TOP_LEFT,	#TOP_RIGHT )	-- order of quads in parameter
	quads_max_order   = #( #BOTTOM_RIGHT,	#TOP_RIGHT,		#TOP_LEFT,	#BOTTOM_LEFT )	-- order of quads in max

	/** Exe add functions
	 */
	function exeAddFunctions quad_menu_name quad_index add_function =
	(

		fn_name = add_function as string + "menu"

		if fn_name == undefined then
			format "\nFUNCTION DOES NOT EXISTS: %()\n" fn_name

		try(
			execute ( fn_name + "((QuadMenu_v(\""+quad_menu_name+"\")).getMenu("+quad_index as string +"))" )
		)catch(
			format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
			format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
			format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
			format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
		)
	)

	for quad_index = 1 to 4 where menu_functions[quad_index] != undefined  do
	(
		--format "quad_index	= % \n" quad_index
		--format "menu_functions[quad_index]	= % \n" menu_functions[quad_index]

		if classOf menu_functions[quad_index] == Array then
			for menu_function in menu_functions[quad_index] do
				exeAddFunctions (quad_menu_name) (quad_index) (menu_function)
		else
			exeAddFunctions (quad_menu_name) (quad_index) (menu_functions[quad_index])

	)

	QuadMenu_v(quad_menu_name) --return
)