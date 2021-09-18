/**  
 *	
 */
macroscript	main_ui_coord_system_circle
category:	"_Main"
buttontext:	"Coord system"
toolTip:	"Coord system circle world|local"
--icon:	"#(path, index)"
(
	cordSys = getRefCoordSys() 		
	
	if viewport.IsPerspView()  then
	(
		if cordSys != #world then
			tMode =  #world
		else
			tMode =  #local
	)
	else
	(
		if cordSys == #hybrid then -- #hybrid = view
			tMode =  #local
			
		--else if cordSys == #local then
			--tMode =  #screen
		else
			tMode =  #view
	)
	
	toolMode.coordsys tMode
	
	--wText "" "" "" (toUpper (tMode as string))	
	
)
 