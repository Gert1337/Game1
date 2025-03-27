extends Area2D

@export var speed: float = 100  # Speed of the bullet
@export var direction: Vector2 = Vector2.RIGHT  # Default direction

func _process(delta):
	position += direction * speed * delta  # Move the bullet


func _on_area_entered(area):
	print("i diss", area)
	if area.is_in_group("monsters"):
		print("shooting monster")  # If bullet hits a monster
		area.take_damage()  # Reduce monster health
		queue_free() 
