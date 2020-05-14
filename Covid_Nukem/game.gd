extends Node2D

const zoom_levels = [0.05, 0.1, 0.25, 0.5, 0.75, 1]
export var max_camera_speed = 2000
export var camera_move_offset_ratio = 0.1

var target_camera_position:Vector2
var target_zoom:Vector2
var current_zoom_index = 5

var camera:Camera2D
var player

var max_virsues_count=100

func _ready():
	globals.debug = $canvas/label
	camera = $camera
	player = $player
	target_zoom = Vector2(zoom_levels[current_zoom_index], zoom_levels[current_zoom_index])
	target_camera_position = camera.position
	virus_init()

func _process(delta):
	debug()
	var new_camera_position = camera.position + get_camera_velocity() * delta
	camera.position.x = clamp(new_camera_position.x, 0.0, get_viewport_rect().size.x)
	camera.position.y = clamp(new_camera_position.y, 0.0, get_viewport_rect().size.y)
	time_virsues_spread_check(delta)

func _physics_process(delta):
	#pass
	#camera.position = lerp(camera.position, target_camera_position, 20 * delta)
	camera.zoom     = lerp(camera.zoom, target_zoom, 20 * delta)
	
func _input(event):
	""" Mouse picking """
	if event is InputEventKey && event.get_scancode() == KEY_ESCAPE:
		exit()
		
	if event is InputEventMouseButton:
		handle_mouse_button_event(event)

func handle_mouse_button_event(event):
	if event.pressed: 
		if event.button_index == BUTTON_WHEEL_UP:
			if abs(zoom_levels[current_zoom_index] - camera.zoom.x) < 0.1 * target_zoom.x && current_zoom_index > 0:
				current_zoom_index -= 1
				target_zoom = Vector2(zoom_levels[current_zoom_index],zoom_levels[current_zoom_index])
				target_camera_position += get_local_mouse_position() * 0.4
				player.adjust_size(target_zoom)

		elif event.button_index == BUTTON_WHEEL_DOWN:
			if abs(zoom_levels[current_zoom_index] - camera.zoom.x) < 0.1 * target_zoom.x && current_zoom_index < zoom_levels.size()-1:
				current_zoom_index += 1
				target_zoom = Vector2(zoom_levels[current_zoom_index],zoom_levels[current_zoom_index])
				target_camera_position -= get_local_mouse_position() * 0.4
				player.adjust_size(target_zoom)


func get_camera_velocity():
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position().floor()
	var velocity = Vector2(0.0, 0.0)
	var contant_factor = max_camera_speed * camera.zoom.x
	var camera_move_offset = viewport_size * camera_move_offset_ratio

	if(mouse_pos.x < camera_move_offset.x):
		velocity.x -= contant_factor * (1 - (mouse_pos.x / camera_move_offset.x))

	if (mouse_pos.y < camera_move_offset.y):
		velocity.y -= contant_factor * (1 - (mouse_pos.y / camera_move_offset.y))

	if (mouse_pos.x > viewport_size.x - camera_move_offset.x):
		velocity.x = contant_factor * (1 - (viewport_size.x - mouse_pos.x) / camera_move_offset.x)

	if (mouse_pos.y > viewport_size.y - camera_move_offset.y):
		velocity.y = contant_factor * (1 - (viewport_size.y - mouse_pos.y) / camera_move_offset.y)

	return velocity

func exit():
	var menu = load('res://main_menu.tscn')
	get_tree().change_scene_to(menu)
	
func debug():
	globals.debug.text = ""
	#globals.debug.text += "viruses_size = " + String(get_tree().get_nodes_in_group("viruses_group").size())
	#globals.debug.text += "MOUSE POSITION (Camera.gd)\nGlobal:" + str(get_global_mouse_position().floor())
	#globals.debug.text += "\nLocal:" + str(get_local_mouse_position().floor())
	#globals.debug.text += "\nViewport:" + str(get_viewport().get_mouse_position().floor()) + "\n"
	#globals.debug.text += "\nCAMERA ZOOM: %4.2f" % camera.zoom.x + "\n"
	#globals.debug.text += "\nCAMERA POS: " + str(camera.position) + "\n"
	
func virus_init():
	add_virus_to_game($virus_factory.get_wuhan_virus())
	#for i in range(0,3):
	#	add_virus_to_game(virus_factory.get_virus_random_position(get_tree().get_nodes_in_group("viruses_group")))
	
func time_virsues_spread_check(delta):
	var viruses = get_tree().get_nodes_in_group("viruses_group")
	var randomTime = $virus_factory.get_random_float(5,10)
	var viruses_count=viruses.size()
	for virus in viruses:
		if virus.is_time_to_spread_below_zero():
			if(viruses_count<max_virsues_count):
				add_virus_to_game($virus_factory.get_virus(virus.position,viruses))
				viruses_count+=1
			virus.set_time_to_spread(randomTime)
	
func add_virus_to_game(new_virus):
	add_child(new_virus)
