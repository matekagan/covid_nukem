extends Control

var main_menu = load("res://main_menu.tscn")
func _ready():
	$main_hbox/credits_vbox/menu.connect("button_down", self, "_menu")
	
func _menu():
		get_tree().change_scene_to(main_menu)