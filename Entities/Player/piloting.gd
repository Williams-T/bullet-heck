extends Node


# Called when the node enters the scene tree for the first time.
func iterate(player : CharacterBody2D):
	if  !Input.is_action_pressed('grab') or player.grabbed_entity == null:
		player.grabbed_entity = null
		player.change_state(1)
	else:
		print("%s, %s" % [player.position, player.grabbed_entity.position])
		player.global_position = (player.grabbed_entity as Bullet).global_position + Vector2(0, -10)
		player.global_rotation = (player.grabbed_entity as Bullet).global_rotation
	if Input.is_action_pressed('ui_left') and player.grabbed_entity != null:
		player.grabbed_entity.set_direction(player.grabbed_entity.direction - 0.05, 0)
		pass
	if Input.is_action_pressed('ui_right') and player.grabbed_entity != null:
		player.grabbed_entity.set_direction(player.grabbed_entity.direction + 0.05, 0)
		pass
