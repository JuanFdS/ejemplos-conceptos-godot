@tool
extends Control

signal collision_flags_changed(new_collision_flags)

@export_range(1, 32) var layers_shown: int = 8:
	set(new_value):
		layers_shown = new_value
		if not is_node_ready():
			await ready
		_update_buttons_shown()
@export_flags_2d_physics var collision_flags: int :
	set(new_collision_flags):
		collision_flags = new_collision_flags
		if not is_node_ready():
			await ready
		var buttons = collision_layer_buttons()
		for i in range(buttons.size()):
			buttons[i].button_pressed = get_bit_at_position(collision_flags, i) == 1

@export var title: String :
	set(new_title):
		title = new_title
		if not is_node_ready():
			await ready
		title_label.text = title

@onready var button_containers = [%"1to8", %"9to16", %"17to24", %"24to32"]
@export_tool_button("Regenerate buttons")
var _regenerate_buttons = regenerate_buttons

@onready var show_more_button: Button = %ShowMoreButton
@onready var title_label: Label = %TitleLabel

func _ready():
	regenerate_buttons()
	_update_buttons_shown()
	title_label.text = title
	show_more_button.toggled.connect(on_show_more_button_toggled)

func on_show_more_button_toggled(new_value: bool):
	show_more_button.text = "^" if new_value else "v"
	%"17to24".visible = new_value
	%"24to32".visible = new_value

func collision_layer_buttons():
	var buttons = []

	for container in button_containers:
		for child in container.get_children():
			buttons.push_back(child)

	return buttons

func regenerate_buttons():
	for container in button_containers:
		for child in container.get_children():
			container.remove_child(child)
			child.queue_free()
	for i in range(0, 32):
		var button = Button.new()
		button.toggle_mode = true
		button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		button.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		button.custom_minimum_size = Vector2(30, 30)
		button.name = str(i+1)
		button.text = str(i+1)
		var parent_node: Control = button_containers[i / 8]
		parent_node.add_child(button)
		button.owner = owner
		button.toggled.connect(func(new_toggle_value):
			collision_flags = set_bit(collision_flags, i, new_toggle_value)
			collision_flags_changed.emit(collision_flags)
		)

func set_bit(number: int, pos: int, new_value: bool) -> int:
	if new_value:
		return number | (1 << pos)
	else:
		return number & ~(1 << pos)

func get_bit_at_position(number: int, pos: int) -> int:
	var mask = 1 << pos
	var masked_value = number & mask
	var the_bit = masked_value >> pos
	
	return the_bit

func _update_buttons_shown():
	var buttons = collision_layer_buttons()
	for i in range(buttons.size()):
		buttons[i].visible = i < layers_shown
	show_more_button.visible = layers_shown > 16
