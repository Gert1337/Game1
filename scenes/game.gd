extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not RenderingServer:
		RenderingServer.set_default_clear_color( Color.html("5b0024")
)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
