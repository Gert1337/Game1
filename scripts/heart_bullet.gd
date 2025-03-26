extends Area2D

@export var speed: float = 500  # Speed of the bullet
@export var direction: Vector2 = Vector2.RIGHT  # Default direction

func _process(delta):
	position += direction * speed * delta  # Move the bullet

func _on_body_entered(body):
	if body.is_in_group("monsters"):  # If bullet hits a monster
		body.take_damage()  # Reduce monster health
		queue_free()  # Destroy bullet on hit

func _on_area_entered(area):
	queue_free()  # Destroy the bullet if it hits something
