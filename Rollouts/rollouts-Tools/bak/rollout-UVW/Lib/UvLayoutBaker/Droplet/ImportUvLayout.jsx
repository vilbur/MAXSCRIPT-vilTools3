
// ============================================================================
// 
// 1) Copy layer of opened document and paste it to previous document
// 
// 
// ============================================================================

// this command only works in Photoshop CS2 and higher
#target photoshop

// bring application forward for double-click events
app.bringToFront();


(function ImportUvTemplate()
{

	function selectUvTemplateLayer( TargetDoc, layer_name )
	{
		var layers = TargetDoc.artLayers
		try {
			TargetDoc.activeLayer = TargetDoc.artLayers.getByName( layer_name );
			return true
		  }
			catch (e) {
			return false
		  }
	}
	

	
	/* Get UV template layer from current document
	 * 
	 */
	var DocToImport = activeDocument;

	var name = DocToImport.name.replace(/(?:\.[^.]*$|$)/, '');

	DocToImport.activeLayer.copy()

	DocToImport.close(SaveOptions.DONOTSAVECHANGES);
	
	
	/** Import layer to last active document 
	  *	
	  */
	var TargetDoc = app.activeDocument;
		
	if( selectUvTemplateLayer(TargetDoc, name ) != false )
	{
		TargetDoc.activeLayer.allLocked = false;
		
		TargetDoc.activeLayer.remove();
	}
	else
		TargetDoc.activeLayer = TargetDoc.artLayers[0]

	
	
	TargetDoc.paste();
	
	TargetDoc.activeLayer.name = name
	
	TargetDoc.activeLayer.blendMode  = BlendMode.LIGHTEN;
		
	TargetDoc.activeLayer.allLocked = true;
		
		//TargetDoc.revealAll();
		
})()