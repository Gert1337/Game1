extends Area2D



@onready var animation_player_heart: AnimationPlayer = $PickupSound/AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	animation_player_heart.play("pickup")
	if GameManager.score != null:
		GameManager.gain_life(1)
