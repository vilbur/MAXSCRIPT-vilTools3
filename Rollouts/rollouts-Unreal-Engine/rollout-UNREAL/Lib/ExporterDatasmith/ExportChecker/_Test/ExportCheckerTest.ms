clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ExportChecker.ms" )

/** This test will set objects to exported state
  *
  */
if maxFileName != "ExportCheckerTest.max" then
	loadMaxFile( getFilenamePath(getSourceFileName()) + "/Scene/ExportCheckerTest.max" )

ExportChecker = ExportChecker_v export_nodes: #($ExportNode)

ExportChecker.analyzeGroups()

format "\n"; print "MERGE THESE GROUPS:"
for _group in ExportChecker.groups_to_attach do format "group: % \n" _group.name



/* ATTACH GROUPS TO OBJECTS */
undo "GroupAttacher_v" on
(
	GroupToObjectBaker_v groups:ExportChecker.groups_to_attach

)
