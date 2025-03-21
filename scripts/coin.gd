extends Area2D



@onready var animation_player_coin: AnimationPlayer = $PickupSound/AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	animation_player_coin.play("pickup")
	if GameManager.score != null:
		GameManager.add_point_to_score()
