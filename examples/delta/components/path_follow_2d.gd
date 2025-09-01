extends PathFollow2D

@onready var lap_started_timestamp: float = Time.get_ticks_msec()

signal lap_completed(time)

var next_target: float = 0.5

func _process(_delta: float) -> void:
	if(progress_ratio >= next_target):
		var time_now = Time.get_ticks_msec()
		var time_passed_in_seconds = (time_now - lap_started_timestamp) / 1000.0
		lap_completed.emit(time_passed_in_seconds)
		next_target = 1.0 if next_target == 0.5 else 0.5
		lap_started_timestamp = time_now
	progress_ratio = fmod(progress_ratio, 1.0)
