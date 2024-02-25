filein( getFilenamePath(getSourceFileName()) + "/MeshVertexGetter/MeshVertexGetter.ms" )	--"./MeshVertexGetter/MeshVertexGetter.ms"
filein( getFilenamePath(getSourceFileName()) + "/PlatformModifiers/PlatformModifiers.ms" )	--"./PlatformModifiers/PlatformModifiers.ms"
filein( getFilenamePath(getSourceFileName()) + "/PlatformOptions/PlatformOptions.ms" )	--"./PlatformOptions/PlatformOptions.ms"
filein( getFilenamePath(getSourceFileName()) + "/HelperObject/HelperObject.ms" )	--"./HelperObject/HelperObject.ms"
filein( getFilenamePath(getSourceFileName()) + "/SupportObject/SupportObject.ms" )	--"./SupportObject/SupportObject.ms"
filein( getFilenamePath(getSourceFileName()) + "/BeamGenerator/BeamGenerator.ms" )	--"./BeamGenerator/BeamGenerator.ms"
filein( getFilenamePath(getSourceFileName()) + "/HelperGenerator/HelperGenerator.ms" )	--"./HelperGenerator/HelperGenerator.ms"
filein( getFilenamePath(getSourceFileName()) + "/SupportGenerator/SupportGenerator.ms" )	--"./SupportGenerator/SupportGenerator.ms"

/** Support manager
 */
struct SupportManager_v
(
	/* construct */


	/* properties */


	/* dependency */
	/* reference */
	/* inhered */



	private


	/**
	 */
	on create do
	(
		--format "\n"; print "SupportManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
