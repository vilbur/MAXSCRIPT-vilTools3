macroscript vilTools3
category:	"_vilTools3"
buttontext:	"vT3"
toolTip:	"Open vilTools3\\n\\nSHIFT: REBUILD UI"
(
	global open_or_install = if keyboard.shiftPressed then #INSTALL else #OPEN

	filein @"$userscripts\MAXSCRIPT-vilTools3\vilTools3.ms"
)

macroscript vilTools3_install
category:	"_vilTools3"
buttontext:	"vT3 Install"
toolTip:	"Install vilTools3"
(
	global open_or_install = #INSTALL
		
	filein @"$userscripts\MAXSCRIPT-vilTools3\vilTools3.ms"
)

macroscript vilTools3_open
category:	"_vilTools3"
buttontext:	"vT3 Open"
toolTip:	"Open vilTools3"
(
	global open_or_install = #OPEN
		
	filein @"$userscripts\MAXSCRIPT-vilTools3\vilTools3.ms"
)