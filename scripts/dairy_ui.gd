extends CanvasLayer

var current_page = 0 
var note_ui_instance
@onready var titel: Label = $CenterContainer/Panel/MarginContainer/TextControl/VBoxContainer/Titel
@onready var text: Label = $CenterContainer/Panel/MarginContainer/TextControl/VBoxContainer/Text
@onready var quanty: Label = $CenterContainer/Panel/MarginContainer/TextControl/HBoxContainer/Quanty
@onready var amount: Label = $CenterContainer/Panel/MarginContainer/TextControl/HBoxContainer/Amount




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
	quanty.text = str(current_page +1)
	amount.text = str(GameManager.diary_page_log)
	
func _input(event: InputEvent) -> void:
	if not visible:
		return
	var page_count =GameManager.diary_entries_storage.size()
	if event.is_action_pressed("diary_page_forward"):
			current_page = (current_page + 1) % page_count
			show_page(current_page)
	if event.is_action_pressed("diary_page_back"):
			current_page =(current_page - 1 + page_count) % page_count
			show_page(current_page)	
	
func hide_diary():
	hide()
	
	
