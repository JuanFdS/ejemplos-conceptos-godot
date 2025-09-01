extends Control

enum CollisionType {
	Layer,
	Mask
}

@export_range(1, 32) var layers_shown: int = 8:
	set(new_value):
		layers_shown = new_value
		if not is_node_ready():
			await ready
		collision_layers_editor.layers_shown = layers_shown
@export var collision_object: CollisionObject2D
@export var collision_type: CollisionType = CollisionType.Layer
@onready var collision_layers_editor: PanelContainer = $CollisionLayersEditor

func _ready():
	var collision_type_name: String
	match collision_type:
		CollisionType.Mask:
			collision_layers_editor.collision_flags = collision_object.collision_mask
			collision_type_name = "Mask"
		CollisionType.Layer:
			collision_layers_editor.collision_flags = collision_object.collision_layer
			collision_type_name = "Layer"

	collision_layers_editor.title = "%s's %s" % [
		collision_object.name,
		collision_type_name
	]
	collision_layers_editor.collision_flags_changed.connect(func(collision_flags):
		match collision_type:
			CollisionType.Mask:
				collision_object.collision_mask = collision_flags
			CollisionType.Layer:
				collision_object.collision_layer = collision_flags
	)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var left_x = collision_layers_editor.get_rect().position.x
	var right_x = collision_layers_editor.get_rect().end.x
	var center_y = collision_layers_editor.get_rect().get_center().y
	var left_pos = Vector2(left_x, center_y)
	var right_pos = Vector2(right_x, center_y)
	var target_point = make_canvas_position_local(collision_object.get_global_transform_with_canvas().origin)

	var origin_point: Vector2
	if left_pos.distance_squared_to(target_point) < right_pos.distance_squared_to(target_point):
		origin_point = left_pos
	else:
		origin_point = right_pos

	var color: Color = Color(Color.BLACK, 0.7)
	draw_line(origin_point, target_point, color, 5.0, true)
	draw_circle(target_point, 12.0, color)
