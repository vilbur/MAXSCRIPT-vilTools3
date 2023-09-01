/** Modifier preset menu creator
  *
  * 1) Generate "{classof modifier}.mcr" file where each macroscript runs modifier preset
  * 2) Add these macroscripts to menu
  *
 */
struct ModifierPresetMenuCreator_v
(
	/* construct */


	/* properties */
	ini_file,
    mcr_file,


	/* dependency */
	/* reference */
	/* inhered */

	/** Create menu
	  *
	  */
	function createMenu ini_file =
	(
		format "\n"; print "ModifierPresetMenuCreator_v.createMenu()"
		format "INI:	% \n" INI
		this.ini_file = ini_file

		this._setOutputFile()

		format "this.mcr_file:	% \n" this.mcr_file

	),

	private

    /** Write to file
    *
    */
    function writeToFile macro_data =
    (
        --format "\n"; print "MacroscriptGenerator_v.writeToFile()"

        /* CREATE FILE */
        this.mcr_file = createFile this.mcr_file

        /* WRITE FILE START */
        if general_params[#filein] != undefined then
			format "filein %\n\n" general_params[#filein] to:mcr_file

        try(

            /* WRITE EACH MACROSCRIPT */
            for macro_data in macroscripts do
				this.writeSectionsToFile(macro_data)

        )catch(

            format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
            format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
            format "\n——————————————————— TRACE ———————————————————\n%\n"(getCurrentExceptionStackTrace())
            format "\n——————————————————— STACK ———————————————————\n%\n"(getCurrentExceptionCallStack())

            close this.mcr_file
        )

        /* CLOSE FILE */
        close this.mcr_file
    ),


	/** Set mcr file
	  *
	  */
	function _setOutputFile =
	(
		--format "\n"; print "MacroscriptGenerator_v._setOutputFile()"
		--this.mcr_file = ( trimRight this.ini_file ".ini" )

		--if not matchPattern  this.mcr_file pattern:"*.mcr" then
		 this.mcr_file = ( trimRight this.ini_file ".ini" ) + ".mcr"
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "ModifierPresetMenuCreator.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)

)
