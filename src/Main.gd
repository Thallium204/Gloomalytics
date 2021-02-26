extends Control



func _on_ButtonCardViewer_button_up():
	get_tree().change_scene("res://ClassSelect.tscn")


func _on_ButtonScan_button_up():
	Globals.get_classes_data()
