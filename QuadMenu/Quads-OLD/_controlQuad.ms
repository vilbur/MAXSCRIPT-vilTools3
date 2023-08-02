/*
   DOCUMENTATION: "./readme.md"
*/

global MainQuad = QuadMenu_v("_" + (getFilenameFile(getSourceFileName())))

/*==============================================================================

	QUAD 1 - BOTTOM - RIGHT

================================================================================*/
function editQuad1 QuadMenu =
(
	QuadMenu.setTitle(" Snap           ")

	SnapQuadMenu 	= QuadMenu_v("Snap")

	SnapQuadMenu.Quads[1]

	SnapQuadMenu.Quads[1].moveItem ("Pivot") 4


	snap_menus = #(
		"Snaps",	 SnapQuadMenu.Quads[1],
		"Snap Options",	 SnapQuadMenu.Quads[3]
	)

	QuadMenu.addMenus( snap_menus )	--flat:true --index:1

)

/*==============================================================================

	QUAD 2 - TOP - RIGHT

================================================================================*/

/** Craete HoneycombPlane plugin object
 *
 */
macroscript	HoneycombPlane
category:	"Objects Primitives"
buttontext:	"Honeycomb"
toolTip:	"Create Honeycomb Plane"
--icon:	"Menu:Tooltip"
--icon:	"Tooltip:" --"#(path, index)"
(
	on execute do startObjectCreation HoneycombPlane
)


function editQuad2 QuadMenu =
(
	QuadMenu.setTitle("Create            ")
	--
	--standard_primitives_plugin = #(
	--	#hexasphere,
	--	#quadsphere
	--)

	primitives = #(
		#(
			#Plane,
			#Box,
			#Cylinder,
			#Sphere,
			#Teapot,
			#HoneycombPlane

		),
		#(
			#hexasphere,
			#quadsphere,
			#GeoSphere,
			#ChamferBox,
			#Tube,
			#Torus,
			#Cone,
			#Pyramid,
			#TextPlus
		),
		#(
			#C_Ext,
			#Capsule,
			#ChamferCyl,
			#Gengon,
			#Hedra,
			#Hose,
			#L_Ext,
			#OilTank,
			#Prism,
			#Quadpatch,
			#RingWave,
			#Spindle,
			#Torus_Knot,
			#Tripatch
		)
	)


	compound_primitives = #(
		#Loft,
		#Boolean,
		#ProBoolean,
		#Procutter,
		#Scatter,
		#ShapeMerge
	)

	helpers_primitives = #(
		#point,
		#tape,
		#protractor
	)

	shapes_primitives = #(
		#lines,
		#rectangle,
		#Text,
		#circle,
		#Ellipse,
		#ShapeMerge
	)

	menus = #(

		"Standard Primitives",	(Menu_v("_Create Standard Primitives")	flat:true ).addItems("Objects Primitives")(primitives[1]),
		"Shapes",	 (Menu_v("_Shapes Primitives")	flat:true).addItems("Objects Shapes")(shapes_primitives),
		"Helpers",	 (Menu_v("_Helpers Primitives")	flat:true).addItems("Objects Helpers")(helpers_primitives),
		"Other Primitives",	(Menu_v("_Create Other Primitives")	flat:false).addItems("Objects Primitives")(primitives[2]),
		"Extend Primitives",	(Menu_v("_Create Extended Primitives")	flat:false).addItems("Objects Primitives")(primitives[3]),
		"Compounds",	 (Menu_v("_Compound Primitives")	flat:false).addItems("Objects Compounds")(compound_primitives)
	)

	QuadMenu.addMenus(menus) separator:true

)

/*==============================================================================

	QUAD 3 - TOP - LEFT

================================================================================*/
function editQuad3 QuadMenu =
(
	--format "\n"; print "controlQuad.editQuad3()"
	QuadMenu.setTitle("               Pivot")


	QuadMenu.addMenu("_Pivot")	--flat:true --index:1

	--QuadMenu.addItem ("Category") ("macroscript_nmae") index:1


)

/*==============================================================================

	QUAD 4 - BOTTOM - LEFT

================================================================================*/
function editQuad4 QuadMenu =
(
	QuadMenu.setTitle("Transform            ")

	--DefaulQuadMenu 	= (QuadMenuv("Title")).Quads[1]

	--QuadMenu.addSeparator()

	--QuadMenu.addMenu("MenuName")	--flat:true --index:1
	--QuadMenu.addMenu(DefaulQuadMenu.menu)	--flat:true --index:1
	--QuadMenu.addItem ("Category") ("macroscript_nmae") index:1

)


/*==============================================================================

	RUN EDIT FUNCTIONS

================================================================================*/


editQuad1(MainQuad.Quads[1])
editQuad2(MainQuad.Quads[2])
editQuad3(MainQuad.Quads[3])
editQuad4(MainQuad.Quads[4])


/* Set options */
MainQuad.setRightClick which:#controlPressed  --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed

--MainQuad.showAllQuads()

MainQuad = undefined