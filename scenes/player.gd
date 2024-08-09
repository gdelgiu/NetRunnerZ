extends CharacterBody3D

@onready var anim = $NtRnZChar/AnimationPlayer
@onready var steps_timer = $StepsAudioTimer
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
	anim.play("Idle")
	


#aggiornato la mappatura dei comandi, aggiunto WASD a ui_left, ui_right etc
#aggiunto azione "interact" che risponde al tasto "E"
func _physics_process(delta):
	if HEALTH <= 0:
		get_tree().quit()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		_reset_states()
		is_jumping = true
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	_update_animations()

func _reset_states():
	is_idle = false
	is_running = false
	is_shooting = false
	is_walking = false
	is_jumping = false
	
func _update_animations():
	if is_idle:
		anim.play("Idle")
	elif is_running:
		anim.play("Run_001")
	elif is_walking:
		anim.play("Walk")
	elif is_shooting:
		anim.play("Shoot_001")

func _take_damage(n):
	HEALTH -= n

func _on_area_3d_body_entered(body):
	#if body is bullet:
	#	_take_damage(body.damage)
	pass # Replace with function body.
