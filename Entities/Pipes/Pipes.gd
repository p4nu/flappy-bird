extends StaticBody2D

onready var right = $Position2D
onready var camera = Utilities.get_main_node().get_node("Camera2D")

func _init():
	set_process(false)

func _process(delta):
	if right.global_position.x <= camera.global_position.x:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	set_process(true)
