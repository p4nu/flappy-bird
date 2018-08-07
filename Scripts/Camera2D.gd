extends Camera2D

# Let's make sure we find the bird just in case.
onready var bird = Utilities.get_main_node().get_node("Bird")

var x_offset = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	x_offset = bird.position.x - position.x

func _process(delta):
	position = Vector2(bird.position.x - x_offset, position.y)
	align()

func get_total_position():
	return position.x - x_offset
