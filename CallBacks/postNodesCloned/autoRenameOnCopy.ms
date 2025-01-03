

global CLONED_NODES_TIMER
global CLONED_NODES

/** Timer callback
 */
function renameNodesTimerCallback =
(
	format "\n"; print "renameNodesTimerCallback()"
	--format "renameNodesTimerCallback	= % \n" counter
	format "CLONED_NODES.count: %\n" CLONED_NODES.count
	--counter += 1
	--
	--if counter == 10 then 
		CLONED_NODES_TIMER.stop()
		
	CLONED_NODES = undefined
	
	CLONED_NODES_TIMER = undefined
)




/** 
 */
function autoRenameOnCopy =
(
	--format "\n\n";	print "autoRenameOnCopy()"
	--format "CLONED_NODES: %\n" CLONED_NODES
	
	if CLONED_NODES_TIMER == undefined then
	(
		CLONED_NODES_TIMER	= dotNetObject "System.Windows.Forms.Timer"

		
		dotNet.addEventHandler CLONED_NODES_TIMER "tick" renameNodesTimerCallback
		
		CLONED_NODES_TIMER.interval = 500
	)
	else
		CLONED_NODES_TIMER.stop()

	
	nodes_old	= (callbacks.notificationParam())[1]
	nodes_new	= (callbacks.notificationParam())[2]	
	
	if CLONED_NODES == undefined then
		CLONED_NODES = deepCopy nodes_old

	
	
	
	--CLONED_NODES = CLONED_NODES + nodes_new
	
	join CLONED_NODES nodes_new
	
	
	CLONED_NODES_TIMER.start()
)



