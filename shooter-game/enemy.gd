extends Node3D

@onready var detection_area = $DetectionRange
@onready var shoot_timer = $ShootTimer
@onready var muzzle = $Muzzle
@export var bullet_scene: PackedScene
@export var ammo_scene: PackedScene
@export var shooting_interval: float = 0.5
@export var move_speed: float = 3.0

var player_in_range = false
var player_ref: Node3D = null
var Health = 5

func _ready():
	# Connect signals for detection area
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

	# Set the timer interval for shooting
	shoot_timer.wait_time = shooting_interval
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _process(delta: float) -> void:
	if player_in_range and player_ref:
		look_at_player()
		follow_player(delta)
		
func look_at_player():
	if player_ref:
		var target_pos = player_ref.global_position
		var enemy_pos = global_position
		var look_at_pos = Vector3(target_pos.x, enemy_pos.y, target_pos.z)
		look_at(look_at_pos)
		
func follow_player(delta: float):
	if player_ref:
		var direction = (player_ref.global_position - global_position).normalized()
		direction.y = 0
		global_position += direction * move_speed * delta

func _on_body_entered(body):
	# When the player enters detection range, start the timer to shoot
	if body.name == "Player":  # Check if the body is the player
		player_in_range = true
		player_ref = body
		shoot_timer.start()

func _on_body_exited(body):
	# Stop shooting when player leaves detection range
	if body == player_ref:
		player_in_range = false
		shoot_timer.stop()
		player_ref = null

func _on_shoot_timer_timeout():
	# Shoot at the player if they are in range
	if player_in_range and player_ref:
		shoot_at_player()
		
func Hit_Successful(Damage):
	Health -= Damage
	print("Target Health: " + str(Health))
	
	if Health <= 0:
		spawn_ammo()
		queue_free()
		
func spawn_ammo():
	var ammo = ammo_scene.instantiate()
	ammo.global_position = global_position
	get_tree().current_scene.add_child(ammo)

func shoot_at_player():
	# Calculate direction to the player
	var direction = (player_ref.global_position - muzzle.global_position).normalized()

	# Instantiate a new bullet from the scene
	var bullet = bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position
	
	# Set the bullet's direction to the player
	bullet.direction = direction
	
	# Add bullet to the scene
	get_tree().current_scene.add_child(bullet)
