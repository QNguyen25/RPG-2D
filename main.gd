extends Node2D

@onready var health_bar_value = $UI/Health/Value
@onready var stamina_bar_value = $UI/Stamina/Value
@onready var player = $Player


func _ready():
	pass
	#player.health_updated.connect(_on_player_health_updated)
	#player.stamina_updated.connect(_on_player_stamina_updated)
	
	
func _on_player_health_updated():
	health_bar_value.size.x = 98 * player.health / player.max_health
	
	
func _on_player_stamina_updated():
	print("changing the bar", player.stamina)
	stamina_bar_value.size.x = 98 * player.stamina / player.max_stamina
	
