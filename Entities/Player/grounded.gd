extends Node

func iterate(player : CharacterBody2D):
	if !player.is_on_floor():
		player.change_state(1)
	if player.jump_gauge < player.max_jump:
		player.jump_gauge = player.max_jump
		UiManager.adjust_bar(1.0)
	if Input.is_action_pressed("ui_up"):
		player.change_state(1)
		# Handle horizontal movement (WASD)
	if Input.is_action_pressed("ui_left"):
		player.velocity = player.velocity.lerp(Vector2(-player.move_speed, 0), 0.1)
	elif Input.is_action_pressed("ui_right"):
		player.velocity = player.velocity.lerp(Vector2(player.move_speed, 0), 0.1)
	elif !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		player.velocity = player.velocity.lerp(Vector2.ZERO, 0.1)
	if abs(player.velocity.x) < 0.05:
		player.velocity.x = 0
	if player.last_hit != [0,0]:
		player.velocity = Vector2(player.last_hit[0],0).rotated(player.last_hit[1]*randf_range(-1.0, 1.0))
		player.last_hit = [0,0]

	# Move the player
	player.move_and_slide()
