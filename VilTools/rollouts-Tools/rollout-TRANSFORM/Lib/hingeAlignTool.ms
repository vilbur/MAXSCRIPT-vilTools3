try(destroyDialog hingeAlignTool)catch()

rollout hingeAlignTool "Edge Aligner v0.9" width:250
(
    group "1. Define Shapes" (
        button btn_loadSel "Load Selection" width:220 height:32 tooltip:"Select 1 or 2 objects. 1st = Target, 2nd = Source. Select 1 new object to replace Source."
        
        -- Using .NET labels to support colored text in the UI
        dotNetControl lbl_tgtName "System.Windows.Forms.Label" width:230 height:20 align:#left tooltip:"Target object. This object stays static."
        dotNetControl lbl_srcName "System.Windows.Forms.Label" width:230 height:20 align:#left tooltip:"Source object. This object will move."
    )

    group "2. Snap Edges" (
        label lbl_info "Enable 3D Snaps (S) before clicking!" align:#center
        button btn_pick "Pick 4 Edge Points" width:220 height:32 enabled:false tooltip:"1-2: Source Edge Start/End. 3-4: Target Edge Start/End."
    )

    group "3. Adjust Hinge / Fold" (
        spinner spn_angle "Angle:" range:[-360,360,90.0] type:#float width:100 align:#left across:2 enabled:false tooltip:"Fold the shape along the hinge."
        button btn_flip "Flip 180°" width:80 height:32 align:#right enabled:false tooltip:"Rotates the object 180 degrees around the hinge."
        
        button btn_rot90 "+90°" width:65 height:32 across:3 enabled:false tooltip:"Add 90 degrees."
        button btn_rotM90 "-90°" width:65 height:32 enabled:false tooltip:"Subtract 90 degrees."
        button btn_rot0 "Flush (0°)" width:65 height:32 enabled:false tooltip:"Reset to flush alignment."
    )

    -- State Variables
    local srcNode, tgtNode
    local pSrc1, pSrc2, pTgt1, pTgt2
    local origTransform

    -- Functions
    fn updateLabels = (
        if tgtNode != undefined and isValidNode tgtNode then (
            lbl_tgtName.Text = "Target - Align Where: " + tgtNode.name
            tgtNode.wirecolor = color 80 170 255 -- Light Blue
        ) else (
            lbl_tgtName.Text = "Target - Align Where: None"
        )
        
        if srcNode != undefined and isValidNode srcNode then (
            lbl_srcName.Text = "Source - Align What: " + srcNode.name
            srcNode.wirecolor = color 0 255 0 -- Green
        ) else (
            lbl_srcName.Text = "Source - Align What: None"
        )
        
        btn_pick.enabled = (srcNode != undefined and tgtNode != undefined)
    )

    fn loadFromSelection = (
        local sel = getCurrentSelection()
        
        if sel.count >= 2 then (
            -- Standard 2-object selection
            tgtNode = sel[1]
            srcNode = sel[2]
        ) 
        else if sel.count == 1 then (
            -- Easy reselection
            if tgtNode == undefined then (
                tgtNode = sel[1]
            ) else if sel[1] != tgtNode then (
                srcNode = sel[1]
            )
        )
        
        updateLabels()
    )

    -- The Core Alignment Math (Respecting Local Coordinates)
    fn updateAlignment =
    (
        if srcNode == undefined or tgtNode == undefined or not isValidNode srcNode or not isValidNode tgtNode do return false
        if pSrc1 == undefined or pSrc2 == undefined or pTgt1 == undefined or pTgt2 == undefined do return false

        -- 1. Build Source Tripod 
        local vX_s = normalize (pSrc2 - pSrc1)
        local vZ_s = normalize origTransform.row3 
        local vY_s = normalize (cross vZ_s vX_s)
        vZ_s = normalize (cross vX_s vY_s) 
        local mSrc = matrix3 vX_s vY_s vZ_s pSrc1

        -- 2. Build Target Tripod
        local vX_t = normalize (pTgt2 - pTgt1)
        local vZ_t = normalize tgtNode.transform.row3
        local vY_t = normalize (cross vZ_t vX_t)
        vZ_t = normalize (cross vX_t vY_t) 
        local mTgt = matrix3 vX_t vY_t vZ_t pTgt1

        -- 3. Calculate Base Alignment Transform
        local tm = origTransform * inverse(mSrc) * mTgt

        -- 4. Apply Hinge Rotation (Fold the paper/door)
        local angleOffset = spn_angle.value
        if angleOffset != 0.0 do (
            local r = (angleAxis angleOffset vX_t) as matrix3
            local offsetTm = transMatrix (-pTgt1)
            local restoreTm = transMatrix pTgt1
            tm = tm * offsetTm * r * restoreTm
        )

        srcNode.transform = tm
        return true
    )

    -- UI Events
    on hingeAlignTool open do (
        -- Get Max UI Background color dynamically
        local bg = colorMan.getColor #background
        local r = (bg[1] * 255) as integer
        local g = (bg[2] * 255) as integer
        local b = (bg[3] * 255) as integer
        local maxBgColor = (dotNetClass "System.Drawing.Color").FromArgb r g b
        
        lbl_tgtName.BackColor = maxBgColor
        lbl_srcName.BackColor = maxBgColor
        
        lbl_tgtName.ForeColor = (dotNetClass "System.Drawing.Color").DeepSkyBlue
        lbl_srcName.ForeColor = (dotNetClass "System.Drawing.Color").LimeGreen
        
        local fontStyle = (dotNetClass "System.Drawing.FontStyle").Bold
        lbl_tgtName.Font = dotNetObject "System.Drawing.Font" "Tahoma" 8.5 fontStyle
        lbl_srcName.Font = dotNetObject "System.Drawing.Font" "Tahoma" 8.5 fontStyle
        
        loadFromSelection()
    )

    on btn_loadSel pressed do (
        loadFromSelection()
    )

    on btn_pick pressed do (
        if srcNode == undefined or tgtNode == undefined do return false

        origTransform = srcNode.transform
        
        -- Reset angle to the requested default 90 on new pick
        spn_angle.value = 90.0

        -- Viewport Picking Sequence
        pushPrompt "Pick Point 1: Source Edge START"
        pSrc1 = pickPoint snap:#3d
        if pSrc1 == undefined do return false

        pushPrompt "Pick Point 2: Source Edge END"
        pSrc2 = pickPoint snap:#3d rubberBand:pSrc1
        if pSrc2 == undefined do return false

        pushPrompt "Pick Point 3: Target Edge START"
        pTgt1 = pickPoint snap:#3d
        if pTgt1 == undefined do return false

        pushPrompt "Pick Point 4: Target Edge END"
        pTgt2 = pickPoint snap:#3d rubberBand:pTgt1
        if pTgt2 == undefined do return false

        pushPrompt "" -- Clear prompt

        -- Enable Adjustments UI
        spn_angle.enabled = true
        btn_flip.enabled = true
        btn_rot90.enabled = true
        btn_rotM90.enabled = true
        btn_rot0.enabled = true

        updateAlignment()
    )

    on spn_angle changed val do updateAlignment()

    on btn_flip pressed do (
        -- Flips by rotating 180 around the hinge
        spn_angle.value += 180.0
        updateAlignment()
    )

    on btn_rot90 pressed do (
        spn_angle.value += 90.0
        updateAlignment()
    )

    on btn_rotM90 pressed do (
        spn_angle.value -= 90.0
        updateAlignment()
    )

    on btn_rot0 pressed do (
        spn_angle.value = 0.0
        updateAlignment()
    )
)

