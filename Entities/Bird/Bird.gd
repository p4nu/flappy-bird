extends RigidBody2D

signal state_changed

enum State {
	STATE_FLYING,
	STATE_FLAPPING,
	STATE_FALLING,
	STATE_GROUNDED
}

export (int) var flap_force = 150
export (int) var move_speed = 50

onready var animation_player = $AnimationPlayer

var current_state

func _ready():
	current_state = FlyingState.new(self)
	connect("body_entered", self, "_on_body_enter")

func _on_body_enter(other):
	if current_state.has_method("_on_body_enter"):
		current_state._on_body_enter(other)

func _process(delta):
	current_state._process(delta)

func _input(event):
	current_state._input(event)

func set_state(new_state):
	if current_state.has_method("exit"):
		current_state.exit()
	
	match new_state:
		STATE_FLYING:
			current_state = FlyingState.new(self)
		STATE_FLAPPING:
			current_state = FlappingState.new(self)
		STATE_FALLING:
			current_state = FallingState.new(self)
		STATE_GROUNDED:
			current_state = GroundedState.new(self)
		_:
			print("Bird.set_state() Error: State not found!")
			get_tree().quit()
	
	emit_signal("state_changed")

func get_state():
	match current_state:
		STATE_FLYING:
			return STATE_FALLING
		STATE_FLAPPING:
			return STATE_FLAPPING
		STATE_FALLING:
			return STATE_FALLING
		STATE_GROUNDED:
			return STATE_GROUNDED
		_:
			print("Bird.get_state() Error: State not found!")
			get_tree().quit()

class FlyingState:
	
	var bird
	var animated_sprite
	
	func _init(bird):
		# Called when this class gets instanced.
		self.bird = bird
		animated_sprite = bird.get_node("AnimatedSprite")
		bird.gravity_scale = 0
		bird.linear_velocity = Vector2(bird.move_speed, bird.linear_velocity.y)
		bird.animation_player.play("Flying")
		bird.set_process(false)
		bird.set_process_input(false)
	
	func exit():
		bird.animation_player.stop()
		bird.set_process(true)
		bird.set_process_input(true)
		bird.gravity_scale = 1
		animated_sprite.position = Vector2(0, 0)

class FlappingState:
	
	var bird
	
	func _init(bird):
		# Called when this class gets instanced
		self.bird = bird
		flap()
	
	func _process(delta):
		if bird.rotation_degrees < -30:
			bird.rotation_degrees = -30
			bird.angular_velocity = 0
	
		if bird.linear_velocity.y > 0:
			bird.angular_velocity = 1.5

	func _input(event):
		if Input.is_action_just_pressed("click"):
			flap()

	func flap():
		bird.linear_velocity = Vector2(bird.linear_velocity.x, -bird.flap_force)
		bird.angular_velocity = -3
		bird.animation_player.play("Flapping")
	
	func _on_body_enter(other):
		if other.is_in_group(Game.GROUP_PIPES):
			bird.set_state(STATE_FALLING)
		elif other.is_in_group(Game.GROUP_GROUNDS):
			bird.set_state(STATE_GROUNDED)
		pass

class FallingState:
	
	var bird
	
	func _init(bird):
		# Called when this class gets instanced.
		self.bird = bird
		bird.set_process(false)
		bird.set_process_input(false)
		bird.linear_velocity = Vector2(0, 0)
		bird.angular_velocity = 2
		var first_collision = bird.get_colliding_bodies()[0]
		bird.add_collision_exception_with(first_collision)
	
	func _on_body_enter(other):
		if other.is_in_group(Game.GROUP_GROUNDS):
			bird.set_state(bird.STATE_GROUNDED)

class GroundedState:
	
	var bird
	
	func _init(bird):
		# Called when this class gets instanced.
		self.bird = bird
		bird.set_process(false)
		bird.set_process_input(false)
		bird.linear_velocity = Vector2(0, 0)
		bird.angular_velocity = 0
