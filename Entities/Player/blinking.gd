extends Node

var move_speed = 200

func iterate(player : CharacterBody2D):
	player.jump_gauge -= 0.3
	UiManager.adjust_bar(float(player.jump_gauge) / float(player.max_jump))
	if Input.is_action_just_released('blink') or player.jump_gauge <= 0.0:
		if player.is_on_floor():
			player.change_state(0)
		else:
			player.change_state(1)
	if player.grabbed_entity != null:
		player.change_state(2)
	if Input.is_action_pressed("grab"):
		player.grabbing = true
	else:
		player.grabbing = false
	if Input.is_action_pressed("ui_up"):
		player.velocity = player.velocity.lerp(Vector2(0.0, -move_speed), 0.1)
		pass
	if Input.is_action_pressed("ui_down"):
		player.velocity = player.velocity.lerp(Vector2(0.0, move_speed), 0.1)
		pass
		# Handle horizontal movement (WASD)
	if Input.is_action_pressed("ui_left"):
		player.velocity = player.velocity.lerp(Vector2(-move_speed, 0.0), 0.1)
		#player.velocity = player.velocity.lerp(Vector2(-player.move_speed, 0), 0.1)
		pass
	elif Input.is_action_pressed("ui_right"):
		player.velocity = player.velocity.lerp(Vector2(move_speed, 0.0), 0.1)
		#player.velocity = player.velocity.lerp(Vector2(player.move_speed, 0), 0.1)
		pass
	elif !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right") \
	and !Input.is_action_pressed('ui_up') and !Input.is_action_pressed('ui_down'):
		player.velocity = player.velocity.lerp(Vector2.ZERO, 0.1)
		pass
	
	if abs(player.velocity.x) < 0.05:
		player.velocity.x = 0
	
	if player.last_hit != [0,0]:
		player.velocity = Vector2(player.last_hit[0],0).rotated(player.last_hit[1]*randf_range(-1.0, 1.0))
		player.last_hit = [0,0]

	# Move the player
	player.move_and_slide()
