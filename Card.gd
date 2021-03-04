extends TextureRect

const center_uv = Vector2(0.5,0.5)
const mouse_speed_to = 6
const mouse_speed_from = 2

var is_hovering = false
var card_uv = Vector2(0.5,0.5)
var mouse_uv = Vector2(0.5,0.5)

func _ready():
	var tex_size = texture.get_size()
	material = material.duplicate()
	update_material()


func update_material():
	material.set_shader_param("card_uv",card_uv)


func _on_Card_gui_input(event):
	
	if not is_hovering:
		return
	
	if event is InputEventMouseMotion:
		
		mouse_uv = (rect_position + event.position - rect_position)/rect_size


func _physics_process(delta):
	
	if is_hovering:
		card_uv += (mouse_uv - card_uv) * delta * mouse_speed_to
	else:
		card_uv += (center_uv - card_uv) * delta * mouse_speed_from
	update_material()


func _on_Card_mouse_entered():
	is_hovering = true


func _on_Card_mouse_exited():
	is_hovering = false
