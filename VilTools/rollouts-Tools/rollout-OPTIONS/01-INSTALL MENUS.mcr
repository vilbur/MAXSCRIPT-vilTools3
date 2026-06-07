

/** Instal menus
 */
function instalMenus_v mode =
(
	--format "\n"; print ".instalMenus()"

	/* IMPORT *.mcr files*/
	QUAD_MENU_MANAGER_GLOBAL.blacklist = #( "*\\bak*", "*-UNUSED*", "*rollout-OPTIONS\Menus.mcr" )
	
	QUAD_MENU_MANAGER_GLOBAL.quadDir ( @"c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2026 - 64bit\ENU\scripts\MAXSCRIPT-MenuBuilder\_Quad-Menus-Config" )

	/* CREATE QUAD MENUS */ 
	if mode == #ALL or mode == #MENUS then
		QUAD_MENU_MANAGER_GLOBAL.createMenus()
	
	/* CREATE QUAD MENUS */ 
	if mode == #ALL or mode == #QUADS then
		QUAD_MENU_MANAGER_GLOBAL.createQuadMenus()
	
	gc light:true --delayed:true

)

/**  INSTALL CUSTOM MENUS
 */
macroscript	_options_install_menus
category:	"_Options"
buttontext:	"MENUS"
tooltip:	"Install Menus and Quad menus for VilTools3"
icon:	"ACROSS:3|height:28|width:96"
(
	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2026 - 64bit\ENU\scripts\MAXSCRIPT-MenuBuilder\QuadMenuManager\QuadMenuManager.ms"
		if queryBox ("INSTALL MENUS ?") then
			instalMenus_v #MENUS
	)
)

/**  INSTALL CUSTOM QUADS
 */
macroscript	_options_install_quads
category:	"_Options"
buttontext:	"QUADS"
tooltip:	"Install Menus and Quad menus for VilTools3"
icon:	"ACROSS:3|height:28"
(
	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2026 - 64bit\ENU\scripts\MAXSCRIPT-MenuBuilder\QuadMenuManager\QuadMenuManager.ms"
		if queryBox ("INSTALL QUAD MENUS ?") then
			instalMenus_v #QUADS
	)
)

/**  INSTALL CUSTOM QUADS
 */
macroscript	_options_install_menus_and_quads
category:	"_Options"
buttontext:	"MENUS & QUADS"
tooltip:	"Install Menus and Quad menus for VilTools3"
icon:	"ACROSS:3|height:28"
(
	on execute do
	(
		if queryBox ("INSTALL MENUS & QUAD MENUS ?") then
			instalMenus_v #ALL
	)
)
