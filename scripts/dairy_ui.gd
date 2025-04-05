extends Control

var current_page = 0 
var note_ui_instance
@onready var titel: Label = $CanvasLayer/CenterContainer/Panel/MarginContainer/PanelContainer2/Titel
@onready var text: Label = $CanvasLayer/CenterContainer/Panel/MarginContainer/PanelContainer2/Text



func _ready() -> void:
	visible = false


func open_diary():
	if GameManager.diary_entries_storage.is_empty():
		return
	visible = true
	print("visible true")
	show_page(current_page)
	current_page = 0
	
func show_page(index:int):
	var entry = GameManager.diary_entries_storage[index]
	titel.text = entry.title
	text.text = entry.text
		
	
	
	
