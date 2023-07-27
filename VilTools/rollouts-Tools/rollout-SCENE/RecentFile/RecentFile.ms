/** Recent file
 */
struct RecentFile_v
(
	/* construct */


	/* properties */
	xml_doc = dotNetObject "System.Xml.XmlDocument",
	recent_documents_file = (getDir #maxData) + "RecentDocuments.xml",


	/* dependency */
	/* reference */
	/* inhered */

	/** Get most recent file
	 */
	function getMostRecentFile =
	(
		--format "\n"; print "RecentFile_v.getMostRecentFile()"
		xml_doc.load recent_documents_file

		file_path = xml_doc.GetElementsByTagName "FilePath"

		(file_path.item 0).InnerXML --return
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
