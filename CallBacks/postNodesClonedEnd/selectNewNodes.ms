/** Select new nodes
 */
function selectNewNodes cloned_nodes clone_type  =
(
	--format "\n"; print ".selectNewNodes()"
	
	/* FLATTERN CLONED_NODES MATRIX */ 
	cloned_nodes_all = #()
	
	for i = 2 to CLONED_NODES.count do join cloned_nodes_all CLONED_NODES[i]
	
	select cloned_nodes_all
)
