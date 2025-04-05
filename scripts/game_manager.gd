extends CanvasLayer

var diary_page_log = 0 
var diary_page_index = -1
var showing_diary_page = false
var queued_notes: Array = [] 
var diary_entries_storage = []
var diary_visible = false
var health = 5
@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel
@export var heart_texture: Texture  
@onready var health_container: HBoxContainer = $HBoxContainer
signal player_took_damage(damaging_object)
signal note_dismissed
const DAIRY_UI = preload("res://scenes/dairy_UI.tscn")
var diary_ui_instance
var input_blocked: bool = false
var input_block_timer: Timer
var block_timer_wait_time: float = 0.3

func _ready():
	update_health_display()
	input_block_timer = Timer.new()
	input_block_timer.one_shot = true
	input_block_timer.wait_time = block_timer_wait_time  # Cooldown duration
	add_child(input_block_timer)
	input_block_timer.timeout.connect(_on_input_block_timeout)
	
func reset_game_state():
	diary_page_log = 0
	diary_page_index = -1
	diary_entries_storage.clear()
	queued_notes.clear()
	showing_diary_page = false
	health = 5 
	update_health_display()
	get_tree().reload_current_scene()
	
func _on_input_block_timeout() -> void:
	input_blocked = false
	
func _input(event: InputEvent) -> void:
	if input_blocked:
		return
	if event.is_action("Open Diary"):
		input_blocked = true
		input_block_timer.start()
		if not diary_visible: 
			open_diary()
			diary_visible = true
		else: 
			diary_ui_instance.hide_diary()
			diary_visible = false
	if event.is_action("cancel"):
		diary_ui_instance.hide_diary()
		diary_visible = false

func open_diary():
		diary_ui_instance = DAIRY_UI.instantiate()
		get_tree().current_scene.add_child(diary_ui_instance)
	 # Add it to the scene tree (or add it to a specific parent node)
		diary_ui_instance.open_diary()
		diary_visible = true

func _process(delta: float) -> void:
	score_label.text ="Pages found: "  + str(diary_page_log)
	

func add_diary_page_to_log(): 
	add_to_diary_index()
	diary_page_log += 1
	score_label.text ="Pages found: "  + str(diary_page_log)
	print(diary_page_log)
func add_to_diary_index(): 
	diary_page_index += 1
	
func add_diary_page_to_storage(note: Dictionary):
	diary_entries_storage.append(note)
	print("Diary Storage:", diary_entries_storage)

func add_diary_page_to_que(note: Dictionary):
	queued_notes.append(note)
	print("Added note, in gamemanager:", note.title, "Queue size:", queued_notes.size())
func get_next_note() -> Dictionary:
	if queued_notes.size() > 0 and not showing_diary_page:
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
		print("gameover")
		
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
	
