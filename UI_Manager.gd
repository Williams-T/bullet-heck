extends Node

var jump_bar : ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jump_bar = get_parent().get_node('/root/Node2D/CanvasLayer/HBoxContainer/ColorRect')
	pass # Replace with function body.

func adjust_bar(percent : float):
	var full_size = 650.0
	jump_bar.custom_minimum_size.y = full_size * percent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	pass
