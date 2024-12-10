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
	
	var attempts = 0
	var max_attempts = 100
	var spawned = false
	
	while not spawned and attempts < max_attempts:
		print("trying to spawn enemy")
		var random_position = Vector2(rng.randi() % tilemap.get_used_rect().size.x, rng.randi() % tilemap.get_used_rect().size.y)
		if is_valid_spawn_location(Global.GRASS_LAYER, random_position):
			var enemy = Global.enemy_scene.instantiate()
			enemy.position = tilemap.map_to_local(random_position) + Vector2(tilemap.tile_size.x, tilemap.tile_size.y)/2
			spawned_enemies.add_child(enemy)
			spawned = true
		else:
			attempts += 1
	if attempts >= max_attempts:
		pass
	
	
func is_valid_spawn_location(layer, position):
	var cell_coords = Vector2(position.x, position.y)
	if tilemap.get_cell_source_id(Global.WATER_LAYER, cell_coords) != -1 || tilemap.get_cell_source_id(Global.BUILDING_LAYER, cell_coords) != -1 || tilemap.get_cell_source_id(Global.FLIAGE_LAYER, cell_coords) != -1:
		return false
	if tilemap.get_cell_source_id(Global.GRASS_LAYER, cell_coords) != -1:
		return true


func _on_timer_timeout():
	if enemy_count < max_enemies:
		spawn_enemy()
		enemy_count += 1
