extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Find AI count
	var AI_count = 0
	for object in get_parent().get_children():
		if "AI_" in object.name:
			AI_count += 1
	
	#ON WIN!
	if AI_count == 0:
		print("you win!")
		get_tree().change_scene_to_file("res://you_win.tscn")
	
	#print(AI_count)
	
