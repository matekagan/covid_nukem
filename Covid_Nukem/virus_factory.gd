extends Node2D

var to_orignal_img_scale=Vector2(5.4687,4.9306)
var mask_start=Vector2(500,100)
var mask_end=Vector2(6500,3000)
var wuhan_position=Vector2(995,223)
var rng = RandomNumberGenerator.new()
var NEAR_RADIUS=Vector2(400, 400)
var MAP_DATA
var virus_object = load("virus.tscn")

func _ready():
	MAP_DATA = $mask.get_texture().get_data()
	rng.randomize()

func get_virus(position,viruses):
	var new_virus = virus_object.instance()
	new_virus.set_time_to_spread(get_random_float(1, 10))
	if rng.randi_range(0,10)<=6:
		new_virus.position=get_virus_near_position(position,viruses)
	else:
		new_virus.position=get_virus_random_position(viruses)
	return new_virus
		
func get_virus_random_position(viruses):
	var new_pos=get_random_vector()
	var found=false
	MAP_DATA.lock()
	while !found:
		if is_pixel_on_land(MAP_DATA.get_pixel(new_pos.x, new_pos.y)):
			if !is_position_overlap_existing_viruses(new_pos,viruses):
				found=true
		if !found:
			new_pos=get_random_vector()
	MAP_DATA.unlock()
	return vector_to_game_map_scale(new_pos)
	
func get_virus_near_position(position:Vector2,viruses):
	var map_pos=vector_to_original_map_scale(position)
	var new_pos=get_random_vector_near(map_pos,NEAR_RADIUS)
	var counter=0
	var found=false
	MAP_DATA.lock()
	while !found:
		if is_pixel_on_land(MAP_DATA.get_pixel(new_pos.x, new_pos.y)):
			if !is_position_overlap_existing_viruses(new_pos,viruses):
				found=true
		if !found:
			new_pos=get_random_vector_near(map_pos,NEAR_RADIUS)
		if counter>10:
			MAP_DATA.unlock()
			return get_virus_random_position(viruses)
	MAP_DATA.unlock()
	return vector_to_game_map_scale(new_pos)
	
func is_pixel_on_land(pixel):
	return pixel.r>0.1
		
func get_random_vector():
	return Vector2(rng.randi_range(mask_start.x,mask_end.x),rng.randi_range(mask_start.y,mask_end.y))
	

func get_random_vector_near(position:Vector2, near:Vector2):
	var min_position_width=position.x - near.x if position.x - near.x>mask_start.x else mask_start.x
	var max_position_width=position.x + near.x if position.x + near.x<mask_end.x else mask_end.x
	var min_position_height=position.y - near.y if position.y - near.y>mask_start.y else mask_start.y
	var max_position_height=position.y + near.y if position.y + near.y<mask_end.y else mask_end.y
	
	return Vector2(get_random_float(min_position_width,max_position_width), get_random_float(min_position_height,max_position_height))
	
	
func vector_to_original_map_scale(position: Vector2):
	return Vector2(to_orignal_img_scale.x*position.x,to_orignal_img_scale.y*position.y)
	
	
func vector_to_game_map_scale(position: Vector2):
	return Vector2(position.x/to_orignal_img_scale.x,position.y/to_orignal_img_scale.y)
	
	
func is_position_overlap_existing_viruses(new_pos,viruses):
	var game_pos = vector_to_game_map_scale(new_pos)
	for virus in viruses:
		if game_pos.distance_squared_to(virus.position) < 550:
			return true
	return false
	
func get_wuhan_virus():
	var new_virus = virus_object.instance()
	new_virus.position=wuhan_position
	return new_virus
	
func get_random_float(from,to):
	return rng.randf_range(from,to)
