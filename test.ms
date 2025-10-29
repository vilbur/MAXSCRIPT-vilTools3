clearListener(); print("Cleared in:\n"+getSourceFileName())


/* Simple rollout with multi-list and execute on selected items
*/

global fnExecuteOnItems
global rlTestMultiList

function fnExecuteOnItems items array_param: = 
(
    for itm in items do
    (
        format "Execute callback on: %\n" itm
    )
)-- return


rollout rlTestMultiList "MultiList Exec"
(
    multiListBox lb_items items:#("Alpha","Bravo","Charlie","Delta","Echo") height:5
    button bt_exec "Execute" width:80
    
    on bt_exec pressed do (SelectionSetsManager_v()).deleteSet (for i in lb_items.selection collect lb_items.items[i])
)

createDialog rlTestMultiList width:200 height:170

--/* Test: add more items and trigger callback
--*/
--
--append rlTestMultiList.lb_items.items "Foxtrot"
--append rlTestMultiList.lb_items.items "Golf"
--rlTestMultiList.lb_items.setSelected #(2,5) true
--rlTestMultiList.bt_exec.pressed()
