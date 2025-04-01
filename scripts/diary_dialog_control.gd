extends Control
@onready var title1: Label = $PanelContainer/Titel
@onready var text1: Label = $PanelContainer/Text




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_note()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):  # ui_accept is typically mapped to the Enter key by default
		hide_note()
	

func show_note(title: String, note_text: String):
	print("showing note")
	title1.text = title
	text1.text = note_text
	show()

func hide_note():
	hide()
