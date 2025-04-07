extends Node3D

signal Weapon_changed
signal Update_Ammo
signal update_Weapon_Stack

@onready var Animation_Player = get_node("%AnimationPlayer")

var Current_Weapon = null

var Weapon_Stack = []

var Weapon_Indicator = 0

var Next_Weapon: String

var Weapon_List = {}

@export var _weapon_resource: Array[Weapon_Resource]

@export var Start_Weapons: Array[String]

func _ready():
	Initialize(Start_Weapons) #enter the state machine
	
func _input(event):
	if event.is_action_pressed("Weapon_Up"):
		Weapon_Indicator = min(Weapon_Indicator+1, Weapon_Stack.size()-1)
		exit(Weapon_Stack[Weapon_Indicator])
		
	if event.is_action_pressed("Weapon_Down"):
		Weapon_Indicator = max(Weapon_Indicator-1,0)
		exit(Weapon_Stack[Weapon_Indicator])
		
	if event.is_action_pressed("shoot"):
		shoot()
		
	if event.is_action_pressed("Reload"):
		reload()

func Initialize(_start_weapons: Array): 
	for weapon in _weapon_resource:
		Weapon_List[weapon.Weapon_Name] = weapon
		
	for i in _start_weapons:
		Weapon_Stack.push_back(i) # add out start weapons
	
	Current_Weapon = Weapon_List[Weapon_Stack[0]]  # set the first weapon in the stack to current
	emit_signal("update_Weapon_Stack", Weapon_Stack)
	enter()
	
func enter():
	Animation_Player.queue(Current_Weapon.Activate_Anim)
	emit_signal("Weapon_changed", Current_Weapon.Weapon_Name)
	emit_signal("Update_Ammo", [Current_Weapon.Current_Ammo, Current_Weapon.Reserve_Ammo])
	
func exit(_next_weapon: String):
	#in order to change weapons first call exit
	if _next_weapon != Current_Weapon.Weapon_Name:
		if Animation_Player.get_current_animation() != Current_Weapon.Deactivate_Anim:
			Animation_Player.play(Current_Weapon.Deactivate_Anim)
			Next_Weapon = _next_weapon
	
func Change_Weapon(weapon_name: String):
	Current_Weapon = Weapon_List[weapon_name]
	Next_Weapon = ""
	enter()


func _on_animation_player_animation_finished(anim_name) -> void:
	if anim_name == Current_Weapon.Deactivate_Anim:
		Change_Weapon(Next_Weapon)
		
	if anim_name == Current_Weapon.Shoot_Anim && Current_Weapon.Auto_Fire == true:
		if Input.is_action_pressed("shoot"):
			shoot()
		
func shoot():
	if Current_Weapon.Current_Ammo != 0:
		if !Animation_Player.is_playing():
			Animation_Player.play(Current_Weapon.Shoot_Anim)
			Current_Weapon.Current_Ammo -= 1
			emit_signal("Update_Ammo", [Current_Weapon.Current_Ammo, Current_Weapon.Reserve_Ammo])
	else:
		reload()
	
func reload():
	if Current_Weapon.Current_Ammo == Current_Weapon.Magazine:
		return
	elif !Animation_Player.is_playing():
		if Current_Weapon.Reserve_Ammo != 0:
			Animation_Player.play(Current_Weapon.Reload_Anim)
			var Reload_Amount = min(Current_Weapon.Magazine-Current_Weapon.Current_Ammo, Current_Weapon.Magazine,Current_Weapon.Reserve_Ammo)
			
			Current_Weapon.Current_Ammo = Current_Weapon.Current_Ammo + Reload_Amount
			Current_Weapon.Reserve_Ammo = Current_Weapon.Reserve_Ammo - Reload_Amount
			
			emit_signal("Update_Ammo", [Current_Weapon.Current_Ammo, Current_Weapon.Reserve_Ammo])
			
		else:
			Animation_Player.play(Current_Weapon.Out_Of_Ammo_Anim)
