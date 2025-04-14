extends Node3D

@export var speed: float = 20.0
@export var damage: int = 1
var direction: Vector3 = Vector3.ZERO

func _ready():
	# Initialize bullet speed and direction here
	rotation_degrees.y = 0  # Ensure the bullet is aligned correctly at the start

func _process(delta):
	# Move the bullet in the direction it's facing
	translate(direction * speed * delta)
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		#body.take_damage(damage)
		queue_free()
