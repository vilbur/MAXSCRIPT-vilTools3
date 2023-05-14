filein( getFilenamePath(getSourceFileName()) + "/../PrinterVolume.ms" )	-- "./../PrinterVolume.ms"



delete objects


PrinterVolume 	= PrinterVolume_v()

--PrinterVolume.createVolume(#box)(1)

-- PrinterVolume.createVolume(#Rectangle)(0.5)
PrinterVolume.createVolume(#Rectangle)(1)

--PrinterVolume.volumeDimensionObject(0.5)
-- PrinterVolume.volumeDimensionObject(1)