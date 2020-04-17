extends Node2D

export var speed := 20.0
export var max_speed := 400

var velocity := Vector2(0.0, 0.0)
var size = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(
		get_viewport_rect().size.x * 0.5,
		get_viewport_rect().size.y * 0.5
	)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	if event is InputEventKey && event.get_scancode() == KEY_ESCAPE:
		exit()
		return
	if event is InputEventMouseMotion:
		position = event.position

func exit():
	var menu = load('res://main_menu.tscn')
	get_tree().change_scene_to(menu)