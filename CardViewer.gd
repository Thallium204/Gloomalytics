extends Control

var active_card = 0

var info_text = []

func _ready():
	get_atlas()
	get_info_text()
	update_card()


func get_atlas():
	$Card.texture = load("res://Class Cards/"+Globals.active_class+"/atlas.tres")


func get_info_text():
	var file = File.new()
	file.open("res://Class Cards/"+Globals.active_class+"/info.dat",File.READ)
	var text_array:PoolStringArray = file.get_as_text().split("\n")
	file.close()
	for line in text_array:
		if line == "":
			info_text.append("")
			continue
		var pre_colon = line.split(":",1)
		info_text[-1] += "[b]" + pre_colon[0] + ":  [/b]"
		info_text[-1] += pre_colon[1] + "\n\n"
	print(info_text)


func card_change(change):
	active_card = (active_card + change) % 28
	if active_card < 0:
		active_card += 28
	update_card()


func update_card():
	
	var row = active_card / 9
	var column = active_card % 9
	var card_dim = $Card.texture.region.size
	$Card.texture.region.position = Vector2(column,row) * card_dim
	$PanelContainer/Info.bbcode_text = info_text[active_card]


func _on_ButtonInfo_toggled(button_pressed):
	$Card.visible = not button_pressed
