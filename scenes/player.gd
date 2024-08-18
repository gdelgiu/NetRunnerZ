extends CharacterBody3D

@onready var anim = $NtRnZCharV2/AnimationPlayer
@onready var steps_timer = $StepsAudioTimer
@onready var bullet_spawner = $Marker3D
@onready var laser_beam : PackedScene = preload("res://scenes/laser_beam.tscn")
#laser_synchro forse non serve
@onready var laser_synchro = $LaserSynchroTimer
const SPEED = 10.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#onready cosi' puo' essere chiamata dalla GUI del livello per mostrarla a schermo 
@onready var HEALTH = 100
#statuses
var is_walking: bool = false
var is_running: bool = false
var is_idle : bool = true
var is_shooting : bool = false
var is_jumping : bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	anim.play("Idle")

func _state_machine():
	if is_shooting:
		anim.play("Shoot_001")
	elif is_jumping:
		anim.play("Jump")
	elif is_walking:
		anim.play("Walk")
	elif is_running:
		anim.play("Run_001")
	else:
		anim.play("Idle_001")
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x * -0.09))
#with these mouse settings the cursor is confindet to the window's size,
#and therefore is not possible to close the window
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("mouse_left"):
		_reset_states()
		is_shooting = true
		if event.is_released():
			print_debug("MOLLATO")
			_reset_states()

func _shoot():
	print_debug("SPARATO")
	#is_shooting = false
	var beam = laser_beam.instantiate()
	beam.global_position = bullet_spawner.global_position
	anim.play("Shoot_001")
	beam.instantiate()
	print_debug("DIOPORCO")
	#is_shooting = false
	pass
#aggiornato la mappatura dei comandi, aggiunto WASD a ui_left, ui_right etc
#aggiunto azione "interact" che risponde al tasto "E"
func _physics_process(delta):
	if HEALTH <= 0:
		get_tree().quit()
	# Add the gravity.
	if not is_on_floor():
		_reset_states()
		velocity.y -= gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		is_jumping = true
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		_reset_states()
		is_walking = true
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	#if !direction and !is_jumping and !is_walking  and !is_running and !is_shooting:
##		_reset_states()running
		#direction = 0
	else:
		if is_shooting:
			_shoot()
		else:
			_reset_states()
			is_idle = true
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	_update_animations()

func _reset_states():
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.z = move_toward(velocity.z, 0, SPEED)
	is_idle = false
	is_running = false
	is_shooting = false
	is_walking = false
	is_jumping = false
	
func _update_animations():
	
	if is_running:
		anim.play("Run_001")
	elif is_walking:
		anim.play("Walk")
	elif is_shooting:
		anim.play("Shoot_001")
	elif is_jumping:
		anim.play("Jump")
	elif is_idle:
		anim.play("Idle")

func _take_damage(n):
	HEALTH -= n

func _on_area_3d_body_entered(body):
	#if body is bullet:
	#	_take_damage(body.damage)
	pass # Replace with function body.

##never seems to print out the debug string, might need to properly check getters and other methods
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Shoot_001":
		print_debug("Quack")
		_reset_states()
		is_idle = true

	pass # Replace with function body.
