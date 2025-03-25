extends CanvasLayer

var score = 0 

var health = 5
@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel
@export var heart_texture: Texture  
@onready var health_container: HBoxContainer = $HBoxContainer
signal player_took_damage

func _ready():
	update_health_display()  # Sørger for, at UI starter med at vise hjerter

func _process(delta: float) -> void:
	score_label.text ="Coins: "  + str(score)

func add_point_to_score(): 
	score += 1
	score_label.text ="Coins: "  + str(score)
	print(score)

func emit_damage_signal():
	emit_signal("player_took_damage")

func loose_life(): 
	if health > 0:
		health -= 1
		update_health_display()
		emit_damage_signal()
	else: 
		print("Gameover")
		print(health)

func update_health_display():
	print("Updating health display") 
	# Fjern gamle hjerter
	for child in health_container.get_children():
		child.queue_free()

	# Tilføj nye hjerter
	for i in range(health):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT  # Holder billedets proportioner
		health_container.add_child(heart)  # Tilføj til UI
	
