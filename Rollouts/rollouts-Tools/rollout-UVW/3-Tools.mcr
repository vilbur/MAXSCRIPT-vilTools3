

/**  LINK TO NODE
 */
macroscript	_uvw
category:	"_UVW"
buttontext:	"Fit"
toolTip:	"Fit vurrent mapping"
--icon:	"Across:2"
--icon:	"Groupbox:Nodes"
--icon:	"type:checkbutton"
(
	--
	--if nodeGetBoundingBox == undefined then
	--	messageBox "The script required [AVG] Avguard Extensions" title:"UVWmap Fit"
	--else
	--(
	--	-- function to get the modifier index into modifiers stack
	--	fn getModIndex oNode mClass = (
	--		local mStack = oNode.modifiers
	--		local mCount = mStack.count
	--		if mCount == 0 then 0
	--		else (
	--			local index = 0, run = true
	--			for i = 1 to mCount while run do (
	--				if (classOf mStack[i] == mClass) do index = i
	--				run = not (index > 0 or i == mCount)
	--			)
	--			index
	--		)
	--	)
	--	
	--	-- function to check whether the modifier exist into modifiers stack
	--	fn isModOnNode oNode mClass = (
	--		local mStack = oNode.modifiers
	--		local mCount = mStack.count
	--		if mCount == 0 then false
	--		else (
	--			local here = false, run = true
	--			for i = 1 to mCount while run do (
	--				here = (classOf mStack[i] == mClass)
	--				run = not (here or i == mCount)
	--			)
	--			here
	--		)
	--	)
	--	
	--	-- function to perform Fit operation on UVWmap modifier
	--	fn UVWMapModFit oNode = (
	--		local mStack = oNode.modifiers
	--		local mCount = mStack.count
	--		if not isModOnNode oNode UVWmap then false
	--		else ( -- if UVWmap exist in the node modifiers stack
	--			local mIndex = getModIndex oNode UVWmap
	--			local mObjs = #(), mState = #()
	--			if mIndex > 1 do ( -- if UVWmap is not on top of the stack
	--				for i = 1 to (mIndex-1) do ( -- backup the #enabled state
	--					append mObjs mStack[i]
	--					append mState mStack[i].enabled
	--				)
	--				mObjs.enabled = off -- turn them off
	--			)
	--			local oTM = oNode.transform
	--			local oBB = nodeGetBoundingBox oNode oTM
	--			local size = (oBB[2] - oBB[1]) * 1.001
	--			local mUVW = mStack[mIndex]
	--			-- reset UVMmap gizmo transform
	--			mUVW.gizmo.transform = matrix3 [1,0,0] [0,1,0] [0,0,1] (in coordsys oTM oNode.center)
	--			case mUVW.axis of ( -- setup gizmo dimension according to aligment #axis state
	--				0: (
	--					mUVW.length = size[2]
	--					mUVW.width = size[3]
	--					mUVW.height = size[1]
	--				)
	--				1: (
	--					mUVW.length = size[3]
	--					mUVW.width = size[1]
	--					mUVW.height = size[2]
	--				)
	--				2: (
	--					mUVW.length = size[2]
	--					mUVW.width = size[1]
	--					mUVW.height = size[3]
	--				)
	--			)
	--			case mUVW.maptype of ( -- include post-setup according to #maptype state
	--				0: (ok) -- #planar (not change)
	--				1: ( -- #cylinder
	--					case mUVW.axis of (
	--						0: (mUVW.width = mUVW.length = amax #(size[1],size[3]); mUVW.height = size[2])
	--						1: (mUVW.width = mUVW.length = amax #(size[2],size[3]); mUVW.height = size[1])
	--						2: (mUVW.width = mUVW.length = amax #(size[1],size[2]); mUVW.height = size[3])
	--					)
	--				)
	--				2: (mUVW.width = mUVW.length = mUVW.height = amax #(size[1],size[2],size[3]))
	--				3: (mUVW.width = mUVW.length = mUVW.height = amax #(size[1],size[2],size[3]))
	--				4: (ok) -- #box (not change)
	--				default: (mUVW.width = mUVW.length = amax #(size[1],size[2]))
	--			)
	--			-- restore the #enabled state of modifiers on top of our UVWmap
	--			for i = 1 to mObjs.count do mObjs[i].enabled = mState[i]
	--			true
	--		)
	--	)
	--	
	--	for obj in selection do UVWMapModFit obj -- call the main function on selected objects
	--)

	
)

