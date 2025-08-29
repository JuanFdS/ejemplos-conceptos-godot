extends Node2D

@export var min_configurable_fps: int = 1
@export var max_configurable_fps: int = 500

@onready var min_configurable_fps_label: Label = %MinConfigurableFPS
@onready var max_configurable_fps_label: Label = %MaxConfigurableFPS
@onready var configurable_max_fps: HSlider = %ConfigurableMaxFPS
@onready var label_real_fps: Label = %LabelRealFPS
@onready var max_fps_label: Label = %MaxFPSLabel
@onready var delta_label: Label = %DeltaLabel

@onready var path_follow_2d_with_delta: PathFollow2D = $Node2D/UsesDelta/Path2D/PathFollow2D
@onready var path_follow_2d_without_delta: PathFollow2D = $Node2D/DoesNotUseDelta/Path2D/PathFollow2D

@onready var using_delta_last_lap_time: Label = %UsingDeltaLastLapTime
@onready var without_delta_last_lap_time: Label = %WithoutDeltaLastLapTime

func _ready():
	configurable_max_fps.value = Engine.physics_ticks_per_second
	min_configurable_fps_label.text = str(min_configurable_fps)
	max_configurable_fps_label.text = str(max_configurable_fps)
	configurable_max_fps.min_value = min_configurable_fps
	configurable_max_fps.max_value = max_configurable_fps
	path_follow_2d_with_delta.lap_completed.connect(func(time):
		using_delta_last_lap_time.text = "%.2fs" % time
	)
	path_follow_2d_without_delta.lap_completed.connect(func(time):
		without_delta_last_lap_time.text = "%.2fs" % time
	)

func _process(delta: float) -> void:
	delta_label.text = str(delta, "s")
	label_real_fps.text = str(int(Performance.get_monitor(Performance.TIME_FPS)))
	Engine.max_fps = int(configurable_max_fps.value)
	max_fps_label.text = str(int(configurable_max_fps.value))
