filein( getFilenamePath(getSourceFileName()) + "/../ObjExporter.ms" )	-- "./../ObjExporter.ms"
import_browse

clearListener()

delete objects

_teapot = Teapot isSelected:on

--
--ObjExporter 	= ObjExporter_v( getFilenamePath(getSourceFileName())  )
--
--ObjExporter.export


Exporter = exporterPlugin.classes[findItem exporterPlugin.classes ObjExp]

ini_file	= Exporter.getIniName()
--ini_preset	= Exporter.getPresetIniName()


format "ini	= % \n" ini
--format "ini_preset	= % \n" ini_preset


setINISetting ini_file "Geometry" "ObjScale" "10"
setINISetting ini_file "Geometry" "FlipZyAxis" "1"
setINISetting ini_file "Geometry" "FlipZyAxis" "0"