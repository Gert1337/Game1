extends Area2D

@export var speed: float = 100  # Speed of the bullet
@export var direction: Vector2 = Vector2.RIGHT  # Default direction
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready():
	if direction.x < 0:
		sprite_2d.flip_h = false 
	else: 
		sprite_2d.flip_h = true

func _process(delta):
	position += direction * speed * delta  # Move the bullet


func _on_area_entered(area):
	print("i diss", area)
	if area.is_in_group("monsters"):
		print("shooting monster")  # If bullet hits a monster
		area.take_damage()  # Reduce monster health
		queue_free() 
