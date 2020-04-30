extends Node2D

var to_orignal_img_scale=Vector2(5.4687,4.9306)
var original_pixel_size=Vector2(7000,3550)
var wuhan_position=Vector2(995,223)
var rng = RandomNumberGenerator.new()
var white_bitmap_pixel="000000"
var near=200

func _ready():
	rng.randomize()
	pass 


func get_virus():
	var new_virus = get_node("virus").duplicate()
	new_virus.position=get_random_position_on_land_near_position(Vector2(640,320),Vector2(640,320))
	return new_virus
	
func get_virus_near_position(position:Vector2):
	var new_virus = get_node("virus").duplicate()
	new_virus.position=get_random_position_on_land_near_position(vector_to_original_map_scale(position),Vector2(near,near))
	return new_virus
	
func get_random_position_on_land_near_position(position:Vector2,near:Vector2):
	var new_pos=get_random_vector_near(position,near)
	while check_if_is_point_on_land(new_pos):
		new_pos=get_random_vector()
	print(new_pos)
	print(vector_to_game_map_scale(new_pos))
	return vector_to_game_map_scale(new_pos)
	
	
func get_random_vector():
	return Vector2(rng.randf_range(0,original_pixel_size.x),rng.randf_range(0,original_pixel_size.y))
	
func get_random_vector_near(position:Vector2,near:Vector2):
	return Vector2(get_random_float(position.x-near.x,position.x+near.x),get_random_float(position.y-near.y,position.y+near.y))
	
func check_if_is_point_on_land(point:Vector2):
	return white_bitmap_pixel == get_bitmap_color(point)
	
func vector_to_original_map_scale(position: Vector2):
	return Vector2(to_orignal_img_scale.x*position.x,to_orignal_img_scale.y*position.y)
	
func vector_to_game_map_scale(position: Vector2):
	return Vector2(position.x/to_orignal_img_scale.x,position.y/to_orignal_img_scale.y)
	
func get_bitmap_color(position: Vector2):
	var data=get_node("map").get_texture().get_data()
	data.lock()
	var color = data.get_pixel(position.x,position.y).to_html(false)
	print(position)
	print(color)
	data.unlock()
	return color
	
	
func get_wuhan_virus():
	var new_virus = get_node("virus").duplicate()
	new_virus.position=wuhan_position
	return new_virus
	
func get_random_float(from,to):
	return rng.randf_range(from,to)