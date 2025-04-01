extends Area2D

const ENGINE_TIMESCALE_SLOWED = 0.5
const ENGINE_TIMESCALE_DEFAULT = 1
@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	GameManager.loose_life(GameManager.health) 
	print("GameManager health:", GameManager.health)
	if GameManager.health <= 0:
		body.get_node("CollisionShape2D").queue_free()
