--if HUD_DATA == undefined then -- DEV - if files are impoorted on macroscript run
global HUD_DATA = Dictionary() -- #( #hud_name, HudData_v ),



filein( getFilenamePath(getSourceFileName()) + "/HudColumn.ms" )	-- "./HudColumn.ms"
filein( getFilenamePath(getSourceFileName()) + "/HudRow.ms" )	-- "./HudRow.ms"
filein( getFilenamePath(getSourceFileName()) + "/Hud.ms" )	-- "./Hud.ms"

filein( getFilenamePath(getSourceFileName()) + "/HudDisplay.ms" )	--"./HudDisplay.ms"

filein( getFilenamePath(getSourceFileName()) + "/Callbacks/viewportHudCallback.ms" )	-- "./Callbacks/viewportHudCallback.ms"

filein( getFilenamePath(getSourceFileName()) + "/Callbacks/hudMaxInfoCallback.ms" )	-- "./Callbacks/hudMaxInfoCallback.ms"
filein( getFilenamePath(getSourceFileName()) + "/Callbacks/hudObjectInfoCallback.ms" )	-- "./Callbacks/hudObjectInfoCallback.ms"


filein( getFilenamePath(getSourceFileName()) + "/toggleHudCallback.ms" )	--"./toggleHudCallback.ms"