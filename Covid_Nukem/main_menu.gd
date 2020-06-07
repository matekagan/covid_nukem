extends Control

var level = preload("res://game.tscn")
var credits = preload("res://credits.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$HBox/MainContainer/VBox/Exit.connect("button_down", self ,"_exit")
	$HBox/MainContainer/VBox/Start.connect("button_down", self, "_start")
	$HBox/MainContainer/VBox/credits.connect("button_down", self, "_credits")
	
func _exit():
	get_tree().quit()
	
func _start():
	get_tree().change_scene_to(level)

func _credits():
	get_tree().change_scene_to(credits)