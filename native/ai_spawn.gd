extends Node
@onready var AI_BOT = preload("res://AI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var ai_count_file = FileAccess.open("user://ai_count.dat", FileAccess.READ)
	var ai_count = ai_count_file.get_as_text()
	var ais = []
	for i in range(0,int(ai_count)):
		print()
		ais.append(AI_BOT.instantiate())
		ais[-1].gravity_scale = 0
		ais[-1].position = Vector3((randi()%30)-15,(randi()%30)-15,(randi()%30)-15)
		ais[-1].contact_monitor = true
		ais[-1].max_contacts_reported = 99999
		ais[-1].name = "AI_" + str(len(ais))
		get_parent().add_child.call_deferred(ais[-1])
	
	print(ai_count)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
