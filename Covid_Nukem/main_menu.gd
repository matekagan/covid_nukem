extends Control

func _ready():
	$HBox/MainContainer/VBox/Exit.connect("button_down", self ,"_exit")

func _exit():
	get_tree().quit()