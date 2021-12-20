/** Save current settings of FBX Export Dialog
 *	
 *	EXCEPT "PopSettings"	and "PushSettings"	
 *	
 * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_54B1F140_B304_48A2_9829_C68B345E2044_htm
 * https://knowledge.autodesk.com/support/3ds-max/learn-explore/caas/CloudHelp/cloudhelp/2022/ENU/3DSMax-Data-Exchange/files/GUID-249100FE-67BE-43B8-AF12-D20703CDF8D1-htm.html
 *	
 */

ini	= getFilenamePath(getSourceFileName()) + "\FbxExportSettings\FbxExportSettings.ini",


fbx_props	=
#(  "Animation",
	"ASCII",
	"AxisConversionMethod",
	"BakeAnimation",
	"BakeFrameStart",
	"BakeFrameEnd",
	"BakeFrameStep",
	"BakeResampleAnimation",
	"Cameras",
	"CAT2HIK",
	"ColladaTriangulate",
	"ColladaSingleMatrix",
	"ColladaFrameRate",
	"Convert2Tiff",
	"ConvertUnit",
	"EmbedTextures",
	"FileVersion",
	"FilterKeyReducer",
	"GeomAsBone",
	"GenerateLog",
	"Lights",
	"LoadExportPresetFile",
	"NormalsPerPoly",
	"PointCache",
	"Preserveinstances",
	"Removesinglekeys",
	"Resampling",
	"ResetExport",
	"ScaleFactor",
	"SelectionSet",
	"SelectionSetExport",
	"Shape",
	"Skin",
	"ShowWarnings",
	"SmoothingGroups",
	"SmoothMeshExport",
	"SplitAnimationIntoTakes",
	"TangentSpaceExport",
	"Triangulate",
	"UpAxis",
	"UseSceneName")


for prop in fbx_props do
	setINISetting ini "export-options" prop ((FBXExporterGetParam prop) as string )