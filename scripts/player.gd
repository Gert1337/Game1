extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const HEART_BULLET = preload("res://scenes/heart_bullet.tscn")
var can_shoot = true
var fire_rate = 0.5  # Adjust shooting speed
var player_direction 



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
		player_direction = Vector2.RIGHT
	elif direction < 0: 
		player_sprite.flip_h = true
		player_direction = Vector2.LEFT
	
	#Play animations
	if is_on_floor():
		if direction == 0: 
			player_sprite.play("idle")
			can_shoot = true
		elif direction != 0 and player_sprite.animation not in ["lifting", "run"]:
			play_animation("lifting")
			can_shoot=false
	else: 
		if player_sprite.animation != "jump":
			player_sprite.play("jump")
			
	if Input.is_action_just_pressed("shoot") and can_shoot:
		if GameManager.health == 1: 
			print("I cant shoot or ill die")
		else : 
			shoot()
			print("shoot")	
	
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
			can_shoot = false
			print("playing run")
			player_sprite.play("run")
			
func _on_player_took_damage():
		if GameManager.health > 0:
			animation_player.play("hurt")
		else: 
				animation_player.play("died")
				
func shoot():
	can_shoot = false
	var bullet = HEART_BULLET.instantiate()  # Create the bullet instance
	bullet.position = global_position + Vector2(0, -10)
	GameManager.loose_life(1)
	  # Adjust spawn position
	bullet.direction = player_direction

	get_parent().add_child(bullet)  # Add bullet to the scene
	await get_tree().create_timer(fire_rate).timeout  # Wait before next shot  # Wait before shooting again
	can_shoot = true
		
