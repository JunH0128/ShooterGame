extends Area3D

@export var heal_amount := 25  # Adjust in inspector

func _ready():
	# Direct signal connection (most reliable)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Debug prints to verify everything works
	print("Collision with:", body.name)
	
	if body.is_in_group("Player") and body.has_method("take_heal"):
		print("Giving health to player")
		body.take_heal(heal_amount)
		queue_free()  # Remove pickup
