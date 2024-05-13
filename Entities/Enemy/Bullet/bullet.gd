extends Area2D
class_name Bullet

var mode = 0
var direction = 0.0
var speed = 100

var homing = false
var turn_angle = randf_range(0.01, 0.05)
var player_dir = 1.0
var grabbed = false

@onready var sh_tip = $Nose
@onready var body = $Body
@onready var explo = $Explosion
@onready var smoke_trail = $CPUParticles2D
@onready var sprite = $Sprite2D

var current_delta = 0.0
var turn_timer = randf_range(0.05,0.5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_direction(_direction, in_place = -1):
	direction = _direction
	if in_place == -1:
		rotate(direction)
		position += Vector2(10,0).rotated(direction)
	else:
		rotation = direction
	pass

func set_speed(_speed):
	speed = _speed
	pass

func set_homing(check: bool):
	if check == true:
		homing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += Vector2(speed * delta,0).rotated(direction)
	current_delta += delta
	if current_delta > turn_timer:
		turn_timer = randf_range(0.05,0.1)
		current_delta = 0.0
	if homing == true:
		player_dir = check_player_direction()
		set_direction(direction + (turn_angle * player_dir), 0)
	elif mode == 1:
		set_direction(direction + turn_angle, 0)
	pass

func check_player_direction():
	var player_position = Tracker.player.position
	var to_player = self.get_angle_to(player_position)
	if to_player > 0.0:
		return 1.0
	return -1.0
	

func explode() -> void:
	explo.emitting = true
	smoke_trail.emitting = false
	sprite.visible = false
	speed = 0.0
	await explo.finished
	if grabbed:
		Tracker.player.grabbed_entity = null
		#Tracker.player.change_state(1)
	queue_free()
	pass


func _on_body_entered(body) -> void:
	if body is CharacterBody2D:
		if body.grabbing == false:
			print("player_bumped")
			modulate = Color.CADET_BLUE
			body.jump_gauge = body.max_jump
		elif body.grabbing == true:
			print("player_grabbed")
			modulate = Color.CORNFLOWER_BLUE
			body.grabbed_entity = self
			grabbed = true
		pass
	pass



func _on_nose_body_entered(body) -> void:
	if body is CharacterBody2D:
		print("player hit")
		if grabbed:
			return
	explode()
	pass # Replace with function body.
