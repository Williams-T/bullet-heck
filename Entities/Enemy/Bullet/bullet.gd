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
var new_shape

var current_delta = 0.0
var turn_timer = randf_range(0.05,0.5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explo.emitting = false
	new_shape = (sh_tip.get_child(0) as CollisionShape2D).shape.duplicate()
	new_shape.size = Vector2(20,20)
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
	#smoke_trail.emitting = false
	sprite.visible = false
	speed = 0.0
	#new_shape.set_deferred('size', Vector2(20,20))
	sh_tip.get_child(0).set_deferred('shape', new_shape)
	sh_tip.position = Vector2(-5,0)
	explo.emitting = true
	await get_tree().create_timer(0.5).timeout
	if grabbed:
		Tracker.player.grabbed_entity = null
		#Tracker.player.change_state(1)
	queue_free()
	pass


func _on_body_entered(_body) -> void:
	if _body is CharacterBody2D:
		if _body.grabbing == false:
			print("player_bumped")
			modulate = Color.CADET_BLUE
			_body.jump_gauge = _body.max_jump
			#if _body.get_angle_to(self.position + Vector2(0, speed * 4.0).rotated(direction)) > 0.5:
			set_direction(_body.get_angle_to(self.position + Vector2(0, speed).rotated(direction)), 0)
		elif _body.grabbing == true:
			print("player_grabbed")
			modulate = Color.CORNFLOWER_BLUE
			_body.grabbed_entity = self
			grabbed = true
		pass
	pass



func _on_nose_body_entered(_body) -> void:
	if _body is CharacterBody2D:
		print("player hit")
		if grabbed:
			return
		if explo.emitting == false:
			explode()
		else:
			_body.hit(direction, speed)
	else:
		explode()
	pass # Replace with function body.
