extends Control



func _on_ButtonCardViewer_button_up():
	Transitions.to_class_select()


func _on_ButtonCardData_button_up():
	Transitions.to_card_data()
