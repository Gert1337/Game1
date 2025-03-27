extends Area2D

const SPEED = 60
var direction = 1 
var health = 2

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AnimatedSprite2D/AudioStreamPlayer2D

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
	
	position.x += direction *  SPEED * delta 
	
	
# Function to handle taking damage
func take_damage() -> void:
	health -= 1
	print("Monster hit! Health is now: ", health)
	if health <= 0:
		queue_free()  # Remove the monster from the scene
		
