extends Area2D

var speed = 60
var direction = 1 
var health = 2

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AnimatedSprite2D/SelfCritisismSounds
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const HEART = preload("res://scenes/heart.tscn")

func _ready() -> void:
	add_to_group("monsters")
	audio_stream_player.play()
	 # Restart when finished
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true 
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	
	position.x += direction *  speed * delta 
	
	
# Function to handle taking damage
func take_damage() -> void:
	health -= 1
	animation_player.play("Hurt")
	print("Monster hit! Health is now: ", health)
	if health <= 0:
		speed = 0
		audio_stream_player.queue_free()
		animation_player.play("Dying")
		spawn_hearts(2)
		
func spawn_hearts(amount: int, spacing: float = 20.0):
	for i in range(amount):
		var heart = HEART.instantiate()
		heart.position = global_position + Vector2(i * spacing, -10) 
		get_parent().call_deferred("add_child", heart)
