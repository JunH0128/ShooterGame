extends Area3D

@export var win_scene: String = "res://Win.tscn"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):  # Better than checking name
		get_tree().change_scene_to_file(win_scene)
