/**
  *
  */
struct SnapManager_v
(
	private

	max_global,
	ip,

	public

	function getState =
	(
		this.ip.ASnapStatus > 0 -- return value
	),

	function setState state =
	(
		if not isKindOf state BooleanClass then throw "Supplied value is not a boolean!"

		if state then

		   if not this.getState() then this.ip.ToggleASnap()
		else

		   if this.getState() then this.ip.ToggleASnap()

		true -- return
	),

	function getAngle =
	(
		this.ip.SnapAngle_ -- return value
	),

	function setAngle ang =
	(
		if not isKindOf ang Number then
			throw "Supplied value is not a number!"

		this.ip.SnapAngle_ = ang as float -- return value
	),

	on create do
	(
		this.max_global = ( dotNetClass "Autodesk.Max.GlobalInterface").Instance
		  this.ip = max_global.COREInterface7
	)
)