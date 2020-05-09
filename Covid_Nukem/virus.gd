extends Sprite

var time_to_spread=1

func _ready():
	pass # Replace with function body.

func _process(delta):
	time_to_spread -= delta

func is_time_to_spread_below_zero():
	return time_to_spread<=0
	
func set_time_to_spread(time):
	time_to_spread=time
