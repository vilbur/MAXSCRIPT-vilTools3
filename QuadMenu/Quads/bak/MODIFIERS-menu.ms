function MODIFIERSmenu QuadMenu =
(
	QuadMenu.setTitle(" M O D I F I E R S")


	--ModifiersMenu	= Menu_v("_Modifiers")

	modifiers = #(
		#(
			#EditPolyMod,
			#PolySelect,
			#Volumeselect,
			#Slice

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
			#Face_Extrude,	-- 3Ds Max native mdifier
			#Extrude_faces_poly,	-- Plugin modifier
			#Extrude_edges_poly,	-- Plugin modifier
			#Inset_faces,	-- Plugin modifier
			#Outline_faces_poly	-- Plugin modifier
		),
		#(
			#Edit_Spline,
			#Normalize_Spline
		),


		#(
			#select_by_face_size,	-- Plugin modifier
			#Select_faces_by_mat_id	-- Plugin modifier
		),

		#(
		),

		#(
			#Bend,
			#Taper,
			#PathDeform,
			#Twist,
			#Noise
		),
		#(
			#Edit_Spline,
			#Normalize_Spline
			#Lathe,
			#Extrude,
			#Bevel,
			--#OptimizeSplineMod,
		)
	)

	menus = #(
		/* SUBMENU TITLE */	        /* NAME OF MENU */	     /* CATEGORY O MACROSCRIPTS */	/* MACROSCRIPT`S NAMES */
		"Modify-Object",	(Menu_v("_Modify-Object")	flat:false ).addItems("Modifiers")	(modifiers[1]),
		"Poly-Select",	(Menu_v("_Modifiers-Poly-Select")	flat:false ).addItems("Modifiers")	(modifiers[2]),
		"Poly-Surface",	(Menu_v("_Modifiers-Poly-Surface")	flat:false ).addItems("Modifiers")	(modifiers[3]),
		"Poly-Modify",	(Menu_v("_Modifiers-Poly-Modify")	flat:false ).addItems("Modifiers")	(modifiers[4]),
		"FFD",	(Menu_v("_Modifiers-FFD")	flat:false ).addItems("Modifiers")	(modifiers[5]),
		"Deform-Object",	(Menu_v("_Modifiers-Deform-Object")	flat:false ).addItems("Modifiers")	(modifiers[6]),
		"Shape Modifiers",	(Menu_v("_Modifiers-Spline")	flat:false ).addItems("Modifiers")	(modifiers[7])
	)




	--ModifiersMenu.addItem "Modifiers" "Bend"
	--ModifierStackMenu	= Menu_v("_Modifier Stack")

	--LayersVisibilityMenu.addSeparator index:#( 5, 3 )

	--QuadMenu.addMenu(ModifierStackMenu)	--flat:false --index:1


	QuadMenu.addMenus(menus) separator:true


	--QuadMenu.addMenu (ModifiersMenu)	--flat:false --index:1
)
