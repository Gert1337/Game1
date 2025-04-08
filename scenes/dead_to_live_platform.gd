extends AnimatableBody2D
enum MovementType {
	NONE,
	VERTICAL,
	HORIZONTAL
}

@export_enum("None", "Vertical", "Horizontal") var selected_movement_type := "None"
var movement_type: MovementType = MovementType.NONE
@export var speed: float = 50.0

var direction := 1
var player_on_platform := false
var last_position: Vector2
var movement_delta: Vector2 = Vector2.ZERO

@onready var player_ref: CharacterBody2D = $"../Player"
@onready var ray_down: RayCast2D = $RayCast2DDown
@onready var ray_up: RayCast2D = $RayCast2D2Up
@onready var ray_left: RayCast2D = $RayCast2D2Left
@onready var ray_rigth: RayCast2D = $RayCast2D2Rigth
@onready var platform_sprite: AnimatedSprite2D = $Sprite2D




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_position = position
	if player_ref:
		player_ref.connect("player_healing", Callable(self, "_on_player_healing"))
		player_ref.connect("player_starting_to_heal", Callable(self, "_on_player_starting_to_heal"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if movement_type == MovementType.NONE:
		return

	# Calculate movement delta
	movement_delta = position - last_position
	last_position = position
	match  movement_type: 
		MovementType.VERTICAL: 
			if direction == 1 and ray_up.is_colliding(): 
				direction = -1 
			elif direction == -1 and ray_down.is_colliding():
				direction = 1
			position.y += direction * speed * delta
		
		
		MovementType.HORIZONTAL: 
			if direction == 1 and ray_rigth.is_colliding(): 
				direction = -1 
			elif direction == -1 and ray_left.is_colliding():
				direction = 1
			position.x += direction * speed * delta

		
func get_movement_delta() -> Vector2:
	return movement_delta
	
func _on_player_healing():
	if player_on_platform:
		platform_sprite.play("moving")
		match selected_movement_type:
			"Vertical":
				movement_type = MovementType.VERTICAL
			"Horizontal":
				movement_type = MovementType.HORIZONTAL
			_:
				movement_type = MovementType.NONE

func _on_player_starting_to_heal():
	print("player starting to heal")
	platform_sprite.play("comming_to_live")

	
		
func _on_player_dection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_on_platform = true
		body.current_platform = self

func _on_player_dection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_on_platform = false
		body.current_platform = null 
