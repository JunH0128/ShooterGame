extends Area3D

@export var speed: float = 20.0
@export var damage: int = 1
var direction: Vector3 = Vector3.ZERO

func _ready():
	connect("body_entered", _on_body_entered)

func _process(delta):
	# Move forward in the direction it's supposed to
	global_translate(direction * speed * delta)

func _on_body_entered(body: Node):
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()  # Destroy the bullet
