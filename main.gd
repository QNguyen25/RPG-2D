extends Node2D

@onready var health_bar_value = %HealthBar
@onready var stamina_bar_value = %StaminaBar
@onready var player = $Player


func _ready():
	player.health_updated.connect(_on_player_health_updated)
	player.stamina_updated.connect(_on_player_stamina_updated)
	
	
func _on_player_health_updated(health, max_health):
	health_bar_value.value = 100 * player.health / player.max_health
	
	
func _on_player_stamina_updated(stamina, max_stamina):
	print("changing the bar", player.stamina)
	stamina_bar_value.value = 100 * player.stamina / player.max_stamina
	


