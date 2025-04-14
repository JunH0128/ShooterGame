extends Area3D

@export var ammo_amount = 15
@export var ammo_amount_2 = 30
@export var Weapon_name = "Pistol"
@export var Weapon_name_2 = "Rifle"

func _ready():
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body):
	if body.has_method("add_ammo"):
		body.add_ammo(Weapon_name, ammo_amount)
		body.add_ammo(Weapon_name_2, ammo_amount_2)
		queue_free()
