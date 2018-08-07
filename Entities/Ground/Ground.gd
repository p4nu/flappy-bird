extends StaticBody2D

onready var camera = Utilities.get_main_node().get_node("Camera2D")
onready var right_corner = $Position2D

func _init():
	set_process(false)

func _process(delta):
	if right_corner.global_position.x <= camera.position.x:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	set_process(true)
