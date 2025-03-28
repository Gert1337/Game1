extends Node

const HEART = preload("res://scenes/heart.tscn")

	


func spawn_hearts(global_position: Vector2, amount: int, spacing: float = 20.0):
	var parent = get_tree().current_scene
	if parent == null:
		print("Warning: current_scene is null! Trying fallback method.")
		parent = get_tree().root.get_child(0)  # Fallback to main scene
		
	for i in range(amount):
		var heart = HEART.instantiate()
		heart.position = global_position + Vector2(i * spacing, -10) 
		parent.call_deferred("add_child", heart)  # Avoid physics state issues
