extends Node3D
@onready var despawn_timer = $Timer
var SPEED = 40
var mydamage = 15
var target
# Called when the node enters the scene tree for the first time.
func _ready():
	despawn_timer.start()
	target = get_viewport().size / 2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#get_viewport().size
	#look_at(Vector3(target.x, target.y, 0))
	#look_at_from_position(get_global_position(),Vector3(target.x, target.y, -500))
	#position +=  Vector3(0,0,-SPEED) * delta
	position += transform.basis * Vector3(0,0,-SPEED) * delta
	#move_toward()
	#velocity = Vector3(0,0,1) * SPEED * delta
	pass


func _on_area_3d_body_entered(body):
	#print_debug("CLANG!")
	if body.is_in_group("enemy") or body.is_in_group("destructibles"):
		print_debug("applying damage")

		body._take_damage(mydamage)
	pass # Replace with function body.


func _on_timer_timeout():
	self.queue_free()
	pass # Replace with function body.
