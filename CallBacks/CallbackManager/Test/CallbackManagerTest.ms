clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../CallbackManager.ms" ) -- "./../CallbackManager.ms"\


/** Callback test
 */
function callbackTest =
(
	--format "\n"; print "CallbackManagerTest.ms.callbackTest()"
	format "\n"; print "CallbackManagerTest.ms.CALLBACKTEST()"

	obj	= (callbacks.notificationParam())[1]
	_modifier	= (callbacks.notificationParam())[2]

	format "CALLBACK CREATED	= % \n" obj.name

)





CallbackManager 	= CallbackManager_v()



--CallbackManager.add "callbackTest()" #nodeCreated
CallbackManager.add #callbackTest #nodeCreated id:#callback_test_on_node_created


delete objects
b = box()


CallbackManager.remove #callbackTest id:#callback_test_on_node_created


s = sphere()