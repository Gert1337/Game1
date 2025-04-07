extends CanvasLayer
@onready var title1: Label = $PanelContainer/Titel
@onready var text1: Label = $PanelContainer/Text




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_note()
		
	
func _process(delta: float) -> void:
	if  Input.is_action_just_pressed("CloseDiaryPage"): 
		print("c just pressed")
		print(GameManager.showing_diary_page)
		if GameManager.showing_diary_page:
			hide_note()
			GameManager.note_dismissed.emit()
	

func show_note(title: String, note_text: String):
	
		print("Showing note UI:", title)
		title1.text = title
		text1.text = note_text
		show()
		GameManager.showing_diary_page = true
		


func hide_note():
	print("Hiding")
	hide()
	GameManager.showing_diary_page = false
