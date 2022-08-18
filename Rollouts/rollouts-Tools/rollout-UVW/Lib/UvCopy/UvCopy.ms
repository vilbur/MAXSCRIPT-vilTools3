/** Copy UVs
*/
function copyUV source_channel target_channel =
(
   format "\n"; print "UvCopy()"
   
   _objects = for o in selection where superClassOf o GeometryClass collect o
   
   for obj in _objects do
   (
	   if ( polyop.getMapSupport obj target_channel == false ) do polyop.setMapSupport obj target_channel true 
	   
	   --polyop.setNumMapVerts obj target_channel (polyop.getNumMapVerts obj source_channel ) keep:false
	   --polyop.setNumMapFaces obj target_channel (polyop.getNumMapFaces obj source_channel)  keep:false
	   
	   polyop.setNumMapVerts obj target_channel ( polyop.getNumMapVerts obj source_channel) keep:false
	   polyop.setNumMapFaces obj target_channel ( polyop.getNumMapFaces obj source_channel)  keep:false
	   
	   
	   for v = 1 to ( polyop.getNumMapVerts obj target_channel) do 
		   polyop.setMapVert obj target_channel v ( polyop.getMapVert obj source_channel v)

	   for f = 1 to ( polyop.getNumMapFaces obj target_channel) do
		   polyop.setMapFace obj target_channel f (polyop.getMapFace obj source_channel f)
   )
   
)