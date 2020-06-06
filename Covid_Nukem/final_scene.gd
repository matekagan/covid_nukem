extends Node2D

var level = load("res://game.tscn")
var main_menu = load("res://main_menu.tscn")

var success_background = preload("res://sprites/game_completed.png")
var failure_background = preload("res://sprites/game_over.png")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$h_box/v_box/h_box_inline/menu.connect("button_down", self ,"_menu")
	$h_box/v_box/h_box_inline/start.connect("button_down", self, "_new_game")

	$background.texture = success_background if game_data.is_success else failure_background
	var score = floor(game_data.score)
	$h_box/v_box/score.text = str(score)

func _menu():
	get_tree().change_scene_to(main_menu)
	
func _new_game():
	get_tree().change_scene_to(level)