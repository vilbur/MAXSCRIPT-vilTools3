clearListener(); print("Cleared in:\n"+getSourceFileName())


old_TM = getViewTM()

format "old_TM: %\n" old_TM

view = viewport.getType()

viewport.setType #view_persp_user

macros.run "Lights and Cameras" "StandardCamera_CreateFromView"
cam = cameras[cameras.count - 1]
cam.isHidden = true

viewport.setType view





viewport.pan 100 0 -- pan horizontally by ten pixel
completeredraw() -- redraw the views to see the changes


viewport.setCamera cam

delete cam

viewport.setType view




old_TM = getViewTM()

format "old_TM: %\n" old_TM




--format "\n"
--format "old_TM: %\n" old_TM
--format "new_TM: %\n" new_TM
----format "old_TM: %\n" old_TM.pos.x
----format "new_TM: %\n" new_TM.pos.x
--
--
--format "TEST: %\n" (distance (inverse old_TM)[4] new_TM.pos)
----viewport.pan (old_TM - new_TM).pos.x (old_TM - new_TM).pos.y
----completeredraw() -- redraw the views to see the changes
--
--
--				--viewport.setTM old_TM