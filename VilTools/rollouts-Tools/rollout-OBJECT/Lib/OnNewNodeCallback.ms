
global ON_NEW_NODE_DATA = Dictionary()

/** Node create callback
  *
  */
function onNewNodeCallback new_node =
(
	--format "\n"; print "NodeCreateCallback.ms.onNewNodeCallback()"
	global OnNewNodeCallbackInstance = OnNewNodeCallback_v(new_node)(ON_NEW_NODE_DATA)

	execute ( "OnNewNodeCallbackInstance.new"+ (classOf new_node) as string +"()" )

	OnNewNodeCallbackInstance = undefined

	ON_NEW_NODE_DATA = Dictionary()
)

/** On new node callback
 */
struct OnNewNodeCallback_v
(
	/* construct */

	/* properties */
	new_node,
	data,

	/* dependency */
	/* reference */
	/* inhered */

	/**
	  */
	function newLine =
	(
		format "\n"; print "OnNewNodeCallback_v.newLine()"
		format "new_node:	% \n" new_node
		format "data:	% \n" data
		--format "ON_NEW_NODE_DATA:	% \n" ON_NEW_NODE_DATA
		this.showProps()

		case data[#type] of
		(
			#line:	new_node.steps = 0

			default: new_node.steps = 6
		)
	),

	/**
	  */
	function newRectangle =
	(
		--format "\n"; print "OnNewNodeCallback_v.newLine()"

		new_node.steps = 0
	),
	/** Sho props
	  *
	  */
	function showProps =
	(
		--format "\n"; print "OnNewNodeCallback_v.shoProps()"
		for prop in getPropNames new_node do
			format "%:	%\n" prop (getProperty new_node prop)

	),

	private


	/**
	 */
	on create do
	(



	)
)
