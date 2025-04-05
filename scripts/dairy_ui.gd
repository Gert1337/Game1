extends CanvasLayer

var current_page = 0 
var note_ui_instance
@onready var titel: Label = $CenterContainer/Panel/MarginContainer/TextControl/Titel
@onready var text: Label = $CenterContainer/Panel/MarginContainer/TextControl/Text




func _ready() -> void:
	hide()


func open_diary():
	if GameManager.diary_entries_storage.is_empty():
		return
	show()
	print("visible true")
	current_page = 0
	show_page(current_page)
	
	
func show_page(index:int):
	var entry = GameManager.diary_entries_storage[index]
	titel.text = entry.title
	text.text = entry.text
	
func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("diary_page_forward"):
		if current_page < GameManager.diary_entries_storage.size() - 1:
			current_page +=1
			show_page(current_page)
	if event.is_action_pressed("diary_page_back"):
		if current_page > 0:
			current_page -=1
			show_page(current_page)	
	if event.is_action_pressed("cancel"):
		print("cancel")
		hide()
	
	
	
