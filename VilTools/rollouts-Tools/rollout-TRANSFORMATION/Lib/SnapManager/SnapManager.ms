/**
  *
  */
struct SnapManager_v
(
	private

	max_global,
	ip,

	public

	fn getAngleSnap =
	(
		this.ip.ASnapStatus > 0 -- return value
	),

	fn setAngleSnap state =
	(
		if not isKindOf state BooleanClass then throw "Supplied value is not a boolean!"

		if state then
		(
		   if not this.GetAngleSnap() then this.ip.ToggleASnap())else
		(
		   if this.GetAngleSnap() then this.ip.ToggleASnap()
		)
		true -- return
	),

	fn getSnapAngle =
	(
		this.ip.SnapAngle_ -- return value
	),

	fn setSnapAngle ang =
	(
		if not isKindOf ang Number then
			throw "Supplied value is not a number!"this.ip.SnapAngle_ = ang as float -- return value
	),

	on create do
	(
		this.max_global = ( dotNetClass "Autodesk.Max.GlobalInterface").Instance
		  this.ip = max_global.COREInterface7
	)
)