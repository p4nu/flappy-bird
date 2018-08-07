extends Position2D

const SCN_GROUND = preload("res://Entities/Ground/Ground.tscn")
const GROUND_WIDTH = 168
const AMOUNT_TO_FILL_GROUND = 2

onready var container = $Container

func _ready():
	for i in range(AMOUNT_TO_FILL_GROUND):
		spawn_and_move()

func spawn_ground():
	var new_ground = SCN_GROUND.instance()
	new_ground.position = position
	new_ground.connect("tree_exited", self, "spawn_and_move")
	container.call_deferred("add_child", new_ground)

func go_to_next_position():
	position = position + Vector2(GROUND_WIDTH, 0)

func spawn_and_move():
	spawn_ground()
	go_to_next_position()