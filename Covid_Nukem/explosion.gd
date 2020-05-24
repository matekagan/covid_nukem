extends Node2D


func _ready():
	pass # Replace with function body.

func initalize(new_position, player_scale):
	position=new_position
	$explosion_sprite.scale = player_scale * 10

func play_explosion():
	$explosion_animator.play("explosion")