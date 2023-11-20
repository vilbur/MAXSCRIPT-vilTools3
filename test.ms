clearListener(); print("Cleared in:"+getSourceFileName())

--_shape = modPanel.getCurrentObject()


--format "classOf _shape:	% \n" (classOf _shape)
--format "numSplines:	% \n" ( numSplines selection[1] )

--
--for spline_i = 1 to numSplines (obj = selection[1]) do
--	for segment_i = 1 to numSegments obj spline_i do
--		setMaterialID  obj spline_i segment_i segment_i


--Basic start point,
pCenter = Dummy()
pCenter.scale = point3 0.05 0.05 0.05
pCenter.pos = point3 0 0 0
centerX = pCenter.position.x
centerY = pCenter.position.y
centerZ = pcenter.position.z

/*
HINT: convert to and from

radians = degrees * (pi/180)

degrees = radians * (180/pi)

*/


--initial vars from formula:r=a+b*theta
a = 0.0  --this will be replaced in params via centerX and centerY
b = 1.0  -- this is distance for offset
t = 0.0  -- this is start angle
theta = t * (pi/180)


end = 1440.0 -- specify max degrees









for theta =0 to end do
(
    r = a + theta * b
    r *=0.1
    x = centerX + cos(theta) * r
    y = centerY + sin(theta) * r

    pt = Dummy()
    pt.scale = point3 0.1 0.1 0.1
    pt.pos = point3 x y centerZ

)