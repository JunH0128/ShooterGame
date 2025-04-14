extends RigidBody3D

var SPEED = 40.0
var Damage: int = 0
var particles = preload("res://particles_3d.tscn")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Target") && body.has_method("Hit_Successful"):
		body.Hit_Successful(Damage)
		
	var particles = particles.instantiate()
	get_tree().root.add_child(particles)
	particles.global_position = global_position
	particles.emitting = true
	
	queue_free()
		

func _on_timer_timeout() -> void:
	queue_free()
	
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	
