

/**
  */
macroscript	selection_sort_by_name
category:	"_Selection"
buttontext:	"Sort By Name"
toolTip:	"Sort By Name"
--icon:	"#(path, index)"
(
	fn compareNames obj_1 obj_2 = stricmp obj_1.name obj_2.name

	on execute do
	(
		_selection = for obj in selection collect obj

		qsort _selection compareNames

		select _selection
	)
)


/**
  */
macroscript	selection_random
category:	"_Selection"
buttontext:	"Random"
toolTip:	"Random"
--icon:	"#(path, index)"
(
	step = 2

	select (for obj in selection where random 1 step == step collect obj)
)
