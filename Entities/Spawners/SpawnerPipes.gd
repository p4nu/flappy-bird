extends Node2D

const SCN_PIPES = preload("res://Entities/Pipes/Pipes.tscn")
const PIPE_WIDTH = 26
const GROUND_HEIGHT = 56
const AMOUNT_TO_FILL_VIEW = 3

export var offset_x = 65
export var offset_y = 55

onready var container = $Container

func _ready():
	# Called when the node is added to the scene for the first time.
	go_to_first_position()
	
	for i in range(AMOUNT_TO_FILL_VIEW):
		spawn_and_move()

func go_to_first_position():
	var first_position = Vector2()
	first_position.x = get_viewport_rect().size.x + PIPE_WIDTH / 2
	first_position.y = rand_range(offset_y, get_viewport_rect().size.y - GROUND_HEIGHT - offset_y)
	position = first_position

func spawn_and_move():
	spawn_pipes()
	go_to_next_position()

func spawn_pipes():
	var new_pipes = SCN_PIPES.instance()
	new_pipes.position = position
	new_pipes.connect("tree_exited", self, "spawn_and_move")
	container.call_deferred("add_child", new_pipes)

func go_to_next_position():
	var next_position = position
	next_position.x += PIPE_WIDTH / 2 + offset_x + PIPE_WIDTH / 2
	next_position.y = rand_range(offset_y, get_viewport_rect().size.y - GROUND_HEIGHT - offset_y)
	position = next_position