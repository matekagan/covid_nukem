extends Node2D

export var BASE_SCALE = 1.0

var crosshair:Sprite
var target_scale = Vector2(BASE_SCALE, BASE_SCALE)
var target_rotation = PI / 2

func _physics_process(delta):
	crosshair.scale = lerp(crosshair.scale, target_scale, 20 * delta)
	print(crosshair.rotation)
	crosshair.rotation = lerp(crosshair.rotation, target_rotation, 20 * delta)
	#print(crosshair.scale)


func _ready():
	position = Vector2(
		get_viewport_rect().size.x * 0.5,
		get_viewport_rect().size.y * 0.5
	)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	crosshair = $crosshair
	crosshair.scale = Vector2(BASE_SCALE, BASE_SCALE)
	crosshair.rotation = target_rotation

func _process(delta):
	position = get_global_mouse_position()
	
func adjust_size(new_zoom):
	target_scale = BASE_SCALE * new_zoom
	target_rotation = new_zoom.x * PI / 2