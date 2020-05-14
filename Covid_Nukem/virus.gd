extends Sprite

const MAX_SCALE = 0.1

export var INCREASE_RATIO = 15
export var MAX_INFECITON = 100000

var time_to_spread=1
var infected = 100

func _ready():
	pass # Replace with function body.

func _process(delta):
	time_to_spread -= delta
	infected += (infected * INCREASE_RATIO / 100) * delta
	var increase = log(1 + (scale.x * INCREASE_RATIO / 100 / 2) * delta)
	scale += Vector2(increase, increase)
	scale.x = clamp(scale.x, 0, MAX_SCALE)
	scale.y = clamp(scale.y, 0, MAX_SCALE)

func is_time_to_spread_below_zero():
	return time_to_spread<=0
	
func set_time_to_spread(time):
	time_to_spread=time
