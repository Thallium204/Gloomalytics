extends GridContainer

var card_load = preload("res://src/Card.tscn")

func _ready():
	
	for card_id in Globals.class_refs["03 Spellweaver"].card_data:
		var card_data = Globals.class_refs["03 Spellweaver"].card_data[card_id]
		var card = card_load.instance()
		card.texture = card_data.image_texture
		add_child(card)
