extends Area2D

const ENGINE_TIMESCALE_SLOWED = 0.5
const ENGINE_TIMESCALE_DEFAULT = 1
@onready var timer: Timer = $Timer
var health = 2

func _ready() -> void:
	add_to_group("monsters")


func _on_body_entered(body: Node2D) -> void:
	GameManager.loose_life(1) # Opdater score og health
	print("GameManager health:", GameManager.health)
	if GameManager.health <= 0:
		Engine.time_scale = ENGINE_TIMESCALE_SLOWED
		print("GameManager health:", GameManager.health)
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
		print(timer.time_left, timer.wait_time)
	


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = ENGINE_TIMESCALE_DEFAULT
	GameManager.health = 5
	GameManager.score = 0
	GameManager.update_health_display()
	
func take_damage() -> void:
	health -= 1
	print("Monster hit! Health is now: ", health)
	if health <= 0:
		queue_free() 
