extends Node2D

@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

func _process(_delta: float) -> void:
	path_follow_2d.progress_ratio += 0.008
