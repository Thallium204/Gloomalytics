extends Control

var ClassButton_load = preload("res://ClassButton.tscn")

func _ready():
	
	var Grid = $ScrollContainer/GridClasses
	for class_ref in Globals.classes_data:
		var class_data = Globals.classes_data[class_ref]
		var button = ClassButton_load.instance()
		button.text = class_data.name
		if class_data.has("icon_path"):
			button.icon = load(class_data.icon_path)
		button.disabled = not class_data.has("front_path")
		Grid.add_child(button)
