extends Node2D

export var BASE_SCALE = 1.0


const BASE_POWER = 1000;
const TIME_TO_CHARGE = 3.0

var crosshair:Sprite
var target_scale = Vector2(BASE_SCALE, BASE_SCALE)
var target_rotation = PI / 2
var power = 0.0
var loading_bomb = false

#func _physics_process(delta):
#	crosshair.scale = lerp(crosshair.scale, target_scale, 20 * delta)
#	crosshair.rotation = lerp(crosshair.rotation, target_rotation, 20 * delta)

func _ready():
	position = Vector2(
		get_viewport_rect().size.x * 0.5,
		get_viewport_rect().size.y * 0.5
	)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	crosshair = $crosshair
	crosshair.scale = Vector2(BASE_SCALE, BASE_SCALE)
	crosshair.rotation = target_rotation
	$bomb_size.visible = false
	

func get_scale():
	return $bomb_size.scale

func _process(delta):
	position = get_global_mouse_position()
	crosshair.scale = lerp(crosshair.scale, target_scale, 20 * delta)
	crosshair.rotation = lerp(crosshair.rotation, target_rotation, 20 * delta)
	if (loading_bomb):
		power =  lerp(power, globals.MAX_VIRUS_INFECTED, delta / TIME_TO_CHARGE)
		var bomb_scale = globals.calculate_scale(power)
		$bomb_size.scale = Vector2(bomb_scale, bomb_scale)
	else:
		power = 0.0
	
func adjust_size(new_zoom):
	target_scale = BASE_SCALE * new_zoom
	target_rotation = new_zoom.x * PI / 2

func finish_bomb_loading():
	$bomb_size.visible = false
	
func start_loading_bomb():
	loading_bomb=true
	power = BASE_POWER
	$bomb_size.visible = true
