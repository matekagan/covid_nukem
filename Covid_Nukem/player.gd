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
	
func _process(delta):
	if handle_input():
		velocity -= velocity * 20.0 * delta
	velocity.x = min( abs(velocity.x), max_speed ) * sign( velocity.x )
	velocity.y = min( abs(velocity.y), max_speed ) * sign( velocity.y )
	position += velocity * delta
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)

func handle_input():
	var key_pressed = false
	if Input.is_action_pressed("ui_cancel"):
		exit()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		key_pressed = true
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		key_pressed = true
	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed
		key_pressed = true
	if Input.is_action_pressed("ui_down"):
		velocity.y += speed
		key_pressed = true
	return !key_pressed
	
func exit():
	get_tree().quit()