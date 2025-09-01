extends TextureButton

@export var canvas_items: Array[CanvasItem]

const GUI_VISIBILITY_HIDDEN = preload("res://examples/collision_layers_and_masks/components/GuiVisibilityHidden.svg")
const GUI_VISIBILITY_VISIBLE = preload("res://examples/collision_layers_and_masks/components/GuiVisibilityVisible.svg")

var nodes_being_animated: int = 0

func _ready():
	texture_normal = GUI_VISIBILITY_VISIBLE

	toggled.connect(func(new_visibility):
		texture_normal = GUI_VISIBILITY_VISIBLE if new_visibility else GUI_VISIBILITY_HIDDEN

		disabled = true
		if not new_visibility:
			for canvas_item in canvas_items:
				canvas_item.set_physics_process(false)
				if canvas_item is RigidBody2D:
					canvas_item.freeze = true

		await await_all(canvas_items.map(animate_canvas_item.bind(new_visibility)))

		if new_visibility:
			for canvas_item in canvas_items:
				canvas_item.set_physics_process(true)
				if canvas_item is RigidBody2D:
					canvas_item.freeze = false
		disabled = false
	)

func animate_canvas_item(canvas_item: CanvasItem, new_visibility: bool) -> Signal:
	if canvas_item is Control:
		canvas_item.pivot_offset = canvas_item.size / 2.0

	var target_size = Vector2.ONE if new_visibility else Vector2.ZERO
	return create_tween().tween_property(canvas_item, "scale", target_size, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN).finished

func await_all(signals):
	for a_signal in signals:
		await a_signal
