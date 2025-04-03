extends CanvasLayer

var diary_page_log = 0 
var showing_diary_page = false
var queued_notes: Array = [] 
var health = 5
@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel
@export var heart_texture: Texture  
@onready var health_container: HBoxContainer = $HBoxContainer
signal player_took_damage(damaging_object)


func _ready():
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	update_health_display()  # Sørger for, at UI starter med at vise hjerter
	

func _process(delta: float) -> void:
	score_label.text ="Pages found: "  + str(diary_page_log)


func add_diary_page_to_log(): 
	diary_page_log += 1
	score_label.text ="Pages found: "  + str(diary_page_log)
	print(diary_page_log)

func add_diary_page_to_que(note: Dictionary):
	queued_notes.append(note)
	print("Added note, in gamemanager:", note.title, "Queue size:", queued_notes.size())
func get_next_note() -> Dictionary:
	if queued_notes.size() > 0:
		return queued_notes.pop_front()
	return {}

func emit_damage_signal(object):
	emit_signal("player_took_damage",object )

func loose_life(amount, object = null): 
	if health > 0:
		health -= amount
		update_health_display()
		emit_damage_signal(object)
	else: 
		print("Gameover")
		print(health)
func gain_life(amount): 
		health += amount
		update_health_display()

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
	
