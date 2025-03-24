extends Area2D

const ENGINE_TIMESCALE_SLOWED = 0.5
const ENGINE_TIMESCALE_DEFAULT = 1
@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	GameManager.loose_life() # Opdater score og health
	print("GameManager health:", GameManager.health)
	if GameManager.health <= 0:
		Engine.time_scale = ENGINE_TIMESCALE_SLOWED
		print("GameManager health:", GameManager.health)
		body.get_node("CollisionShape2D").queue_free()
		timer.start()



func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = ENGINE_TIMESCALE_DEFAULT
	GameManager.health = 5
	GameManager.score = 0
