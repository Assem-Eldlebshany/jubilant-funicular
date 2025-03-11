extends VehicleBody3D

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@export var MAX_STEER = 0.9
@export var ENGINE_POWER = 300
@export var LOOK_BACK_ROTATION = 180  # Rotation in degrees for looking back

var looking_back = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Vehicle controls
	steering = move_toward(steering, Input.get_axis("move_right", "move_left") * MAX_STEER, delta * 10)
	engine_force = Input.get_axis("move_back", "move_forward") * ENGINE_POWER
	
	# Camera follows car's rotation naturally, no mouse input needed
	
	# Look-back camera functionality
	if Input.is_action_pressed("look_back"):  # Assuming "G" is mapped to "look_back"
		if not looking_back:
			# Store current rotation before looking back
			twist_pivot.rotate_y(deg_to_rad(LOOK_BACK_ROTATION))
			looking_back = true
	elif looking_back:
		# Return to normal view when "G" is released
		twist_pivot.rotate_y(deg_to_rad(-LOOK_BACK_ROTATION))
		looking_back = false
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
