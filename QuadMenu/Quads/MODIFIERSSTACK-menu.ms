function MODIFIERSSTACKmenu QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K ")

	RemoteStackMenu	= Menu_v("_Modifiers-Remote")	-- "./../../VilTools/rollouts-Tools/rollout-MODIFIER-STACK/Remote_Stack.mcr"
	ModifierStackMenu	= Menu_v("_Modifier-Stack")	-- "./../../VilTools/rollouts-Tools/rollout-MODIFIER-STACK/ACTIVE_STACK.mcr"
	ManageModsMenu	= Menu_v("_Modifiers-Manage")	-- "./../../VilTools/rollouts-Tools/rollout-MODIFIER-STACK/MANAGE_MODIFIERS.mcr"

	RemoteStackMenu.addSeparators	#(  2 )
	ModifierStackMenu.addSeparators	#( 1, 2 )

	QuadMenu.addMenu(RemoteStackMenu)	--flat:false --index:1

	QuadMenu.addMenu(ModifierStackMenu)	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu(ManageModsMenu)	--flat:false --index:1
)
