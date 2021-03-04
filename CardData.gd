extends Control

var class_fetch_load = preload("res://src/ClassFetch.tscn")

onready var grid_node = $ScrollContainer/GridOption

func _ready():
	create_class_fetch_nodes()


func create_class_fetch_nodes():
	
	for class_ref in Globals.class_refs:
		
		var class_data = Globals.class_refs[class_ref]
		var class_fetch = class_fetch_load.instance()
		class_fetch.class_ref = class_ref
		grid_node.add_child(class_fetch)
		class_fetch.label.text = Globals.get_safe_name(class_ref)
		class_fetch.progress.max_value = class_data.card_data.size()
		class_fetch.button.connect("button_up",self,"fetch_card_data",[class_ref,class_fetch])


func fetch_card_data(class_ref, class_fetch):
	disable_buttons()
	class_fetch.progress.value = 0
	Globals.connect("card_fetched_success",self,"card_fetched_success",[class_fetch])
	Globals.connect("card_fetched_failed",self,"card_fetched_failed",[class_fetch])
	Globals.fetch_class_cards(class_ref)


func card_fetched_success(class_fetch):
	if class_fetch.increment_value(+1):
		Globals.disconnect("card_fetched_success",self,"card_fetched_success")
		Globals.disconnect("card_fetched_failed",self,"card_fetched_failed")
		enable_buttons()


func card_fetched_failed(class_fetch):
	class_fetch.failed()
	Globals.disconnect("card_fetched_success",self,"card_fetched_success")
	Globals.disconnect("card_fetched_failed",self,"card_fetched_failed")
	enable_buttons()


func enable_buttons():
	for button in get_tree().get_nodes_in_group("fetch_button"):
		button.disabled = false


func disable_buttons():
	for button in get_tree().get_nodes_in_group("fetch_button"):
		button.disabled = true


func _on_Button_button_up():
	Transitions.to_main()


func _on_ButtonDelete_button_up():
	Globals.delete_singles()
