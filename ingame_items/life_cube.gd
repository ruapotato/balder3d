extends RigidBody3D


var life_add = 50
var ttl = 100
signal damage_me(this_much)
# Called when the node enters the scene tree for the first time.
func _ready():
	damage_me.connect(_take_damage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ttl -= delta
	if ttl < 0:
		queue_free()

func _take_damage(this_much):
	ttl = .1

func _on_body_entered(body):
	if body.get_script():
		#print(body.get_signal_list())
		for sig in body.get_signal_list():
			if sig.name == "add_life":
				#print("hi")
				body.emit_signal("add_life", life_add)
				$add_life_sound.play()
				ttl = .5
				life_add = 0
