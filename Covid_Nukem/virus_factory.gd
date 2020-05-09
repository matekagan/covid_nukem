extends Node2D

var to_orignal_img_scale=Vector2(5.4687,4.9306)
var mask_start=Vector2(500,100)
var mask_end=Vector2(6500,3000)
var wuhan_position=Vector2(995,223)
var rng = RandomNumberGenerator.new()
var white_bitmap_pixel="000000"
var NEAR_RADIUS=Vector2(400, 400)
var MAP_DATA: Image

func _ready():
	rng.randomize()

func get_virus(position,viruses):
	if rng.randi_range(0,10)<=6:
		return get_virus_near_position(position,viruses)
	else:
		return get_virus_random_position(viruses)
		
func get_virus_random_position(viruses):
	var new_virus = get_virus_without_position()
	new_virus.position=get_random_position_on_land_near_position(Vector2(640,360),Vector2(640,360),viruses)
	return new_virus
	
func get_virus_near_position(position:Vector2,viruses):
	var new_virus = get_virus_without_position()
	new_virus.position=get_random_position_on_land_near_position(vector_to_original_map_scale(position), NEAR_RADIUS, viruses)
	return new_virus
	
func get_virus_without_position():
	var new_virus = get_node("virus").duplicate()
	new_virus.set_time_to_spread(get_random_float(7, 10))
	return new_virus
	

func get_random_position_on_land_near_position(position:Vector2, near:Vector2, viruses):
	var new_pos=get_random_vector_near(position, near)
	#all check
	MAP_DATA = get_node("map").get_texture().get_data()
	MAP_DATA.lock()
	while check_if_is_point_on_land(new_pos) || !check_new_pos_overlap_existing(new_pos,viruses):
		new_pos=get_random_vector()
	MAP_DATA.unlock()
	#land only
	#while check_if_is_point_on_land(new_pos):
	#	new_pos=get_random_vector()
	
	#print("przeszlo")
	#print(new_pos)
	return vector_to_game_map_scale(new_pos)
	
	
func get_random_vector():
	return Vector2(rng.randi_range(mask_start.x,mask_end.x),rng.randi_range(mask_start.y,mask_end.y))
	

func get_random_vector_near(position:Vector2, near:Vector2):
	return Vector2(get_random_float(position.x - near.x, position.x + near.x), get_random_float(position.y - near.y, position.y + near.y))
	
func check_if_is_point_on_land(point:Vector2):
	return white_bitmap_pixel == get_bitmap_color(point)
	
func vector_to_original_map_scale(position: Vector2):
	return Vector2(to_orignal_img_scale.x*position.x,to_orignal_img_scale.y*position.y)
	
func vector_to_game_map_scale(position: Vector2):
	return Vector2(position.x/to_orignal_img_scale.x,position.y/to_orignal_img_scale.y)
	
func get_bitmap_color(position: Vector2):
	var color = MAP_DATA.get_pixel(position.x, position.y).to_html(false)
	return color
	
func check_new_pos_overlap_existing(new_pos,viruses):
	#print("CHECK")
	#print("new_pos")
	#print(new_pos)
	var game_pos = vector_to_game_map_scale(new_pos)
	#print("game_pos")
	#print(game_pos)
	for virus in viruses:
		#print(virus.position)
		if abs(game_pos.x - virus.position.x)<100 && abs(game_pos.y - virus.position.y) < 100:
			return false
	return true
	
func get_wuhan_virus():
	var new_virus = get_node("virus").duplicate()
	new_virus.position=wuhan_position
	return new_virus
	
func get_random_float(from,to):
	return rng.randf_range(from,to)
