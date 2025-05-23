extends CharacterBody3D

signal Update_Health

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var health: int = 15

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var gun_anim = $Neck/Camera3D/pistol/AnimationPlayer
@onready var walk_anim = $AnimationPlayer

func _ready() -> void:
	emit_signal("Update_Health", health)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#if Input.is_action_pressed("shoot"):
		#if !gun_anim.is_playing():
			#gun_anim.play("Shoot")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
	
func take_damage(amount: int) -> void:
	health -= amount
	print("Player Health:", health)
	if health <= 0:
		distroy()
		
	emit_signal("Update_Health", health)
		
func distroy():
	print("Player died.")
	get_tree().change_scene_to_file("res://Loss.tscn")
		
func add_ammo(weapon_name: String, amount: int):
	$Neck/Camera3D/Weapon_Manager.add_ammo(weapon_name, amount)
