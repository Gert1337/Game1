extends Node

const HEART = preload("res://scenes/heart.tscn")

	


func spawn_hearts(global_position: Vector2, amount: int,zindex: int = 0 , spacing: float = 20.0,heart_position_x_value_relativ_to_parent: float = 0, heart_position_y_value_relativ_to_parent: float = -20 ):
	var parent = get_tree().current_scene
	if parent == null:
		print("Warning: current_scene is null! Trying fallback method.")
		parent = get_tree().root.get_child(0)  # Fallback to main scene
		
	for i in range(amount):
		var heart = HEART.instantiate()
		heart.position = global_position + Vector2(i * spacing+ heart_position_x_value_relativ_to_parent, heart_position_y_value_relativ_to_parent) 
		heart.z_index = zindex
		parent.call_deferred("add_child", heart)  # Avoid physics state issues
