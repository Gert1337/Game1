extends Control
@onready var title1: Label = $PanelContainer/Titel
@onready var text1: Label = $PanelContainer/Text

signal note_dismissed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_note()
		
	
func _process(delta: float) -> void:
	if GameManager.showing_diary_page and Input.is_action_just_pressed("CloseDiaryPage"): 
		print("c just pressed")
		hide_note()
		emit_signal("note_dismissed")
	

func show_note(title: String, note_text: String):
	
		print("Showing note UI:", title)
		title1.text = title
		text1.text = note_text
		show()
		


func hide_note():
	print("Hiding")
	hide()
