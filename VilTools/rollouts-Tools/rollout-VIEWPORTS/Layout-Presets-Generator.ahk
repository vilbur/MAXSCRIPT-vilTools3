#SingleInstance force

/**
  *	 Generate "Restore Layout.mcr"
  */
$layouts := ["layout_1", "layout_4" ,"layout_2v" ,"layout_3vl" ,"layout_3vr" ,"layout_3ht" ,"layout_3hb" ,"layout_4vl" ,"layout_4vr" ,"layout_4ht" ,"layout_4hb","layout_2h" ,"layout_2ht" ,"layout_2hb"  ]
;$layouts := ["layout_1", "layout_4" ,"layout_2v","layout_3vl" ,"layout_3vr"  ]

$macroscript_file := "04-[Layout-Presets].mcr"

FileDelete, %$macroscript_file%


For $index, $layout_name in $layouts
{
	;MsgBox,262144,index, %$index%,3

	StringUpper, $label, $layout_name, T
	
	$label :=  StrReplace( $label, "_", " " )

	
	if( $layout_name == "layout_1" )
		$label := "■"
	
	else if( $layout_name == "layout_4" )
		$label := "◄▲▼►"
		
		
	else if( $layout_name == "layout_2ht" )
		$label := "▲ ■"
		
	else if( $layout_name == "layout_2hb" )
		;$label := "▲ ■"
		$label := "■ ▼"
		
		
	else if( $layout_name == "layout_2v" )
		$label := "◄ ►"
	
	else if( $layout_name == "layout_2h" )
		$label := "▼ ▲"
		
		
		
	else if( $layout_name == "layout_3vl" )
		$label := "◄◄ ■"
		
	else if( $layout_name == "layout_3vr" )
		$label := "■ ►►"
		

		
	else if( $layout_name == "layout_4vl" )
		$label := "◄◄◄ ■"
		
	else if( $layout_name == "layout_4vr" )
		$label := "■ ►►►"
		

		
	else if( $layout_name == "layout_3ht" )
		$label := "▲▲ ■"
	else if( $layout_name == "layout_3hb" )
		$label := "▼▼ ■"
		
		
		
	else if( $layout_name == "layout_4ht" )
		$label := "▲▲▲ ■"
		
	else if( $layout_name == "layout_4hb" )
		$label := "■ ▼▼▼"
		


	$first_button_params := "|height:28|across:14|offset:[0,4]"

	$macro_name	:= "macroscript restore_"  $layout_name
	$category 	:= "category: `t""_Viewports-Layout-Preset"""
	$buttontext	:= "buttontext:`t""" $label """"
	$tooltip  	:= "tooltip:`t`t""Restore " $layout_name "\n\nCTRL: Reset Viewport Spliters"""
	$icon     	:= "icon:`t`t""id:" $layout_name "|images: #('/Icons/Layouts.bmp',undefined,14, " A_Index ")|MENU:" + $label
	;$icon	:= "icon:       ""images: #('/Icons/Layouts.bmp',undefined,14, " A_Index ")|MENU:true"
	;$icon	:= "icon:       ""images: #('/Icons/Layouts.bmp',undefined,14, " A_Index ")|MENU:" + $label

	$code	:= "(ViewportLayoutManager_v()).restoreLayout(#" $layout_name ") reset_splitters: keyboard.controlPressed"

	if( $index == 1 )
		$icon .=  $first_button_params """"
		
	else
		$icon .= "|offset:[" (A_Index - 1 )  ",4]"""


    $macroscript := "`n`n" $macro_name "`n" $category "`n" $buttontext "`n" $tooltip "`n" $icon "`n(`n	" $code "`n)"

	FileAppend, %$macroscript%, %$macroscript_file%

}

exitApp