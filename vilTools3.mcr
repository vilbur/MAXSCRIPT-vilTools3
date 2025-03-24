macroscript vilTools3_open
category:	"_vilTools3"
buttontext:	"vT3"
toolTip:	"Open vilTools3"
(
-- 	filein @"$userscripts\vilTools3\vilTools3-import-scripts.ms"
	--filein @"$userscripts\vilTools3\includes.ms"
	
	if DIALOG_viltools != undefined and not keyboard.controlPressed then 
		VILTOOLS.create()

	else
		filein @"$userscripts\MAXSCRIPT-vilTools3\vilTools3.ms"
	
)