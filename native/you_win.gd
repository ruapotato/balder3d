extends Node2D

var time_to_show = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_to_show -= delta
	if time_to_show < 0:
		get_tree().change_scene_to_file("res://main_menu.tscn")
