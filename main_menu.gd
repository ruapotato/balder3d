extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE



func _on_start_pressed():
	print("Start game")
	var ai_count_file = FileAccess.open("user://ai_count.dat", FileAccess.WRITE)
	print()
	var ai_count = str(int(find_child("AI_COUNT").current_tab) + 1)
	ai_count_file.store_string(ai_count)
	get_tree().change_scene_to_file("res://Level1.tscn")
	#print("hi")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
