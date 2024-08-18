extends Node3D
@onready var despawn_timer = $Timer
var SPEED = 200
var mydamage = 15
# Called when the node enters the scene tree for the first time.
func _ready():
	despawn_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0,0,-SPEED) * delta
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("enemy") or body.is_in_group("destructibles"):
		body._take_damage(mydamage)
	pass # Replace with function body.


func _on_timer_timeout():
	self.queue_free()
	pass # Replace with function body.
