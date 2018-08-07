extends RigidBody2D

export (int) var flap_force = 150
export (int) var move_speed = 50

func _ready():
	# Called when the node is added to the scene for the first time.
	linear_velocity = Vector2(move_speed, linear_velocity.y)

func _process(delta):
	if rotation_degrees < -30:
		rotation_degrees = -30
		angular_velocity = 0
	
	if linear_velocity.y > 0:
		angular_velocity = 1.5

func _unhandled_input(event):
	if Input.is_action_just_pressed("click"):
		flap()

func flap():
	linear_velocity = Vector2(linear_velocity.x, -flap_force)
	angular_velocity = -3