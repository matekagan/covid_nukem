extends Node


func _ready():
	pass # Replace with function body.

func play_bomb_missed_sound():
	$miss.play()
	
func play_bomb_hit_sound():
	$success.play()
	
func play_explosion():
	$explosion.play()