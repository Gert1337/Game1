extends Area2D
var picked_up: bool = false 

@onready var animation_player_diary: AnimationPlayer = $PickupSound/AnimationPlayer
@onready var note_ui = get_parent().get_node("Player/DialogBox")

var diary_notes = [
	{"title": "The Beginning", "text": "This is the first diary entry..."},
	{"title": "A New Discovery", "text": "The second note reveals more secrets..."},
	{"title": "Dark Realizations", "text": "A third note, things are getting interesting..."},
	{"title": "The Truth", "text": "The final note, everything makes sense now!"}
]

func _on_body_entered(body: Node2D) -> void:
	if picked_up:
		print("tried picking up a second time")
		return
	picked_up = true
	animation_player_diary.play("pickup")
	if GameManager.diary_page_log != null:
		GameManager.add_diary_page_to_log()
	if note_ui:
		if GameManager.diary_page_log < diary_notes.size():
			print("ui")
			var note = diary_notes[GameManager.diary_page_log]
			note_ui.show_note(note.title, note.text)
