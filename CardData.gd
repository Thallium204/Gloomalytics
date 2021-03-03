extends Control

func _ready():
	
	for class_ref in Globals.class_refs:
		
		var class_data = Globals.class_refs[class_ref]
		
		var label = Label.new()
		label.align = Label.ALIGN_CENTER
		label.text = class_data.display_name
		$ScrollContainer/GridOption.add_child(label)
		label.name = class_ref + "_label"
		
		var button = Button.new()
		button.text = "Load"
		button.connect("button_up",self,"fetch_card_data",[class_ref])
		$ScrollContainer/GridOption.add_child(button)
		button.name = class_ref + "_button"
		
		var progress = ProgressBar.new()
		progress.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		progress.size_flags_vertical = Control.SIZE_EXPAND_FILL
		progress.max_value = class_data.card_data.size()
		$ScrollContainer/GridOption.add_child(progress)
		progress.name = class_ref + "_progress"


func fetch_card_data(class_ref):
	$ScrollContainer/GridOption.get_node(class_ref + "_progress").value = 0
	Globals.get_class_cards(class_ref,self,"card_fetched")


func card_fetched(_result, _response_code, _headers, _body, class_ref,_card_id):
	$ScrollContainer/GridOption.get_node(class_ref + "_progress").value += 1


func _on_Button_button_up():
	Transitions.to_main()
