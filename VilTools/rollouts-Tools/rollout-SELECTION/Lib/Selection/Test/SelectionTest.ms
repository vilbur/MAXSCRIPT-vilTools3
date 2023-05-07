clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Selection.ms" )




--select ((Selection_v()).getInstances( selection[1] ))
select ((Selection_v()).getInstances( selection[1] ) type:#INSTANCE)
--select ((Selection_v()).getInstances( selection[1] ) type:#REFERENCE)