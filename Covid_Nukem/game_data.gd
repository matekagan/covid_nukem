extends Node

var score = 0.0
var is_success = false

func increment_score(inc):
	score += inc
	
func get_score():
	return str(floor(score / 1000))