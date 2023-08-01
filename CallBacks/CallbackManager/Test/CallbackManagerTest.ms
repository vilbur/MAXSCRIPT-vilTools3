clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../CallbackManager.ms" ) -- "./../CallbackManager.ms"\


/** Callback test
 */
function callBackFn =
(
	obj	= (callbacks.notificationParam())

	format "NODE CREATED	= % \n" obj.name
)

/** Callback test
 */
function nodeDeletedCallback =
(
	--format "\n"; print "CallbackManagerTest.ms.nodeDeletedCallback()"

	obj	= (callbacks.notificationParam())

	format "NODE PRE DELETE	= % \n" obj.name
)


/*------------------------------------------------------------------------------

	ADD CALLBACKS

--------------------------------------------------------------------------------*/

CallbackManager 	= CallbackManager_v()

CallbackManager.add #callBackFn	#nodeCreated
CallbackManager.add #callBackFn	#nodeCreated	id:#id_first
CallbackManager.add #callBackFn	#nodePreDelete	id:#id_second
CallbackManager.add #nodeDeletedCallback	#nodePreDelete	id:#id_deleted


/*------------------------------------------------------------------------------
	CREATE TEST OBJECTS
--------------------------------------------------------------------------------*/


delete objects
b = box()
delete b


/*------------------------------------------------------------------------------

	RUN ONLY ONE remove() TEST AT TIME

--------------------------------------------------------------------------------*/

/*------ GET BY ALL PARAMS ------*/
format "TEST ALL PARAMS: % \n"	(( CallbackManager.remove  callback:#callBackFn type:#nodeCreated id:#id_first).count	== 1)


/*------ GET BY MULTIPLE PARAMS ------*/
--format "TEST CALLBACK AND ID PARAMS: % \n"	((CallbackManager.remove callback:#callBackFn	id:#id_first).count	== 1)
--format "TEST CALLBACK AND TYPE PARAMS: % \n"	((CallbackManager.remove callback:#callBackFn	type:#nodeCreated).count	== 2)
--format "TEST TYPE AND ID PARAMS: % \n"	((CallbackManager.remove type:#nodeCreated	id:#id_first).count	== 1)


/*------ GET BY SINGLE PARAM ------*/
--format "TEST CALLBACK PARAM: % \n"	((CallbackManager.remove callback:#callBackFn).count	== 3)
--format "TEST TYPE PARAM: % \n"	((CallbackManager.remove type:#nodeCreated).count	== 2)
--format "TEST ID PARAM: % \n"	((CallbackManager.remove id:#id_first).count	== 1)


/*------------------------------------------------------------------------------

	ON DELETE CALLBACK

--------------------------------------------------------------------------------*/

--CallbackManager.add #nodeDeletedCallback	#nodePreDelete	id:#id_deleted


s = sphere()