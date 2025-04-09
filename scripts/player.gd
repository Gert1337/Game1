extends CharacterBody2D


var speed = 130.0
const JUMP_VELOCITY = -300.0
const ACCELARATION = 600.0
const FRICTION = 600.0
const HEART_BULLET = preload("res://scenes/heart_bullet.tscn")
const ENGINE_TIMESCALE_SLOWED = 0.5
const ENGINE_TIMESCALE_DEFAULT = 1
var can_shoot = true
var fire_rate = 0.5  # Adjust shooting speed
var player_direction = Vector2.RIGHT
var shooting = false
var locked = false
var current_platform: Node = null

@onready var platform_detection: RayCast2D = $PlatformDetection
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer
signal player_healing
signal player_starting_to_heal

func _ready():
	if not player_sprite.animation_finished.is_connected(_on_animated_sprite_2d_animation_finished):
		player_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
		print("Signal connected!")
	else: 
		print("Signal not connected")	
	GameManager.connect("player_took_damage", Callable(self, "_on_player_took_damage"))	


		
func _physics_process(delta: float) -> void:
	if locked: 
		move_and_slide()
		return
	
	apply_gravity(delta)
	handle_jumping(delta)
	# Get the input direction : -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	handle_accelaration(direction, delta)
	handle_friction(direction, delta)
	handle_playersprite_flipping(direction)
	handle_player_animation(direction)
	var was_on_floor = is_on_floor()
	if current_platform != null and is_on_floor():
		if platform_detection.is_colliding() and platform_detection.get_collider() == current_platform:
			if current_platform.has_method("get_movement_delta"):
				position += current_platform.get_movement_delta()
		
	move_and_slide()
			
	position.round()
	
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >=0 
	if just_left_ledge:
			print("timer start")
			coyote_jump_timer.start()
	
	
	
func apply_gravity(delta):  
		if not is_on_floor() and current_platform == null:
			velocity += get_gravity() * delta	
func handle_jumping(delta):
		if is_on_floor() or coyote_jump_timer.time_left > 0.0:
			if Input.is_action_just_pressed("jump"):
				print("trying to jump")
				velocity.y = JUMP_VELOCITY
				coyote_jump_timer.stop()
		if not is_on_floor():
				if Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY / 2:
					velocity.y = JUMP_VELOCITY / 2
func handle_accelaration(direction, delta):
	if direction !=0:
		velocity.x = move_toward(velocity.x, speed * direction, ACCELARATION * delta)
func handle_friction(direction,delta):
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta) 
func handle_playersprite_flipping(direction):
	if direction > 0:
		player_sprite.flip_h = false
		player_direction = Vector2.RIGHT
	elif direction < 0: 
		player_sprite.flip_h = true
		player_direction = Vector2.LEFT
		
func handle_player_animation(direction):
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
			
	if Input.is_action_just_pressed("shoot") and can_shoot and not locked:
		if GameManager.health == 1: 
			animation_player.play("OneHeart")
		else : 
			shoot()
			print("shoot")	
	if Input.is_action_just_pressed("afformation") and not locked:
		locked = true
		play_animation("afformation")
		emit_signal("player_starting_to_heal")
		
			
	 
			
func play_animation(anim_name: String):
	print("Attempting to play:", anim_name)  # Debugging
	if player_sprite.animation != anim_name:  
		player_sprite.play(anim_name)
		print("Animation set to:", anim_name)
	else:
		print("Animation was already:", anim_name)



func _on_animated_sprite_2d_animation_finished():
	print("Animation finished: " + player_sprite.animation)
	if player_sprite.animation == "afformation":
		locked = false
		Helper.spawn_hearts(position, 1, 18)
		emit_signal("player_healing")
	if player_sprite.animation == "lifting":
			can_shoot = false
			print("playing run")
			player_sprite.play("run")
			
func _on_player_took_damage(damaging_object):
	
		
	if GameManager.health > 0 and not shooting:
			animation_player.play("hurt")
	elif  GameManager.health > 0 and shooting:
			animation_player.play("shooting")
	else: 
				Engine.time_scale = ENGINE_TIMESCALE_SLOWED
				animation_player.play("died")
				player_sprite.stop()
				player_sprite.play("dying")
				print("dying")
				velocity = Vector2.ZERO
				set_physics_process(false)  # Stop physics processing
				print(player_sprite.sprite_frames.get_animation_names(), "Playing dying animation:", player_sprite.animation)
				var kill_timer = 1.0
				if damaging_object and damaging_object.name == "green_slime": 
					kill_timer = 4.0
				
				await get_tree().create_timer(kill_timer).timeout  # Wait before restarting
				Engine.time_scale = ENGINE_TIMESCALE_DEFAULT
				GameManager.reset_game_state()
				
func shoot():
	can_shoot = false
	shooting = true
	var bullet = HEART_BULLET.instantiate()  # Create the bullet instance
	bullet.position = global_position + Vector2(0, -10)
	  # Adjust spawn position
	bullet.direction = player_direction
	print(bullet.position)
	GameManager.loose_life(1)

	get_parent().add_child(bullet)  # Add bullet to the scene
	await get_tree().create_timer(fire_rate).timeout  # Wait before next shot  # Wait before shooting again
	can_shoot = true
	shooting = false
		
