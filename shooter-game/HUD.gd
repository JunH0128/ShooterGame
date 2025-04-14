extends CanvasLayer

@onready var CurrentWeaponLabel = $VBoxContainer/HBoxContainer/CurrentWeapon
@onready var CurrentAmmoLabel = $VBoxContainer/HBoxContainer2/CurrentAmmo
@onready var CurrentWeaponStack = $VBoxContainer/HBoxContainer3/WeaponStack
@onready var CurrentHealth = $VBoxContainer/HBoxContainer4/Health

func _on_weapon_manager_update_ammo(Ammo) -> void:
	CurrentAmmoLabel.set_text(str(Ammo[0])+" / "+ str(Ammo[1]))


func _on_weapon_manager_weapon_changed(Weapon_Name) -> void:
	CurrentWeaponLabel.set_text(Weapon_Name)


func _on_weapon_manager_update_weapon_stack(Weapon_Stack) -> void:
	CurrentWeaponStack.set_text("")
	for i in Weapon_Stack:
		CurrentWeaponStack.text += "\n"+i


func _on_player_update_health(health: int) -> void:
	CurrentHealth.set_text("Health: " + str(health))
