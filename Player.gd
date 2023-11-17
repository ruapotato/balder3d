extends RigidBody3D

@onready var laser_ball_L1 = preload("res://laser_ball_L1.tscn")
@onready var shild = preload("res://native/shild.tscn")
@onready var life_text = self.find_child("Life_Text")
@onready var launch_power_text = self.find_child("Launch_Power_Text")
@onready var power_text = self.find_child("Power_Text")

var mouse_move = [0,0]
var shoot_speed = 17
var life = 100
var launch_power = 0
var max_launch_power = 25
var launch_power_build_speed = 10
var wants_to_grab = false
var tethered = false
var power = 0
var max_power = 100
var power_build_speed = 20
var cost_to_shoot = 10
var shoot_cooldown = 0
var fire_rate = .1
var shild_cost = 50

signal damage_me(this_much)
signal add_life(this_much)
#var shoot_vector = Vector3(5,0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	damage_me.connect(_take_damage)
	add_life.connect(_add_life)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	contact_monitor = true
	max_contacts_reported = 99999
	life_text.text = "Life: " + str(life)

func _take_damage(damage):
	#print("Oh that really got me good!")
	life -= damage
	life_text.text = "Life: " + str(life)
	#print(life)

func _add_life(this_much):
	life += this_much
	if life > 100:
		life  = 100
	life_text.text = "Life: " + str(life)

func _unhandled_input(event):
	#Quit on esc
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	#Send mouse data
	if event is InputEventMouseMotion:
		mouse_move = [event.relative.x, event.relative.y]
		#print("mouse moved")
	
	#Shild
	if Input.is_action_just_pressed("shild"):
		var new_shild = shild.instantiate()
		add_collision_exception_with(new_shild)
		new_shild.add_collision_exception_with(self)
		new_shild.name = "my_shild"
		add_child(new_shild)
	
	#Set want to grab wall
	if Input.is_action_just_pressed("stick"):
		wants_to_grab = true
		if not tethered:
			launch_power_text.text = "Grab Wall"
	if Input.is_action_just_released("stick"):
		wants_to_grab = false
		if not tethered:
			launch_power_text.text = "Bounce"
		
	#jump
	if Input.is_action_just_released("jump"):
		if tethered:
			tethered = false
			var local = to_local(global_position)
			var local_target = Vector3(local.x,local.y,local.z - 1)
			
			#Add speed on local Z
			var global_direction = -global_transform.basis.z * launch_power
			apply_impulse(global_direction, global_direction * 10)
			launch_power = 0
			#launch_power_text.text = "Lauch Speed: " + str(int(launch_power))
			if Input.is_action_pressed("stick"):
				launch_power_text.text = "Grab Wall"
			else:
				launch_power_text.text = "Bounce"


func _on_body_entered(body):
	#print("hit" + body.name)
	if wants_to_grab:
		tethered = true
		linear_velocity = Vector3(0,0,0)
		launch_power_text.text = "Speed: " + str(int(launch_power))

func _physics_process(delta):
	if mouse_move != [0,0]:
		rotate_object_local(Vector3(1,0,0), mouse_move[1] * -.3 * delta)
		rotate_object_local(Vector3(0,1,0), mouse_move[0] * -.3 * delta)
		#print(mouse_move)
		mouse_move = [0,0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Update power
	if power < max_power:
		power += delta * power_build_speed
		power_text.text = "capacitor: " + str(int(power))
	elif power > max_power:
		power = max_power
	
	
	#Update objects in use
	for obj in get_children():
		#Update shild
		if obj.name == "my_shild":
			power -= delta * shild_cost
			if power < 0:
				obj.queue_free()
		
	
	
	#Update shootcooldown
	if shoot_cooldown > 0:
		shoot_cooldown -= delta
	
	#print(shoot_cooldown)
	
	if tethered:
		linear_velocity = Vector3(0,0,0)
		if Input.is_action_pressed("jump"):
			if launch_power < max_launch_power:
				launch_power += delta * launch_power_build_speed
				launch_power_text.text = "Speed: " + str(int(launch_power))
			elif launch_power > max_launch_power:
				launch_power = max_launch_power
				launch_power_text.text = "Speed: " + str(int(launch_power))
		#Launch_Power_Text
		
		
	#Fire
	if Input.is_action_pressed("shoot"):
		if shoot_cooldown <= 0:
			if power - cost_to_shoot > 0:
				power -= cost_to_shoot
				shoot_cooldown = fire_rate
				#print("Add new laser ball")
				var new_laser = laser_ball_L1.instantiate()
				new_laser.gravity_scale = 0
				new_laser.contact_monitor = true

				var local = to_local(global_position)
				var local_target = Vector3(local.x,local.y,local.z - 1)
				#var pos = Vector3(global_position.x,lobal_position.y,global_position.z + .5)
				
				#Add speed on Z
				new_laser.transform.origin = to_global(local_target)
				var global_direction = -global_transform.basis.z * shoot_speed
				var player_pushback = global_transform.basis.z
				new_laser.apply_impulse(global_direction, global_direction * 10)
				apply_impulse(player_pushback, global_direction * 10)
				new_laser.rotation = rotation
				get_parent().add_child(new_laser)
	#print(launch_power)
