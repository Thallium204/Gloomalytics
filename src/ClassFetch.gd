extends HBoxContainer

var class_ref:String

onready var label = $Name
onready var icon = $Icon
onready var button = $ButtonFetch
onready var progress = $Center/Progress



func _ready():
	
	progress.value = Globals.get_class_cards_path_array(class_ref).size()
	update_visuals()


func increment_value(inc):
	progress.value += inc
	if progress.value == progress.max_value:
		progress.tint_progress = Color.greenyellow
		update_visuals()
		return true
	return false


func failed():
	progress.value = 0
	progress.tint_under = Color.red
	update_visuals()


func update_visuals():
	
	icon.texture = Globals.get_class_icon(class_ref)
