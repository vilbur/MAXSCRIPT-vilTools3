/**
  *
  */
function MODIFIERSCOMMONmenu QuadMenu =
(
	QuadMenu.setTitle("COMMON")


	modifiers = #(
		#(
			#EditPolyMod,
			#PolySelect,
			#Volumeselect

		),

		#(
			#FFDBox,
			#FFD_2x2x2
		),

		#(
			#MeshSmooth,
			#Symmetry,
			#VertexWeld,
			#DeleteMesh
		),

		#(
			#Smooth,
			#Material_ID,
			#Normalmodifier
		),
		#(
			#Shell,
			#Face_Extrude	-- 3Ds Max native mdifier
		),
		#(
			#Edit_Spline,
			#Extrude,
			#Normalize_Spline
		)
	)

	CommonModifiersMenu = Menu_v("_Modifiers-Common") flat:true


	--menus = #(
	--	/* SUBMENU TITLE */	        /* NAME OF MENU */	     /* CATEGORY O MACROSCRIPTS */	/* MACROSCRIPT`S NAMES */
	--	"Modify-Object-Common",	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[1]),
	--	--"Poly-Select-Common",	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[2]),
	--	--"Poly-Surface-Common",	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[3]),
	--	--"Poly-Modify-Common",	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[4]),
	--	--"FFD-Common",	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[5]),
	--	--"Deform-Object-Common",	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[6]),
	--	"Shape Modifiers-Common",	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[6])
	--)


	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[1])
	CommonModifiersMenu.addSeparator()

	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[2])
	CommonModifiersMenu.addSeparator()

	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[3])
	CommonModifiersMenu.addSeparator()

	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[4])
	CommonModifiersMenu.addSeparator()


	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[5])
	CommonModifiersMenu.addSeparator()


	(CommonModifiersMenu).addItems("Modifiers")	(modifiers[6])


	--ModifiersMenu.addItem "Modifiers" "Bend"
	--ModifierStackMenu	= Menu_v("_Modifier Stack")


	--QuadMenu.addMenu(ModifierStackMenu)	--flat:false --index:1


	QuadMenu.addMenu(CommonModifiersMenu)


	--QuadMenu.addMenu (ModifiersMenu)	--flat:false --index:1
)
