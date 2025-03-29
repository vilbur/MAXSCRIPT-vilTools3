#SingleInstance force

/**
  *	 Generate "Restore Layout.mcr"
  */
$layouts := ["layout_1", "layout_4" ,"layout_2v" ,"layout_3vl" ,"layout_3vr" ,"layout_3ht" ,"layout_3hb" ,"layout_4vl" ,"layout_4vr" ,"layout_4ht" ,"layout_4hb","layout_2h" ,"layout_2ht" ,"layout_2hb"  ]

$macroscript_file := "04-[Layout-Presets].mcr"

FileDelete, %$macroscript_file%


For $index, $layout_name in $layouts
{
	;MsgBox,262144,index, %$index%,3

	StringUpper, $layout_name_text, $layout_name, T
	$layout_name_text :=  StrReplace( $layout_name_text, "_", " " )

	$first_button_params := "|height:28|across:14|offset:[0,4]"

	$macro_name	:= "macroscript layout_restore_"  $layout_name
	$category	:= "category:   ""_Viewports-Layout-Preset"""
	$buttontext	:= "buttontext: """ + $layout_name_text """"
	$tooltip	:= "tooltip:    ""Restore " + $layout_name_text """"
	$icon	:= "icon:       ""images: #('/Icons/Layouts.bmp',undefined,14, " A_Index ")|MENU:true"

	$code	:= "(ViewportLayoutManager_v()).restoreLayout(#" $layout_name ")"

	if( $index == 1 )
		$icon .=  $first_button_params """"
		
	else
		$icon .= "|offset:[" (A_Index - 1 )  ",4]"""


	$macroscript := "`n`n" $macro_name "`n" $category "`n" $buttontext "`n" $tooltip "`n" $icon "`n(`n	" $code "`n)"

	FileAppend, %$macroscript%, %$macroscript_file%

}

exitApp