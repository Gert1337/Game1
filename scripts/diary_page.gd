extends Area2D
var picked_up: bool = false 

@onready var animation_player_diary: AnimationPlayer = $PickupSound/AnimationPlayer
@onready var note_ui = get_parent().get_node("Player/DialogBox")

var diary_notes = [
	{"title": "hhkj", "text": "I'm not sure I'll be a good Queen, i'm not even a good princess, I talk to much"},
	{"title": "A New Discovery", "text": "The second note reveals more secrets..."},
	{"title": "Dark Realizations", "text": "A third note, things are getting interesting..."},
	{"title": "The Truth", "text": "The final note, everything makes sense now!"},
	{"title": "The Truth", "text": "The final note, everything makes sense now!"},
	{"title": "The Truth", "text": "The final note, everything makes sense now!"}
]
func _ready() -> void:
	picked_up = false
	print("yrint to connect to ui note")
	if note_ui:
			print("connected to ui npte")
			GameManager.note_dismissed.connect(_on_note_dismissed)

func _on_body_entered(body: Node2D) -> void:
	if picked_up:
		print("tried picking up a second time")
		return
		
	if body is CharacterBody2D:
		picked_up = true
		animation_player_diary.play("pickup")
		
		if GameManager.diary_page_log != null:
			GameManager.add_diary_page_to_log()
		
		if note_ui and GameManager.diary_page_log < diary_notes.size():
				var note = diary_notes[GameManager.diary_page_index]
				GameManager.add_diary_page_to_que(note)
				GameManager.add_diary_page_to_storage(note)
				print("Added note to queue:", note.title)
		if not GameManager.showing_diary_page:
			show_note()
		else:
			return
						
func show_note():
	if GameManager.queued_notes.size() > 0 and not GameManager.showing_diary_page: 
		print("1qued:", GameManager.queued_notes)
		var note = GameManager.get_next_note()
		print("2qued:", GameManager.queued_notes)
		print(" show first", note.title, GameManager.showing_diary_page)
		note_ui.show_note(note["title"], note["text"])
		

				

				
func _on_note_dismissed():
	print("Note dismissed", GameManager.showing_diary_page)
	print(GameManager.queued_notes.size()," maybe no quesed")
	if GameManager.queued_notes.size() > 0: 
		show_note()
	else:
		print("no more notes")
