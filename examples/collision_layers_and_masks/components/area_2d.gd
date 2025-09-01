extends Area2D

func _process(_delta: float) -> void:
	modulate = Color.RED if has_overlapping_bodies() or has_overlapping_areas() else Color.WHITE
	modulate.a = 0.7
