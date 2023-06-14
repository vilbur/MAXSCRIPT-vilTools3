/**
  *
  */
struct ExporterSTL_v
(
	/* construct */
	/* properties */
	export_scale,

	/* dependency */
	/* reference */
	/* inhered */

	/**  Open export *.stl dialog and export
	  *
	  * @param array export_objects
	  * @param string export_filepath
	  *
	  * @return boolean
	 */
	function export export_objects export_filepath =
	(
		--format "\n"; print "PrintExporter_v.export()"
		global STL_Object_Name = getFilenameFile( export_filepath )

		function SetSTLExportOptions =
		(
			local BM_GETSTATE = 0xF2
			local BM_CLICK = 0xF5
			local BM_SETCHECK = 0xF1
			local BST_CHECKED = 0x1

			WindowHandle = DialogMonitorOPS.GetWindowHandle()

			if ((UIAccessor.GetWindowText WindowHandle) == "Export STL File") then
			(
				children = UIAccessor.GetChildWindows WindowHandle

				for i = 1 to children.count do
				(
					child = children[i]
					child_title = (UIAccessor.GetWindowText child)
					--format "child_title	= % \n" child_title

					if (child_title == "Object01") then
						UIAccessor.SetWindowText child STL_Object_Name

					if (child_title == "Selected only") then
					(
						cbState = windows.sendMessage child BM_GETSTATE 0 0
						checked = bit.get cbState BST_CHECKED
						if (checked == false) then
						(
							windows.sendMessage child BM_CLICK 0 0
							windows.sendMessage child BM_SETCHECK 1 0
						)
					)
				)
				uiAccessor.sendMessageID WindowHandle #IDOK
			)
			true
		)

		DialogMonitorOPS.unRegisterNotification id:#Set_STL_Export_Options
		DialogMonitorOPS.RegisterNotification SetSTLExportOptions id:#Set_STL_Export_Options
		DialogMonitorOPS.Enabled = true

		select export_objects

		this._scaleObjects(export_objects)

		deleteFile export_filepath

		exportFile export_filepath

		DialogMonitorOPS.Enabled = false
		DialogMonitorOPS.unRegisterNotification id:#Set_STL_Export_Options

		true --return
	),

	/** Set export scale
	 */
	function setExportScale val =
	(
		--format "\n"; print "ExporterOBJ_v.setExportScale()"
		this.export_scale = val
	),


	private

	/** Scale objects
	 */
	function _scaleObjects export_objects =
	(
		format "\n"; print "ExporterSTL_v.scaleObjects()"

		if this.export_scale != 1 then
		(
			export_objects.scale = [ this.export_scale ,this.export_scale ,this.export_scale ]

		)

	),

	/**
	 */
	on create do
	(
		--format "\n"; print "ExporterSTL_v.onCreate()"
	)

)