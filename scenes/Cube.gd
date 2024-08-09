extends Node3D
var HEALTH = 75

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if HEALTH <= 0 :
		self.queue_free()
	pass

func _take_damage(n):
	HEALTH -= n

func _on_area_3d_body_entered(body):
	#if body is bullet:
	#	_take_damage(body.damage)
	pass # Replace with function body.
