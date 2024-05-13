extends Area2D

var bullet = preload("res://Entities/Enemy/Bullet/bullet.tscn")
var delta_count = 0.0
var current_angle = 0.0
var spread = 270.0 # full spread
var gap = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn_pattern(quantity, homing, gap = 0.0):
	var bullets = []
	var angle_inc = (spread - gap) / float(quantity)
	for i in range(quantity):
		var new_bullet = spawn_bullet()
		add_child(new_bullet)
		new_bullet.set_speed(100)
		new_bullet.set_direction(current_angle)
		new_bullet.set_homing(homing)
		current_angle += angle_inc
	

func spawn_bullet() -> Bullet:
	var bullet_instance : Bullet = bullet.instantiate()
	return bullet_instance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta_count += delta
	if delta_count > 1.5:
		delta_count = 0.0
		spawn_pattern(13, false, 265.0)
	pass
