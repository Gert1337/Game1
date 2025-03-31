extends Area2D

const ENGINE_TIMESCALE_SLOWED = 0.5
const ENGINE_TIMESCALE_DEFAULT = 1
@onready var timer: Timer = $Timer
var health = 2
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var self_critisism_sounds: AudioStreamPlayer2D = $"../AnimatedSprite2D/SelfCritisismSounds"
@onready var animated_monster_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

func _ready() -> void:
	add_to_group("monsters")


func _on_body_entered(body: Node2D) -> void:
	GameManager.loose_life(1) # Opdater score og health
	if GameManager.health <= 0:
		Engine.time_scale = ENGINE_TIMESCALE_SLOWED
		self_critisism_sounds.queue_free()
		animation_player.play("Victory")
		animated_monster_sprite.play("Victory")
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
	


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
