extends Node
@onready var life_cube = preload("res://ingame_items/life_cube.tscn")

var spawn_every = 15
var time_counter = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_counter += delta
	#print(time_counter)
	if int(time_counter) != 0 and int(time_counter) % spawn_every == 0:
		var item = []
		#print("Spawn Life")
		item.append(life_cube.instantiate())
		item[-1].gravity_scale = 0
		item[-1].position = Vector3((randi()%30)-15,(randi()%30)-15,(randi()%30)-15)
		item[-1].contact_monitor = true
		item[-1].max_contacts_reported = 2
		item[-1].name = "life_cube_" + str(len(item))
		get_parent().add_child.call_deferred(item[-1])
		time_counter = 0.0
