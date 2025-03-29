extends Area2D
@onready var camera = get_parent().find_child("Camera2D")  # Find the camera in the parent

func zoom_to( duration: float = 0.5):
	var target_zoom = Vector2(6.0, 6.0)
	if camera.zoom == Vector2(6.0, 6.0):
		target_zoom = Vector2(3.3, 3.3)  # Zoom out
	else:
		target_zoom = Vector2(6.0, 6.0)  # Zoom in
		
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "zoom", target_zoom, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)





	

	
	


func _on_body_exited(body: Node2D) -> void:
	zoom_to()
