/* ISLANDS VIA VERTS */
clearListener(); print("Cleared in:\n"+getSourceFileName())

    function getVisiblePolys theEditablePoly steps:0 =
    (
        local baVisibleFaces = #{}

        if ( (isValidNode theEditablePoly) and (classOf theEditablePoly == Editable_Poly) ) do
        (
            local fOffsetFactor = 0.01

            local rmgi = RayMeshGridIntersect()
            rmgi.initialize 10
            rmgi.addNode theEditablePoly
            rmgi.buildGrid()

            local m3CameraW = inverse (getViewTM())
            local p3CameraPosW = m3CameraW.row4
            local p3CameraDirW = -m3CameraW.row3

            local p3Offset = m3CameraW.row3 * fOffsetFactor

            local bIsPerspective = viewport.isPerspView()

            -- Test faces by vertices

            local iNumVerts = polyop.getNumVerts theEditablePoly
            local ap3VertsPosW = #()

            local p3VertCameraDirW = -p3CameraDirW
            for iVert = 1 to iNumVerts do
            (
                local p3VertPosW = polyOp.getVert theEditablePoly iVert
                append ap3VertsPosW p3VertPosW

                if (bIsPerspective) do
                (
                    p3VertCameraDirW = normalize (p3CameraPosW - p3VertPosW)
                    p3Offset = p3VertCameraDirW * fOffsetFactor
                )

                local iNumHits = rmgi.intersectRay (p3VertPosW + p3Offset) p3VertCameraDirW true
                if (iNumHits == 0) do
                (
                    baVisibleFaces += polyOp.getFacesUsingVert theEditablePoly iVert
                )
            )

            -- Test faces center
            -- Commented because not correct: To be fixed :)
/*
            local iNumFaces = polyOp.getNumFaces theEditablePoly
            local baAllFaces = #{1..iNumFaces}
            local baFacesToTest = baAllFaces - baVisibleFaces

            local p3CenterCameraDirW = -p3CameraDirW
            for iFace in baFacesToTest do
            (
                local p3FaceCenterPosW = polyop.getFaceCenter theEditablePoly iFace

                if (bIsPerspective) do
                (
                    p3CenterCameraDirW = normalize (p3CameraPosW - p3FaceCenterPosW)
                    p3Offset = p3CenterCameraDirW * fOffsetFactor
                )

                local iNumHits = rmgi.intersectRay (p3FaceCenterPosW + p3Offset) p3CenterCameraDirW true
                if (iNumHits == 0) do
                (
                    baVisibleFaces[iFace] = true
                )
            )
*/
            -- Test faces sub-edges

            if (steps > 0) do
            (
                baFacesToTest = baAllFaces - baVisibleFaces

                local iNumEdges = polyop.getNumEdges theEditablePoly

                local baAllEdges = #{1..iNumEdges}
                local baEdgesToTest = baAllEdges - (polyOp.getEdgesUsingFace theEditablePoly baFacesToTest)

                local p3PointCameraDirW = -p3CameraDirW
                for iEdge in baEdgesToTest do
                (
                    local aiEdgeVerts = polyOp.getEdgeVerts theEditablePoly iEdge

                    local p3VertPosW_1 = ap3VertsPosW[aiEdgeVerts[1]]
                    local p3VertPosW_2 = ap3VertsPosW[aiEdgeVerts[2]]

                    local p3EdgeVecW = p3VertPosW_2 - p3VertPosW_1

                    local ap3TestPosW = for fParam = 0.0 to 1.0 by (1.0 / (steps + 1.0)) collect (p3VertPosW_1 + (p3EdgeVecW * fParam))

                    local iNumHits = -1
                    for iPoint = 2 to (ap3TestPosW.count-1) while (iNumHits != 0) do
                    (
                        if (bIsPerspective) do
                        (
                            p3PointCameraDirW = normalize (p3CameraPosW - ap3TestPosW[iPoint])
                            p3Offset = p3PointCameraDirW * fOffsetFactor
                        )

                        iNumHits = rmgi.intersectRay (ap3TestPosW[iPoint] + p3Offset) p3PointCameraDirW true
                        if (iNumHits == 0) do
                        (
                            baVisibleFaces += polyOp.getFacesUsingEdge theEditablePoly iEdge
                        )
                    )
                )
            )

            -- Select Visible Faces

            subObjectLevel = 4
            polyOp.setFaceSelection theEditablePoly baVisibleFaces

            rmgi.free()
            gc light:true

            return baVisibleFaces
        )
    )

    theNode = (selection as Array)[1]
    --getVisiblePolys theNode steps:0
    getVisiblePolys theNode steps:1



