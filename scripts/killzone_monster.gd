extends Area2D

const ENGINE_TIMESCALE_SLOWED = 0.5
const ENGINE_TIMESCALE_DEFAULT = 1
var health = 2
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var self_critisism_sounds: AudioStreamPlayer2D = $"../AnimatedSprite2D/SelfCritisismSounds"
@onready var animated_monster_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var green_slime: Area2D = $".."

func _ready() -> void:
	add_to_group("monsters")


func _on_body_entered(body: Node2D) -> void:
	GameManager.loose_life(1, green_slime) 
	if GameManager.health <= 0:
		if self_critisism_sounds:
			self_critisism_sounds.queue_free()
		animation_player.play("Victory")
		animated_monster_sprite.play("Victory")
		
