/** Circle stack

  * @apram #ADD|#REMOVE|#GO add to selcction, remove from selection or go through stack
  */
function circleStack direction mode:#GO which:#ENABLED =
(
	--format "\n"; print "CircleStack_v.circleStack()"
	CommandPanel 	= CommandPanel_v()

	items_count = CommandPanel.itemsCount()

	selected_items = CommandPanel.getSlectedItems()

	if selected_items.count > 0 then
	(
		format "MODE:	% \n" mode
		format "ITEMS_COUNT:	% \n" items_count
		format "SELECTED_ITEMS:	% \n" selected_items

		change_index = if direction == #DOWN then selected_items[selected_items.count] else selected_items[1]

		format "DIRECTION:	% \n" direction
		format "CHANGE_INDEX:	% \n" change_index

		new_selection = case mode of
		(
			#ADD:
				case direction of
				(
					#UP:	if change_index > 1	        then join selected_items #( change_index - 1 ) else selected_items
					#DOWN:	if change_index < items_count	then join selected_items #( change_index + 1 ) else selected_items
				)

			#REMOVE:
				deleteItem selected_items (findItem selected_items change_index )

			#GO:
				case expr of
				(
					/* SELECT FIRST IF LAST ITEM IS SELCTED */
					( change_index == items_count and direction == #DOWN ):	#(1)

					/* SELECT LAST IF FIRST ITEM IS SELCTED */
					( change_index == 1 and direction == #UP ):	#(items_count)

					/* CHANGE INDEX */
					default: if direction == #DOWN then #( change_index + 1 )  else #( change_index - 1 )
				)
		)

		format "NEW_SELECTION:	% \n" new_selection

		if new_selection.count > 0 or selected_items != new_selection  then
			CommandPanel.selectItem true new_selection clear:true

	)

)
