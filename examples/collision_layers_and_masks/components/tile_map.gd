extends TileMapLayer

@onready var tile_map_collision_layers_editor: PanelContainer = %TileMapCollisionLayersEditor
@onready var tile_map_collision_masks_editor: PanelContainer = %TileMapCollisionMasksEditor

func _ready():
	tile_map_collision_layers_editor.collision_flags = tile_set.get_physics_layer_collision_layer(0)
	tile_map_collision_layers_editor.collision_flags_changed.connect(func(new_collision_flags):
		tile_set.set_physics_layer_collision_layer(0, tile_map_collision_layers_editor.collision_flags)
	)
	
	tile_map_collision_masks_editor.collision_flags = tile_set.get_physics_layer_collision_mask(0)
	tile_map_collision_masks_editor.collision_flags_changed.connect(func(new_collision_flags):
		tile_set.set_physics_layer_collision_mask(0, tile_map_collision_masks_editor.collision_flags)
	)
