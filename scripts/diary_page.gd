extends Area2D
var picked_up: bool = false 

@onready var animation_player_diary: AnimationPlayer = $PickupSound/AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	if picked_up:
		print("tried picking up a second time")
		return
	picked_up = true
	animation_player_diary.play("pickup")
	if GameManager.diary_page_log != null:
		GameManager.add_diary_page_to_log()
