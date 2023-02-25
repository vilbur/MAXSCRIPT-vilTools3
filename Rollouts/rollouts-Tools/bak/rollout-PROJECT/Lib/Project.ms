/** Create Project direcotries
  *
  * @property	2D Matrix	structure	folders to create
  *
  * E.G.:
  *	structure = #(
  *			"Dir 1",
  *			#("Dir 2", -- if array, then first item is directory and others are subdirecory of that directory
  *				"Subdir 1",
  *				"Subdir 2",
  *			),
  *			"Dir 3"
  *		)
  *
 */
struct Project_v
(
	/* construct */
	structure = #(),
	project_name = "",
	project_root = "",

	/* properties */

	/* dependency */
	/* reference */
	/* inhered */

	/** Create directory structure

	 */
	function createDirectoryStructure =
	(
		--format "\n"; print "Project_v.createDirectoryStructure()"
		project_root = trimRight ( trimLeft project_root )
		project_name = trimRight ( trimLeft project_name )

		if this._checkProperties() != true then
			return false

		this._createSubDirs ( pathConfig.appendPath project_root project_name ) (structure)
	),


	private


	/** Create dir
	  *
	  * @param	array	directories
	 */
	function _createSubDirs root_dir directories =
	(
		--format "\n"; print "Project_v._createSubDirs()"
		for dir in directories do
			if classOf dir == string then
			(
				if not this._createDir( pathConfig.appendPath root_dir dir ) then
					exit
			)
			else if classOf dir == Array then
				this._createSubDirs ( pathConfig.appendPath root_dir dir[1] ) (deleteItem dir 1)
	),

	/** Create dir
	 */
	function _createDir _path =
	(
		--format "\n"; print "Project_v.createDir()"
		dir_created = makeDir _path all:true

		if not dir_created then
			messageBox ("There is problem to create directory\n\n"+_path) title:"CREATE DIRECTORY ERROR"

		dir_created --return
	),


	/** Check properties
	 */
	function _checkProperties =
	(
		format "\n"; print "Project_v._checkProperties()"
		format "project_name	= % \n" project_name
		format "project_root	= % \n" project_root

		/** Is string empty
		 */
		function isStringEmpty _string =
		(
			(( dotNetClass "System.Text.RegularExpressions.RegEx" ).match _string "^\s+$|^$").success
		)

		if isStringEmpty(project_name) then
			messageBox "Fill project name" title:"PROJECT NAME MISSING"

		else if isStringEmpty(project_root) then
			messageBox "Fill projects root path" title:"PROJECTS PATH MISSING"

		else
			return true
	),


	/**
	 */
	on create do
	(
		format "\n"; print "Project.onCreate()"
	)
)