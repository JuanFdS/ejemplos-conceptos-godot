extends CanvasLayer

@onready var go_up: BaseButton = %GoUp
@onready var go_down: BaseButton = %GoDown
@onready var pause: BaseButton = %Pause
@onready var reset: BaseButton = %Reset

@onready var camera_2d: Camera2D = %Camera2D

func _ready():
	pause.toggled.connect(func(new_value):
		get_tree().paused = new_value
	)
	reset.pressed.connect(func():
		get_tree().reload_current_scene()
	)


func _process(delta: float) -> void:
	if go_up.is_hovered():
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			go_up.modulate = Color.WEB_GRAY
			camera_2d.position.y = move_toward(
				camera_2d.position.y,
				camera_2d.limit_top,
				delta * 400.0)
	else:
		go_up.modulate = Color.WHITE
	if go_down.is_hovered():
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			go_down.modulate = Color.WEB_GRAY
			camera_2d.position.y = move_toward(
				camera_2d.position.y,
				camera_2d.limit_bottom - camera_2d.get_viewport_rect().size.y,
				delta * 400.0)
	else:
			go_down.modulate = Color.WHITE
