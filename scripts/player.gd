extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer





func _ready():
	if not player_sprite.animation_finished.is_connected(_on_animated_sprite_2d_animation_finished):
		player_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
		print("Signal connected!")
	else: 
		print("Signal not connected")	
	GameManager.connect("player_took_damage", Callable(self, "_on_player_took_damage"))	
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction : -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	#Flip the sprite
	if direction > 0:
		player_sprite.flip_h = false
	elif direction < 0: 
		player_sprite.flip_h = true
	
	#Play animations
	if is_on_floor():
		if direction == 0: 
			player_sprite.play("idle")
		elif direction != 0 and player_sprite.animation not in ["lifting", "run"]:
			play_animation("lifting")
	else: 
		if player_sprite.animation != "jump":
			player_sprite.play("jump")
			
		
	
	#apply movement 
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
			
func play_animation(anim_name: String):
	print("Attempting to play:", anim_name)  # Debugging
	if player_sprite.animation != anim_name:  
		player_sprite.play(anim_name)
		print("Animation set to:", anim_name)
	else:
		print("Animation was already:", anim_name)



func _on_animated_sprite_2d_animation_finished():
	print("Animation finished: " + player_sprite.animation)
	if player_sprite.animation == "lifting":
			print("playing run")
			player_sprite.play("run")
			
func _on_player_took_damage():
		animation_player.play("hurt")
