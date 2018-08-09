extends RigidBody2D

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

func _process(delta):
	current_state._process(delta)

func _unhandled_input(event):
	current_state._unhandled_input(event)

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
	
	func _init(bird):
		# Called when this class gets instanced.
		self.bird = bird
		bird.gravity_scale = 0
		bird.linear_velocity = Vector2(bird.move_speed, bird.linear_velocity.y)
		bird.animation_player.play("Flying")
		bird.set_process(false)
		bird.set_process_unhandled_input(false)
	
	func exit():
		bird.gravity_scale = 1

class FlappingState:
	
	var bird
	
	func _init(bird):
		# Called when this class gets instanced
		self.bird = bird
		bird.linear_velocity = Vector2(bird.move_speed, bird.linear_velocity.y)
	
	func _process(delta):
		if bird.rotation_degrees < -30:
			bird.rotation_degrees = -30
			bird.angular_velocity = 0
	
		if bird.linear_velocity.y > 0:
			bird.angular_velocity = 1.5

	func _unhandled_input(event):
		if Input.is_action_just_pressed("click"):
			flap()

	func flap():
		bird.linear_velocity = Vector2(bird.linear_velocity.x, -bird.flap_force)
		bird.angular_velocity = -3
		bird.animation_player.play("Flapping")

class FallingState:
	
	var bird
	
	func _init(bird):
		# Called when this class gets instanced.
		self.bird = bird

class GroundedState:
	
	var bird
	
	func _init(bird):
		# Called when this class gets instanced.
		self.bird = bird