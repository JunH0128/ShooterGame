extends Node3D

@onready var Animation_Player = get_node("%AnimationPlayer")

var Current_Weapon = null

var Weapon_Stack = []

var Next_Weapon: String

var Weapon_List = {}

@export var _weapon_resource: Array[Weapon_Resource]

@export var Start_Weapons: Array[String]

func _ready():
	Initialize(Start_Weapons) #enter the state machine
	
#func _input(event):
	#if event.is_action_pressed("Weapon_Up"):
		#Weapon_Indicator = min(Weapon_Indicator+1, Weapon_Stack.size()-1)
		#exit(Weapon_Stack[Weapon_Indicator])

func Initialize(_start_weapons: Array): 
	for weapon in _weapon_resource:
		Weapon_List[weapon.Weapon_Name] = weapon
		
	for i in _start_weapons:
		Weapon_Stack.push_back(i) # add out start weapons
	
	Current_Weapon = Weapon_List[Weapon_Stack[0]]  # set the first weapon in the stack to current
	enter()
	
func enter():
	Animation_Player.queue(Current_Weapon.Activate_Anim)
	
func exit(_next_weapon: String):
	#in order to change weapons first call exit
	pass
	
func Change_Weapon():
	pass
