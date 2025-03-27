extends Area2D

@export var speed: float = 100  # Speed of the bullet
@export var direction: Vector2 = Vector2.RIGHT  # Default direction
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
var max_distance: float = 410  # Set the maximum travel distance
var start_position: Vector2  # Store the starting position

func _ready():
	start_position = position
	if direction.x < 0:
		sprite_2d.flip_h = false 
	else: 
		sprite_2d.flip_h = true

func _process(delta):
	position += direction * speed * delta  # Move the bullet
	if position.distance_to(start_position) >= max_distance:
		queue_free()  # Remove the bullet from the scene


func _on_area_entered(area):
	print("i diss", area)
	if area.is_in_group("monsters"):
		print("shooting monster")  # If bullet hits a monster
		area.take_damage()  # Reduce monster health
		queue_free() 
