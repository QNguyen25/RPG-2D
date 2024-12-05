extends Node2D


@onready var spawned_enemies = $SpawnedEnemies
@onready var tilemap = get_tree().root.get_node("Main/tilemap")

@export var max_enemies = 20
var enemy_count = 0
var rng = RandomNumberGenerator.new()



func _ready():
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func spawn_enemy():
	var enemy = Global.enemy_scene.instantiate()
	spawned_enemies.add_child(enemy)
	
	
func is_valid_spawn_location(layer, position):
	var cell_coords = Vector2(position.x, position.y)
	if tilemap.get_cell_source_id(Global.WATER_LAYER, cell_coords) != -1 || tilemap.get_cell_source_id(Global.BUILDING_LAYER, cell_coords) != -1 || tilemap.get_cell_source_id(Global.FLIAGE_LAYER, cell_coords) != -1:
		return false
	if tilemap.get_cell_source_id(Global.GRASS_LAYER, cell_coords) != -1:
		return true
