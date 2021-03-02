extends GridContainer

var card_load = preload("res://src/Card.tscn")

func _ready():
	var card_dim = Vector2()
	var path = "res://Class Cards/16 Triangles/singles/"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)
	var file_name = " "
	while file_name != "":
		
		file_name = dir.get_next()
		
		if ".import" in file_name:
			continue
		
		if ".png" in file_name:
			
			var card = card_load.instance()
			card.texture = load(path + file_name)
			card_dim = card.texture.get_size()
			add_child(card)
	
	var rows = ceil(get_child_count() / float(columns))
	print(rows)
	get_parent().rect_size.y = rows * card_dim.y
