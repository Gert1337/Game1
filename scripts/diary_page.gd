extends Area2D
var picked_up: bool = false 

@onready var animation_player_diary: AnimationPlayer = $PickupSound/AnimationPlayer
@onready var note_ui = get_parent().get_node("Player/DialogBox")

var diary_notes = [
	{"title": "A Heart That Burns", "text": "I was told a princess must guard her heart,
	but mine refuse to stay quite.
	It burns like starlight, wild and defiant. 
	When I need it, I can cast it forward and, and when I do, it cuts through shadows like they were never real.
	Maybe some parts of me are stronger than I thought."},
	{"title": "The Key Is Real", "text": "There is a door in this strange dream. 
	Tall, ancient, and stubborn as stone. 
	I believe it leads to the waking world — to myself. 
	It calls to me, quiet but certain — like it wants me to leave. 
	But it won’t open... Not without the key.
	And the key… it’s hiding. Like it’s waiting for me to believe I deserve it."},
	{"title": "When I Let Go, I Breathe", "text": "This place takes pieces of me.
	But when I rest — just rest — I feel something return.
	I sat down today, and the silence wrapped around me like a soft cloak.
	I think I felt whole again, even just for a moment.
	Maybe stillness can be healing."},
	{"title": "Love has weight", "text": "Some paths lead nowhere, some crumble beneath my feet.
	But I have learned this:
	The stones that seem lifeless may only be sleeping.
	When I sat down, and shared my love, 
	it stirred — not from force, but from my best wishes.
	Even here, love has weight."},
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
