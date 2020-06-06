extends Node

var debug:Label

const MAX_VIRUS_INFECTED := 10 * 1000 * 1000

func calculate_scale(infected):
	return 0.05 + (infected / MAX_VIRUS_INFECTED) / 2

var user_score = 0
