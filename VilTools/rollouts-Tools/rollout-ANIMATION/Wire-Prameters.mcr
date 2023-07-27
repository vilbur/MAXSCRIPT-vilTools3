

global WIRE_PARAMS_LABELS = undefined


/** Wire params dialog
 */
function wireParamsDialog obj_1 obj_2 =
(
		WIRE_PARAMS_LABELS = #(obj_1, #(), obj_2,#()) -- obj1, obj2, obj1_params, obj2_params

		/* DIALOG */
		dialog_id = "dialog_wire_params"

		Dialog 	    = Dialog_v title:("Wire Params") id:dialog_id --ini:(getSourceFileName() + "/../save-modifier-property.ini")

		_Controls	= Dialog.Controls()
		_Controls_props	= Dialog.Controls group:"Properties saved in preset"
		_Controls_connect	= Dialog.Controls()

		--CheckAllCheckbox = _Controls.control #checkbox "Check\Uncheck all" across:1
		--
		--CheckAllCheckbox.Events.add #changed ("for control in "+dialog_id+".controls do try( control.state = val )catch()")
		WIRE_PARAMS_LABELS[1] = obj_1
		WIRE_PARAMS_LABELS[2] = obj_2

		WIRE_PARAMS_LABELS[3] = ( getPropNames obj_1.baseobject)
		WIRE_PARAMS_LABELS[4] = ( getPropNames obj_2.baseobject)

		Radio_1 = _Controls_props.control #radiobuttons obj_1.name items:WIRE_PARAMS_LABELS[3] columns:1 offset:[16,16] across:2
		Radio_2 = _Controls_props.control #radiobuttons obj_2.name items:WIRE_PARAMS_LABELS[4] columns:1 offset:[16,16] across:2

		ButtonConnect =  _Controls_connect.control #button "Connect" width:128 height:64 across:1

		ButtonConnect.Events.add #pressed ("wireParamsCallback ( "+Radio_1.id+".state ) ( "+Radio_2.id+".state ) title:\"WIRE PARAMETERS \"")

		/* DIALOG CREATE */
		Dialog.create width:512 --pos:#mouse
)

/** Wire params callback
 */
function wireParamsCallback state_1 state_2 =
(
	--format "\n"; print ".wireParamsCallback()"

	--messageBox WIRE_PARAMS_LABELS[1][state_1]
	--messageBox WIRE_PARAMS_LABELS[2][state_2]

	if state_1 != undefined and state_1 != undefined then
	(
		obj_1 = getNodeByName (WIRE_PARAMS_LABELS[1].name)
		obj_2 = getNodeByName (WIRE_PARAMS_LABELS[2].name)
		--obj_2 = WIRE_PARAMS_LABELS[2]

		param_1 = WIRE_PARAMS_LABELS[3][state_1]
		param_2 = WIRE_PARAMS_LABELS[4][state_2]

		format "param_1	= % \n" param_1
		format "param_2	= % \n" param_2
		format "classOf param_1	= % \n" (classOf param_1)
		format "classOf param_2	= % \n" (classOf param_2)

		--global WIRE_PARAMS_LABELS = undefined


		try(
			--paramWire.connect2way obj_1.baseObject[param_1] obj_2.baseObject[param_2] "Height" "Height"

			/*
				THIS NEED MORE LABOR THEN HAS BEEN EXPECTED



			*/
			paramWire.connect2way obj_1.baseObject[param_1] obj_2.baseObject[param_2] "Height_Segments" "Height_Segments"









		)catch(
			format "!!!!! ERROR IN TRY %\n\n" (getCurrentException())
		)



	)

)

/**
 *
 */
macroscript	_animation_wire_params
category:	"_Animation"
buttontext:	"Wire Params"
toolTip:	""
--icon:	"#(path, index)"
(

	-- wireConnect -	By Michael B. Comet - comet@comet-cartoons.com
	-- 				http://www.comet-cartoons.com/
	--
	-- Version 1.00 - comet@comet-cartoons.com - 04/14/02
	--
	-- Version 1.01	- comet@comet-cartoons.com - 04/18/02
	--		Initial Public Release.  This version should show values
	--			for controllers, as well as show SCRIPT controller Expressions
	--			for the master object, and of course do Wiring.
	--		Basic wiring, range editing and expression editing works for
	--			both the script controllers and wire controllers.
	--		Note you do have to "tab" key out of the script edit box or click
	--			somewhere else to get it to "accept" any script changes.
	--		Use the CTRL key when clicking in the slave list to add or remove
	--			just one item/wire at a time.
	--
	-- Version 1.02	- comet@comet-cartoons.com - 04/21/02
	--		Fixed bug where immediate wire wouldn't re-show child if the master
	--		controller didn't originally have a controller assigned by default
	--		yet.
	--


	global wireCVersion = "1.02";


	-- --------------------------------------------------------------------------
	--			Basic String Procs
	-- --------------------------------------------------------------------------
	fn toupper instring =
	(
		local upper, lower, outstring       -- declare variables as local

		upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"  -- set variables to literals
		lower="abcdefghijklmnopqrstuvwxyz"

	--
	-- create an unique copy of the string referenced by instring, and store
	-- reference to unique copy in outstring
		outstring=copy instring;

	--
	-- increment from 1 to number of character in string
		for i in 1 to outstring.count do
		(
			--
			-- see if the single character at index i in outstring is present in string lower
			-- If so, j equals position in string lower. If not, j equals undefined
			j = findString lower outstring[i];

			--
			-- if character was found in lower, replace with corresponding character in upper
			if (j != undefined) do
				outstring[i] = upper[j];
	   )

	   return outstring;
	)


	-- --------------------------------------------------------------------------

	fn tolower instring =
	(
		local upper, lower, outstring       -- declare variables as local

		upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"  -- set variables to literals
		lower="abcdefghijklmnopqrstuvwxyz"

	--
	-- create an unique copy of the string referenced by instring, and store
	-- reference to unique copy in outstring
		outstring=copy instring;

	--
	-- increment from 1 to number of character in string
		for i in 1 to outstring.count do
		(
			--
			-- see if the single character at index i in outstring is present in string lower
			-- If so, j equals position in string lower. If not, j equals undefined
			j = findString upper outstring[i];

			--
			-- if character was found in lower, replace with corresponding character in upper
			if (j != undefined) do
				outstring[i] = lower[j];
	   )

	   return outstring;
	)



	-- --------------------------------------------------------------------------

	/*
	 * getDimension() - Given a classType determines how many sub parts it has
	 *		which is useful for figuring out if things can be wired together or
	 *		or not.
	 */
	fn getDimension classType =
	(
		if (classType == Quat) then
			return 4;
		else if (classType == Point3 or classType == Color) then
			return 3;
		else if (classType == Float or classType == Integer or
				classType == BooleanClass) then
			return 1;
		else
			return 0;
	)

	-- --------------------------------------------------------------------------

	/*
	 * canWire() - Returns 1 if we can wire, 0 if not.  Needs 2 classes
	 */
	fn canWire left right =
	(
		lD = getDimension left;
		rD = getDimension right;

		if (lD == rD) then
			return true;
		else
			return false;
	)
	-- --------------------------------------------------------------------------



	struct wireCData
	(
	--		object, ->   name, sA, parent, Controller  parentObj parentCont
		obj, cnt=0, names=#(), sAs=#(), sAPs=#(), conts=#(), contsM=#(), classes=#(),
		indentStr = "      ",

		fn addSubAnim sub par name indent var =
		(
				-- Check in case there are regular subAnims...
			if sub.numSubs > 0 then
				(
				ind = "";
				for i = 1 to indent do
					ind += indentStr;
	--			format ">> %% <<\n" ind name;

				cnt+=1;
				names[cnt] = (toupper (ind+"( "+name+" )") );
				sAs[cnt] = sub;
				sAPs[cnt] = par;
				conts[cnt] = undefined;
				contsM[cnt] = undefined;
				classes[cnt] = undefined;

				for i = 1 to sub.numSubs do
					(
					sName = getSubAnimName sub i as string;
					var.addSubAnim sub[i] sub sName (indent+1) var;			-- recurse
					)
				)
			else	-- leaf node!
				(
				ind = "";
				for i = 1 to indent do
					ind += indentStr;
	--			format "%% " ind name;

				cont = sub.controller;
	--			format "cont= % " cont;

	--			format "val= % " sub.value;
	--			format "classOf val = % " (classOf sub.value);
	--			format "\n";


				-- Only add if cont was not already in list
				--	Or if it is an undefined controller, which many may be since not yet assigned,
				--	make sure it has a class, and is not an empty group node.
				--
				--	This way duplicate controllers aren't listed...so disconnect doesn't break.
				--	And also it is cleaner with ( BLOCKS ) that don't have children not being
				--	displayed.
				--
				if (findItem conts cont == 0 or
					(cont == undefined and classOf sub.value != UndefinedClass)
						) then
					(
					cnt+=1;
					if (sub.value == undefined) then	-- see if it's just a master node with no childern....
						names[cnt] = (toupper (ind+"( "+name+" )"));
					else
						names[cnt] = (tolower (ind+name));
					sAs[cnt] = sub;
					sAPs[cnt] = par;
					conts[cnt] = sub.controller;
					contsM[cnt] = undefined;
					classes[cnt] = (classOf sub.value);


					if (classOf cont == Float_Wire or classOf cont == Position_Wire or
							classOf cont == Rotation_Wire or classOf cont == Scale_Wire or
							classOf cont == Point3_Wire)then
						(
						local wpar = cont.getWireParent 1;
						pO = (refs.dependents wpar)[1];   -- hack
						pN = getSubAnimName wpar (cont.getWireSubNum 1);

						sM = wpar[pN];
						contsM[cnt] = sM.controller;
		--				format "**** wire,  owner=% name=% sM=% cM=% is master\n" pO pN sM contsM[cnt];

						)
					)

				)

				-- Also if there are CA's go through those as well
			try
				(
					-- see if this subAnim or Obj has a Custom_Attributes definition.
				caCnt = custAttributes.count sub;

				for i = 1 to caCnt do
					(
					ca = custAttributes.get sub i;		-- go thru each attribute def for this node

					ind = "";
					for d = 1 to indent do
						ind += indentStr;
					caDef = custAttributes.getDef sub i;
					theName = caDef.name as string;
	--				format ">> %%: % <<\n" ind name theName;

					cnt+=1;
					names[cnt] = (toupper (ind+"( "+name+": "+theName+" )"));
					sAs[cnt] = ca;
					sAPs[cnt] = sub;
					conts[cnt] = undefined;
					contsM[cnt] = undefined;
					classes[cnt] = undefined;


					if (ca.numSubs > 0) then			-- if there are subs, work thru those too!
						(
						for j = 1 to ca.numSubs do
							(
							sName = getSubAnimName ca j as string;
							var.addSubAnim ca[j] sub sName (indent+1) var;		-- recurse on  CA's
							)
						)
					)
				)
			catch
				(
				)



		),

		fn buildList var:undefined objnew: =
		(
			if (objnew != unsupplied) then
				obj = objnew;

			if (obj == undefined) then
				(
				format "-- ERROR: Cannot buildList, obj is undefined!\n";
				return();
				)

			if (var == undefined) then
				(
				format "-- ERROR: Cannot buildList, var is undefined!\n";
				return();
				)

			format "-- buildList: Building data for: %\n" obj.name;
				-- Clear out all basic arrays first.
			cnt = 0;
			names =	#();
			sAs	=	#();
			sAPs =	#();
			conts = #();
			contsM = #();
			classes = #();

			addSubAnim obj undefined obj.name 0 var;	-- Start recurse on data builder proc


		)

	) -- end of wireCData


	-- --------------------------------------------------------------------------

	fn removeLeadingWS str =
	(
		newstr = "";

		for i in 1 to str.count do
		(
			if (str[i] != " ") then		-- once we hit non ws stuff just return the rest
				(
				newstr += substring str i -1;	-- tack on rest of it
				return newstr;		-- and return
				)
		)

		return newstr;
	)


	-- --------------------------------------------------------------------------
	--		ROLLOUTS
	-- --------------------------------------------------------------------------

	global wcDlg;

	global wireCDialog;
	global wireCControlRoll;
	global buildExpList;

	global wcMasterData, wcSlaveData;

	wcMasterData = wireCData();
	wcSlaveData = wireCData();

	/*
	rollout wireCDialog "Comet - Wire Connect"
	(
		SubRollout wireCSubRoll "" width:580 height:510;

		on wireCDialog resized size do
		(
			wireCSubRoll.width = size.x - 18;
			wireCSubRoll.height = size.y - 18;
		)

	)
	*/


	rollout wireCControlRoll "Wiring"
	(
		pickbutton pb_master "Pick Master Object" width:250 toolTip:"Choose Master Object" across:2;
		pickbutton pb_slave "Pick Slave" width:250 toolTip:"Choose Slave Object";

		listbox lb_master items:#() height:20 across:2;
		multilistbox mlb_slave items:#() enabled:false height:20;

		dropdownlist ddl_script items:#() enabled:false width:250 offset:[1,0] across:3;
		spinner spn_from "Wire Time Range FROM:" enabled:false type:#integer range:[-1000,10000,-1000] fieldWidth:50 offset:[90,2];
		spinner spn_to "TO:" type:#integer enabled:false range:[-1000,10000, 10000] fieldWidth:50 offset:[0,2];

		edittext et_script text:"" height:126 offset:[-2,0];

		on pb_master picked obj do
		(
			pb_master.text = "MASTER: "+obj.name;
			wcDlg.master = obj;

			wcMasterData.buildList var:wcMasterData objnew:(wcDlg.master);

			lb_master.items = wcMasterData.names;

			lb_master.selection = 0;	-- And clear selection....on other side.
			mlb_slave.selection = #();
			wcDlg.selMaster = 0;
			wcDlg.selSlave = #();

			buildExpList();
		)

		on pb_slave picked obj do
		(
			pb_slave.text = "SLAVE: "+obj.name;
			wcDlg.slave = obj;

			wcSlaveData.buildList var:wcSlaveData objnew:(wcDlg.slave);

			mlb_slave.items = wcSlaveData.names;
			mlb_slave.selection = #();
			lb_master.selection = 0;	-- And clear selection....on other side.
			wcDlg.selSlave = #();
			wcDlg.selMaster = 0;

			buildExpList();
		)

		on ddl_script selected item do
		(
			if (item == 1) then 	-- Either a *Value* or *Expr* if master is expr cont.
				(
				mi = wcDlg.selMaster;
				cont = wcMasterData.conts[mi];
				contC = classOf cont;
				if (contC == Float_Script or contC == Point3_Script or
					contC == Position_Script or contC == Rotation_Script or
					contC == Scale_Script) then
					(
					expr = cont.script;
					range = getTimeRange cont;
					fixedexpr = "";		-- now do this to fix edit text \n vs \r\n bug
					pc = "";
					for c in 1 to expr.count do
						(
						if expr[c] == "\n" and pc != "\r" then
							fixedexpr += "\r";
						fixedexpr += expr[c];
						pc = expr[c];
						)
					et_script.text = (fixedexpr);
					et_script.enabled = true;
					spn_from.enabled = true;
					spn_to.enabled = true;
					spn_from.value = range.start;
					spn_to.value = range.end;
					)
				else
					(
					expr = (wcMasterData.sAs[mi].value as string);
					range = (interval -1000 10000)
					et_script.text = (expr);
					et_script.enabled = false;
					spn_from.enabled = false;
					spn_to.enabled = false;
					spn_from.value = range.start;
					spn_to.value = range.end;
					)
				)
			else if (item == 2) then	-- *New* entry
				(
				mi = wcDlg.selMaster;
				et_script.text = (removeLeadingWS wcMasterData.names[mi]+";");
				et_script.enabled = true;
				spn_from.value = -1000;
				spn_to.value = 10000;
				spn_from.enabled = true;
				spn_to.enabled = true;
				)
			else	-- otherwise it's the data from a previous wire
				(
					-- get the index into the array from the slave list
					-- We do a -1 since for us 1 is "*new*" and then 2 is really #1....
					--
				idx = wcDlg.selSlave[(item-2)];

				cont = wcSlaveData.conts[idx];	-- get controller
				expr = cont.getExprText 1;		-- and GET the expression
				range = getTimeRange cont;		-- and Range

				et_script.text = (expr);
				et_script.enabled = true;
				spn_from.value = range.start;
				spn_to.value = range.end;
				spn_from.enabled = true;
				spn_to.enabled = true;
				)
		)


		on et_script entered expr do
		(
			item = ddl_script.selection;	-- which item are we editing?

			if (item == 1) then		-- See if it is a Script Controller
				(
				mi = wcDlg.selMaster;
				cont = wcMasterData.conts[mi];
				contC = classOf cont;
				if (contC == Float_Script or contC == Point3_Script or
					contC == Position_Script or contC == Rotation_Script or
					contC == Scale_Script) then
					(
					if (expr != "") then
						(
						cont.script = expr;
						format "-- Updated SCRIPT expression for %.%\n" wcDlg.master.name (removeLeadingWS wcMasterData.names[mi]);
						)
					)
				else
					(

					)
				)
			else if (item == 2) then	  -- if it is item "*new*" then don't have to do anything
				(

				)
			else
				(
				if (expr != "" and expr != undefined) then
					(
					idx = wcDlg.selSlave[(item-2)];

					cont = wcSlaveData.conts[idx];	-- get controller
					cont.setExprText 1 expr;		-- and SET the expression

						-- Now set val which will cause the stuff to update without having
						--	to "wiggle" anything in most cases.  This won't work if the driving
						--	side is also a wire slave connected to something tho...
					contM = wcSlaveData.contsM[idx];
					val = contM.value;
					try ( contM.value = val;) catch ();

					format "-- Updated expression for %.%\n" wcDlg.slave.name (removeLeadingWS wcSlaveData.names[idx]);
					)
				)

		)	-- end of script et change

		on spn_from changed val do
		(
			item = ddl_script.selection;	-- which item are we editing?

			if (item == 1) then		-- See if it is a Script Controller
				(
				mi = wcDlg.selMaster;
				cont = wcMasterData.conts[mi];
				contC = classOf cont;
				if (contC == Float_Script or contC == Point3_Script or
					contC == Position_Script or contC == Rotation_Script or
					contC == Scale_Script) then
					(
					setTimeRange cont val spn_to.value;
					format "-- Updated SCRIPT EXPR Time Range for %.%\n" wcDlg.master.name (removeLeadingWS wcMasterData.names[mi]);
					)
				else
					(

					)
				)
			else if (item == 2) then	  -- if it is item "*new*" then don't have to do anything
				(

				)
			else
				(
				idx = wcDlg.selSlave[(item-2)];

				cont = wcSlaveData.conts[idx];	-- get controller
				setTimeRange cont val spn_to.value;
				format "-- Updated Wire Time Range for %.%\n" wcDlg.slave.name (removeLeadingWS wcSlaveData.names[idx]);
				)

		)

		on spn_to changed val do
		(
			item = ddl_script.selection;	-- which item are we editing?

			if (item == 1) then		-- See if it is a Script Controller
				(
				mi = wcDlg.selMaster;
				cont = wcMasterData.conts[mi];
				contC = classOf cont;
				if (contC == Float_Script or contC == Point3_Script or
					contC == Position_Script or contC == Rotation_Script or
					contC == Scale_Script) then
					(
					setTimeRange cont spn_from.value val;
					format "-- Updated SCRIPT EXPR Time Range for %.%\n" wcDlg.master.name (removeLeadingWS wcMasterData.names[mi]);
					)
				else
					(

					)
				)
			else if (item == 2) then	  -- if it is item "*new*" then don't have to do anything
				(

				)
			else
				(
				idx = wcDlg.selSlave[(item-2)];

				cont = wcSlaveData.conts[idx];	-- get controller
								setTimeRange cont spn_from.value val;
				format "-- Updated Wire Time Range for %.%\n" wcDlg.slave.name (removeLeadingWS wcSlaveData.names[idx]);
				)
		)


		on lb_master selected item do
		(

			wcDlg.selMaster = item;
			mi = item;

			if (wcMasterData.classes[mi] != UndefinedClass and wcMasterData.classes[mi] != undefined) then
				(
				mlb_slave.selection = #();
				mlb_slave.enabled = true;

				wcDlg.selSlave = #();		-- reset our slave selection

					-- now we search and see if anything is conencted and if so built the list
					-- of what is selected on the right side.
				sArr = #();
				cnt = 0;
				for i in 1 to wcSlaveData.names.count do
					(
						-- Now if the slave "master" controller is controlled by
						-- the same controller of this master...we mark it as linked
					if (wcSlaveData.contsM[i] != undefined and wcSlaveData.contsM[i] == wcMasterData.conts[mi]) then
						(
						cnt += 1;
						sArr[cnt] = i;
						wcDlg.selSlave[cnt] = i;
						)
					)
					-- Now set our sel
				mlb_slave.selection = sArr;


				buildExpList();
				)
			else
				(
				mlb_slave.selection = #();
				mlb_slave.enabled = false;

				buildExpList();
				)
		) -- end of MASTER select


		on mlb_slave selected item do
		(
			idx = findItem wcDlg.selSlave item;		-- get our selection idx list

				-- If it is 0 then we gotta add
			if (idx == 0) then
				(
				-- ** Add CLASS CHECK here **
				mi = wcDlg.selMaster;
				si = item;

				leftClass = wcMasterData.classes[mi];
				rightClass = wcSlaveData.classes[si];

				if (canWire leftClass rightClass == true) then
					(
					wcDlg.selSlave[(wcDlg.selSlave.count+1)] = item;
		--			format "-- Added %\n" item;

					if (wcDlg.selMaster != undefined) then
						(
						mi = wcDlg.selMaster;
						si = item;

						if (wcMasterData.classes[mi] != UndefinedClass and wcMasterData.classes[mi] != undefined) then
							(
							format "-- Connecting %.% to %.%\n" wcDlg.master.name (removeLeadingWS wcMasterData.names[mi]) wcDlg.slave.name (removeLeadingWS wcSlaveData.names[si]);
							paramWire.connect (wcMasterData.sAs[mi]) (wcSlaveData.sAs[si]) (et_script.text);

							-- Now update new controller info
							cont = wcSlaveData.sAs[si].controller;
							wcSlaveData.conts[si] = cont;

							local wpar = cont.getWireParent 1;
							pO = (refs.dependents wpar)[1];   -- hack
							pN = getSubAnimName wpar (cont.getWireSubNum 1);

							sM = wpar[pN];
							wcSlaveData.contsM[si] = sM.controller;   -- set SlaveMaster Cont to new value

							-- Also because the master might not have had a controller before, we need to do that as well!
							-- This is the bug fix for 1.02
							wcMasterData.conts[mi] = sM.controller;

							setTimeRange cont spn_from.value spn_to.value;
							)
						)
					) -- end of can wire.
				else
					(
					msg = "";
					msg += "-- ERROR: You cannot wire these two types of controllers together.\n";
					msg += "-- For example a Quat has 4 dimensions, a Color has 3, a Bezier Float has 1.\n";
					msg += "-- You can only wire controllers together with the same number of dimensions\n\n";

					msg += "-- For example Scale to Color is OK, because both have 3 parts, X,Y,Z and R,G,B\n";
					msg += "-- But Scale to Position_X would not work because Scale is X,Y,Z and Position_X\n";
					msg += "--    is a Bezier with 1 dimensional float value.\n\n";

					msg += "-- If you wish to wire a Float to Pos/Rot/Scale make sure you convert the\n";
					msg += "--    Controllers to Position_XYZ, Euler_XYZ or Scale_XYZ to get separate\n";
					msg += "--    individual X, Y and Z Bezier Float sub controllers.\n";
					format "%" msg;
					messageBox msg title:"Cannot Wire Incompatible Controllers" beep:true;
					mlb_slave.selection = wcDlg.selSlave;	-- put back to what is valid only
					)
				)
			else
				(
				deleteItem wcDlg.selSlave idx;
	--			format "-- Removed %\n" item;

				if (wcDlg.selMaster != undefined) then
					(
					mi = wcDlg.selMaster;
					si = item;

					if (wcMasterData.classes[mi] != undefined) then
						(
						format "-- Disconnecting %.%\n" wcDlg.slave.name (removeLeadingWS wcSlaveData.names[si]);
						paramWire.disconnect (wcSlaveData.conts[si])

						-- Now update new controller info
						cont = wcSlaveData.sAs[si].controller;
						wcSlaveData.conts[si] = cont;
						wcSlaveData.contsM[si] = undefined;
						)
					)
				)


				-- Now update dropdown to remove item
			buildExpList();

		)  -- end of slave select


	)

	rollout wireCAboutRoll "About"
	(
		label lLlbl1 "wireConnect";
		label lLlbl2 "";
		label lLlbl3 "Copyright ©2002 Michael B. Comet";
		label lLlbl4 "All Rights Reserved.";
		label lLlbl5 "";
		label lLlbl6 "http://www.comet-cartoons.com/";

		on wireCAboutRoll open do
		(
			lLlbl1.text = ("wireConnect - "+wireCVersion);
		)
	)

	-- --------------------------------------------------------------------------


	fn buildExpList =
	(
			-- Now update dropdown to remove item
		mi = wcDlg.selMaster;

		if (mi >= 1) then
			(
			cnt=1;
			dArr = #("*New*");
			expr = (removeLeadingWS wcMasterData.names[mi]+";");
			range = (interval -1000 10000);

			cont = wcMasterData.conts[mi];
			contC = classOf cont;
			if (contC == Float_Script or contC == Point3_Script or
				contC == Position_Script or contC == Rotation_Script or
				contC == Scale_Script) then
				(
				cnt=2;
				str = "";
				str += "( SCRIPT EXPR ) ";
				str += wcDlg.master.name + ".";
				str += (removeLeadingWS wcMasterData.names[mi]);

				dArr = #(str, "*New*");
				expr = (removeLeadingWS wcMasterData.names[mi]+";");
				range = (interval -1000 10000);
				)
			else
				(
				cnt=2;
				dArr = #("*Value*", "*New*");
				expr = (removeLeadingWS wcMasterData.names[mi]+";");
				range = (interval -1000 10000);
				)

			for cnt in 1 to wcDlg.selSlave.count do
				(
				si = wcDlg.selSlave[cnt];
				dArr[(cnt+2)] = (wcDlg.slave.name+"."+(removeLeadingWS wcSlaveData.names[si]));

				cont = wcSlaveData.conts[si];	-- get controller
				expr = cont.getExprText 1;		-- and the expression
				range = getTimeRange cont;		-- and Range
				)
			wireCControlRoll.ddl_script.enabled = true;
			wireCControlRoll.ddl_script.items = dArr;
			wireCControlRoll.ddl_script.selection = dArr.count;	-- default to the "new" one.

			wireCControlRoll.et_script.text = (expr);
			wireCControlRoll.et_script.enabled = true;

			wireCControlRoll.spn_from.enabled = true;
			wireCControlRoll.spn_to.enabled = true;
			wireCControlRoll.spn_from.value = range.start;
			wireCControlRoll.spn_to.value = range.end;
			)
		else
			(
			wireCControlRoll.ddl_script.items = #();
			wireCControlRoll.ddl_script.enabled = false;

			wireCControlRoll.spn_from.value = -1000;
			wireCControlRoll.spn_to.value = 10000;
			wireCControlRoll.spn_from.enabled = false;
			wireCControlRoll.spn_to.enabled = false;

			wireCControlRoll.et_script.text = "";
			wireCControlRoll.et_script.enabled = false;
			wireCControlRoll.mlb_slave.selection = #();
			wireCControlRoll.mlb_slave.enabled = false;
			)

	)

	-- --------------------------------------------------------------------------

	struct wireConnect
	(
		master=undefined, slave=undefined, selMaster=0, selSlave=#(),

		fn create =
		(
	/*
			try
			(
				destroyDialog wireCDialog;
			)
			catch
			(
			)

			createDialog wireCDialog width:600 height:520 style:#(#style_resizing, #cui_dock_vert, #cui_floatable, #cui_handle, #style_border, #style_titlebar, #style_sysmenu)

			addSubRollout wireCDialog.wireCSubRoll wireCAboutRoll rolledUp:true;
			addSubRollout wireCDialog.wireCSubRoll wireCControlRoll;


	*/
			try
			(
				closeRolloutFloater wireCDialog;
			)
			catch
			(
			)

			wireCDialog = (newRolloutFloater ("Comet: wireConnect - "+wireCVersion) 580 550)
			addRollout wireCControlRoll wireCDialog
			addRollout wireCAboutRoll wireCDialog rolledUp:true

			)


	)

	-- --------------------------------------------------------------------------


	--wcData = wireCData obj:$teapot01;
	--wcData.buildList var:wcData;

	wcDlg = wireConnect();
	wcDlg.create();




)
