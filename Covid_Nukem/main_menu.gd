extends Control

var level = preload("res://game.tscn")

func _ready():
	$HBox/MainContainer/VBox/Exit.connect("button_down", self ,"_exit")
	$HBox/MainContainer/VBox/Start.connect("button_down", self, "_start")

func _exit():
	get_tree().quit()
	
func _start():
	get_tree().change_scene_to(level)