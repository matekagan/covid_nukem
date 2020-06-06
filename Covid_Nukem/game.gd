extends Node2D

const zoom_levels = [0.05, 0.1, 0.25, 0.5, 0.75, 1]
const SELECTION_RANGE = 25
export var max_camera_speed = 2000
export var camera_move_offset_ratio = 0.1

var target_camera_position:Vector2
var target_zoom:Vector2
var current_zoom_index = 5

var camera:Camera2D
var player

var max_virsues_count=100
var max_radius=250
var explosion_object = load("res://explosion.tscn")
var final_scene = load("res://final_scene.tscn")

func _ready():
	globals.debug = $canvas/label
	camera = $camera
	player = $player
	target_zoom = Vector2(zoom_levels[current_zoom_index], zoom_levels[current_zoom_index])
	target_camera_position = camera.position
	game_data.score = 0.0
	virus_init()

func _process(delta):
	debug()
	var new_camera_position = camera.position + get_camera_velocity() * delta
	camera.position.x = clamp(new_camera_position.x, 0.0, get_viewport_rect().size.x)
	camera.position.y = clamp(new_camera_position.y, 0.0, get_viewport_rect().size.y)
	time_virsues_spread_check()
	var virus_count = get_tree().get_nodes_in_group("viruses_group").size()
	if (virus_count== 0):
		finish(true)
	elif (virus_count == max_virsues_count):
		finish(false)

func _physics_process(delta):
	camera.zoom = lerp(camera.zoom, target_zoom, 20 * delta)
	
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
	handlemouse_hold(event)

# warning-ignore:unused_argument
func hadle_mouse_release():
	if (!player.loading_bomb):
		return
	explosion()
	$sounds.play_explosion()
	var bomb_radius=max_radius*player.get_scale().x
	var bomb_position=player.position;
	var hit = false
	for node in get_tree().get_nodes_in_group("viruses_group"):
		var node_radius=max_radius*node.scale.x
		var distance= bomb_position.distance_to(node.position)
		if distance>node_radius+bomb_radius:
			continue
		if bomb_radius>=node_radius && bomb_radius-node_radius>=distance:
			hit=true
			node.queue_free()
			game_data.increment_score(node.infected)
		elif  bomb_radius<=node_radius && node_radius-bomb_radius>=distance:
				hit=true
				var per=pow(bomb_radius,2)/pow(node_radius,2)
				var infected=node.infected*per
				node.infected=infected
				game_data.increment_score(infected)
		else:
			var per=abs(bomb_radius-node_radius)/node_radius
			hit=true
			var infected=node.infected*per
			node.infected=infected
			game_data.increment_score(infected)
	player.finish_bomb_loading()


	if (hit):
		$sounds.play_bomb_hit_sound()
	else:
		game_data.increment_score(- player.power)
		$sounds.play_bomb_missed_sound()
	
func handlemouse_hold(event):
	if (event.is_action_pressed("ui_select")):
		player.start_loading_bomb()
	elif (event.is_action_released("ui_select")):
		print("bomb relesed", player.power)
		hadle_mouse_release()

func get_camera_velocity():
	var velocity = Vector2(0.0, 0.0)
	var contant_factor = max_camera_speed * camera.zoom.x


	if Input.is_action_pressed("ui_left"):
		velocity.x -= contant_factor

	if Input.is_action_pressed("ui_right"):
		velocity.x += contant_factor

	if Input.is_action_pressed("ui_up"):
		velocity.y -= contant_factor

	if Input.is_action_pressed("ui_down"):
		velocity.y += contant_factor

	return velocity

func exit():
	var menu = load('res://main_menu.tscn')
	get_tree().change_scene_to(menu)

func finish(success):
	game_data.is_success = success
	get_tree().change_scene_to(final_scene)

func debug():
	globals.debug.text = ""
	globals.debug.text += "viruses_size = " + String(get_tree().get_nodes_in_group("viruses_group").size())  + "\n"
	globals.debug.text += "MOUSE POSITION (Camera.gd)\nGlobal:" + str(get_global_mouse_position().floor())
	globals.debug.text += "\nLocal:" + str(get_local_mouse_position().floor())
	globals.debug.text += "\nViewport:" + str(get_viewport().get_mouse_position().floor()) + "\n"
	globals.debug.text += "\nCAMERA ZOOM: %4.2f" % camera.zoom.x + "\n"
	globals.debug.text += "\nCAMERA POS: " + str(camera.position) + "\n"
	var score=int(game_data.score)
	globals.debug.text += "\n\nSCORE: " + str(score) + "\n"

func virus_init():
	var viruses = get_tree().get_nodes_in_group("viruses_group")
	var wuhan_virus=$virus_factory.get_wuhan_virus()
	add_virus_to_game(wuhan_virus)
	for i in range(5):
	   add_virus_to_game($virus_factory.get_virus(wuhan_virus.position,viruses))
	

func time_virsues_spread_check():
	var viruses = get_tree().get_nodes_in_group("viruses_group")
	var viruses_count=viruses.size()
	var randomTime = $virus_factory.get_random_float(1,7)
	for virus in viruses:
		if virus.is_time_to_spread_below_zero():
			if(viruses_count<max_virsues_count):
				add_virus_to_game($virus_factory.get_virus(virus.position,viruses))
				viruses_count+=1
			virus.set_time_to_spread(randomTime)
	
func add_virus_to_game(new_virus):
	add_child(new_virus)


func explosion():
	var new_explosion = explosion_object.instance()
	new_explosion.initalize(player.position, player.get_scale())
	add_child(new_explosion)
	new_explosion.play_explosion()
