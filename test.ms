/* ISLANDS VIA VERTS */
clearListener(); print("Cleared in:\n"+getSourceFileName())


--heap_before = heapSize
--
--bitarr = #{}
--
--
--bitarr += #{1..1000000}
--
--
--bitarr *= #{}
--
----format "bitarr[500]:	%\n" bitarr[500]
--format "bitarr:	%\n" bitarr
--format "bitarr.count:	%\n" bitarr.count
--format "bitarr.numberSet:	%\n" bitarr.numberSet
--format "bitarr.isEmpty:	%\n" bitarr.isEmpty
--
--
--
--bitarr += #{100..110}
--
--format "\n---------------\n"
----format "heap_before: %\n" heap_before
----
----cleared = bitarr - #{1..50000}
----format "bitarr: %\n" bitarr
----
----for item in bitarr do
----	bitarr[item] = false
--
----format "bitarr[500]:	%\n" bitarr[500]
--format "bitarr:	%\n" bitarr
--format "bitarr as Array:	%\n" (bitarr as Array)
--format "bitarr.count:	%\n" bitarr.count
--format "bitarr.numberSet:	%\n" bitarr.numberSet
--format "bitarr.isEmpty:	%\n" bitarr.isEmpty


--format "\n"
--
--format "cleared:	%\n" cleared
--format "cleared.count:	%\n" cleared.count
--format "cleared.numberSet:	%\n" cleared.numberSet
--
--
--format "heap_before: %\n" ( (heap_before - heapSize ) /1024 /1024 )


arr = #{}

bitarr = #{1618, 1624, 2408, 2547, 6407, 6690, 7783, 9356, 42379, 42393, 44424, 46925, 46989, 47162..47163, 47406, 47511, 48215, 48349, 48353, 48446, 48700, 50168, 52131, 52744, 52827, 52893, 53226, 53255, 53485, 54120, 54634..54635, 54650, 54652, 54774, 54808, 55177, 55182, 55332, 55706, 85514, 85518, 88180, 88187, 100906, 102615, 102940, 106648, 106706, 109566, 109675, 113011, 117789, 118113, 118509, 123109, 123516, 127821, 128501, 128670, 128875..128876, 129013, 129078, 129087}


for i = 1 to 100 do

append arr bitarr
