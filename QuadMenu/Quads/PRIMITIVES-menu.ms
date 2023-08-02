
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


function PRIMITIVESmenu QuadMenu =
(
	QuadMenu.setTitle(" Create")
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
		/* SUBMENU TITLE */	        /* NAME OF MENU */	             /* CATEGORY O MACROSCRIPTS */	/* MACROSCRIPT`S NAMES */
		"Standard Primitives",	(Menu_v("_Create Standard Primitives")	flat:true ).addItems("Objects Primitives")	(primitives[1]),
		"Shapes",	(Menu_v("_Shapes Primitives")	flat:true).addItems("Objects Shapes")	(shapes_primitives),
		"Helpers",	(Menu_v("_Helpers Primitives")	flat:true).addItems("Objects Helpers")	(helpers_primitives),
		"Other Primitives",	(Menu_v("_Create Other Primitives")	flat:false).addItems("Objects Primitives")	(primitives[2]),
		"Extend Primitives",	(Menu_v("_Create Extended Primitives")	flat:false).addItems("Objects Primitives")	(primitives[3]),
		"Compounds",	(Menu_v("_Compound Primitives")	flat:false).addItems("Objects Compounds")	(compound_primitives)
	)

	QuadMenu.addMenus(menus) separator:true

	QuadMenu.addItem ("Edit") ("Properties") group:"Main UI" index:1
	QuadMenu.addSeparator index:#(2)



)
