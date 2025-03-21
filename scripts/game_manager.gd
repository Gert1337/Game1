extends CanvasLayer

var score = 0 

var health = 5
@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel



func _process(delta: float) -> void:
	score_label.text = str(score) + "coins"
	health_label.text = str(health) + "life"
	
func add_point_to_score(): 
	score += 1
	score_label.text = str(score) + "coins"
	print(score)
	
func loose_life(): 
	health -= 1
	health.text = str(health) + "life"
	print(score)
	
