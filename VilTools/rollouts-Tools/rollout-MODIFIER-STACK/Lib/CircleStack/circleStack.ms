/** Go through stack, select or deselect items in stack
  *
  *
  * @apram #ADD|#ADD_ALL|#REMOVE|#GO add to selcction, remove from selection or go through stack
  */
function circleStack direction mode:#GO which:#ENABLED =
(
	----format "\n"; print "CircleStack_v.circleStack()"
	--format "DIRECTION:	% \n" direction
	--format "MODE:	% \n" mode
	--format "WHICH:	% \n" which

	StackRemote 	= ModifierStackRemote_v()

	items_count = StackRemote.itemsCount()

	selected_items = StackRemote.ListBox.getSlectedItems()

	if selected_items.count > 0 then
	(
		--format "ITEMS_COUNT:	% \n" items_count
		--format "SELECTED_ITEMS:	% \n" selected_items

		change_index = if direction == #DOWN then selected_items[selected_items.count] else selected_items[1]

		go_increment = if mode == #GO and selected_items.count == 1 then 1 else 0 -- go to next if only one item selected, otherwise go to first|last item in selection

		if mode == #GO and which == #ENABLED then
			mode = #GO_ENABLED

		if mode == #ADD then
			add_selection = join (deepCopy selected_items) #( change_index + ( if direction == #UP then -1 else 1 ) )

		new_selection = case mode of
		(
			#ADD:
				if selected_items.count < items_count then
					case direction of
					(
						#UP:	if change_index > 1           then add_selection
						#DOWN:	if change_index < items_count then add_selection
					)
			#ADD_ALL:
				if selected_items.count < items_count then
					case direction of
					(
						#UP:	join (deepCopy selected_items) ( for i = 1 to change_index collect i )
						#DOWN:	join (deepCopy selected_items) ( for i = change_index to items_count collect i )
					)

			#REMOVE:
				deleteItem (deepCopy selected_items) (findItem selected_items change_index )

			#GO:
				case expr of
				(
					/* SELECT FIRST IF LAST ITEM IS SELCTED */
					( selected_items.count == 1 and  direction == #DOWN and change_index == items_count ):	#(1)

					/* SELECT LAST IF FIRST ITEM IS SELCTED */
					( selected_items.count == 1 and direction == #UP  and change_index == 1 ):	#(items_count)

					/* CHANGE INDEX */
					default: if direction == #DOWN then #( change_index + go_increment ) else #( change_index - go_increment )
				)

			#GO_ENABLED:
			(
				next_enabled_mod = StackRemote.findEnabledModifierIndex(change_index)(direction)

				if next_enabled_mod == undefined then
					next_enabled_mod = if direction == #DOWN then items_count else 1

				if next_enabled_mod != undefined then
					#( next_enabled_mod )
			)
		)

		if new_selection != undefined then
			sort new_selection

		--format "NEW_SELECTION:	% \n" new_selection
		--format "SELECTED_ITEMS:	% \n" selected_items
		--format "selected_items != new_selection:	% \n" (selected_items != new_selection)

		if new_selection != undefined and ( new_selection.count > 0 and selected_items != new_selection ) then -- IF SELECTION HAS BEEN CHANGED
			StackRemote.selectItem new_selection true clear:true
	)
)
