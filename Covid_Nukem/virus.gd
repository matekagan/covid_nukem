extends Sprite

export var INCREASE_RATIO = 20

const INCREASE_TIME = 20.0
var time_to_spread=1
var infected = 1000

func _ready():
	scale = Vector2(infected / globals.MAX_VIRUS_INFECTED, infected / globals.MAX_VIRUS_INFECTED)
	pass # Replace with function body.

func _process(delta):
	time_to_spread -= delta
#	infected += INCREASE_RATIO + (infected * INCREASE_RATIO / 100) * delta
#	infected = clamp(infected, 0, globals.MAX_VIRUS_INFECTED)
	infected = lerp(infected, globals.MAX_VIRUS_INFECTED, delta / INCREASE_TIME)
	var new_scale = globals.calculate_scale(infected)
	scale = Vector2(new_scale, new_scale)

func is_time_to_spread_below_zero():
	return time_to_spread<=0
	
func set_time_to_spread(time):
	time_to_spread=time
