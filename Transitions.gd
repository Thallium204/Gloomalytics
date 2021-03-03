extends Node

const scene_class_select = preload("res://CardSelector.tscn")
const scene_card_data = preload("res://CardData.tscn")
const scene_main = preload("res://Main.tscn")

var background:TextureRect
var tween:Tween
var main_node:Node

var color_visible = Color(1,1,1,1)
var color_invisible = Color(1,1,1,0)

var meta_data = ""

func _ready():
	
	tween = Tween.new()
	add_child(tween)
	
	background = TextureRect.new()
	background.texture = load("res://assets/background.png")
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	background.stretch_mode = TextureRect.STRETCH_SCALE
	add_child(background)
	
	main_node = get_tree().get_root().get_node("Main")


func free_current_scene(packed_scene):
	main_node.connect("tree_exited",self,"add_new_scene",[packed_scene],CONNECT_ONESHOT)
	main_node.queue_free()


func add_new_scene(packed_scene):
	main_node = packed_scene.instance()
	main_node.modulate = Color(1,1,1,0)
	get_parent().add_child(main_node)
	start_tween(color_visible)


func start_tween(to_color:Color):
	var from_color = Color(2,2,2,1) - to_color
	tween.interpolate_property(
		main_node,"modulate",from_color,to_color,0.4,
		Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()


func to_class_select():
	begin_transition(scene_class_select)


func to_card_data():
	begin_transition(scene_card_data)


func to_main():
	begin_transition(scene_main)


func begin_transition(packed_scene):
	tween.connect("tween_all_completed",self,"free_current_scene",[packed_scene],CONNECT_ONESHOT)
	start_tween(color_invisible)





