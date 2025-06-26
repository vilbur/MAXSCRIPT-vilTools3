/** Recent file
 */
struct RecentFile_v
(
	/* construct */


	/* properties */
	xml_doc	= dotNetObject "System.Xml.XmlDocument",
	recent_file	= (getDir #maxData) + "RecentDocuments.xml",


	/* dependency */
	/* reference */
	/* inhered */

	/** Get most recent file
	 */
	function getMostRecentFile =
	(
		--format "\n"; print "RecentFile_v.getMostRecentFile()"
		xml_doc.load recent_file

		file_paths = xml_doc.GetElementsByTagName "FilePath"

		(file_paths.item 0).InnerXML --return
	),

	/** Get recent file not matching mask in blacklist
	  * @param Array blacklist aray of directories which not should be opened
	  */
	function getRecentFileNotMatching blacklist:#() =
	(
		--format "\n"; print "RecentFile_v.getRecentFileNotBackup()"

		xml_doc.load recent_file

		file_paths = xml_doc.GetElementsByTagName "FilePath"

		for i = 0 to file_paths.count - 1 where (file_path_xml = (file_paths.item i)) != undefined  do
		(
			file_path = file_path_xml.InnerXML

			find_in_blacklist = false

			for mask in blacklist where matchPattern file_path  pattern:( "*\\" + mask + "\\*" ) do
				find_in_blacklist = true

			if not find_in_blacklist then
				return file_path
		)

		undefined --return
	),

	private


	/**
	 */
	on create do
	(
		--format "\n"; print "RecentFile.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
