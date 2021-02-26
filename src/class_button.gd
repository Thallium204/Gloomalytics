extends Button

var class_ref = ""

func _on_Button_button_up():
	Globals.set_active_class(class_ref)
	get_tree().change_scene("res://CardViewer.tscn")
