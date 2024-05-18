extends Node

func iterate(player : CharacterBody2D):
	if player.grabbed_entity != null:
		player.change_state(2)
	if Input.is_action_pressed("grab"):
		player.grabbing = true
	else:
		player.grabbing = false
	#if !Input.is_action_pressed("ui_up") or player.jump_gauge < 1:
	if !Input.is_action_just_pressed("ui_up"):
		if player.velocity.y < player.move_speed:
			player.velocity.y += 33
	if Input.is_action_just_released('ui_up'):
		player.velocity.y += -(player.velocity.y / 1.5)
	#if Input.is_action_pressed("ui_up"):
		#if player.jump_gauge > 0:
			#player.velocity.y = -300
			#player.jump_gauge -= 1
			#UiManager.adjust_bar(float(player.jump_gauge) / float(player.max_jump))
		# Handle horizontal movement (WASD)
	if Input.is_action_pressed("ui_left"):
		player.velocity = player.velocity.lerp(Vector2(-player.move_speed, 0), 0.05)
	elif Input.is_action_pressed("ui_right"):
		player.velocity = player.velocity.lerp(Vector2(player.move_speed, 0), 0.05)
	if Input.is_action_just_pressed("blink"):
		player.change_state(4)
	#elif !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		#player.velocity = player.velocity.lerp(Vector2.ZERO, 0.1)
	if abs(player.velocity.x) < 0.05:
		player.velocity.x = 0
	#if player.last_hit != [0,0]:
		#player.velocity += Vector2(player.last_hit[0],0).rotated(player.last_hit[1])
		#player.last_hit = [0,0]
	# Move the player
	player.move_and_slide()
	if player.is_on_floor():
		player.change_state(0)
