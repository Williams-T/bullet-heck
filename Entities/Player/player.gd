extends CharacterBody2D

var move_speed = 300.0
var jump_gauge = 50
var max_jump = 50
var accel = 50.0
var decel = 100.0
var last_hit = [0,0]

var grabbed_entity = null

var grounded = true
var airborne = false
var piloting = false
var grabbing = false

@onready var st_grounded = $StateMachine/Grounded
@onready var st_airborne = $StateMachine/Airborne
@onready var st_piloting = $StateMachine/Piloting


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2.ZERO  # Initialize velocity vector
	Tracker.set_player(self)

func hit(direction, speed):
	last_hit = [direction, speed]
	pass

func _physics_process(_delta):
	if grounded:
		st_grounded.iterate(self)
	elif airborne:
		st_airborne.iterate(self)
	elif piloting:
		st_piloting.iterate(self)
	if grabbing:
		modulate = Color.CORAL
	elif !grabbing and modulate != Color.WHITE:
		modulate = Color.WHITE

func change_state(state_id : int):
	clear_states()
	match state_id:
		0:
			grounded = true
		1:
			airborne = true
		2:
			piloting = true

func clear_states():
	grounded = false
	airborne = false
	piloting = false
