extends Node2D

var player_scene = preload("res://scenen/Player.tscn")

signal player_spawned(new_player: Player)

@export var device:int

func _ready() -> void:
	playerrespawn()

func playerrespawn():
		var new_player = player_scene.instantiate()
		new_player.device = device
		new_player.position = position
		get_parent().add_child.call_deferred(new_player)
		new_player.player_respawn.connect(playerrespawn)
		player_spawned.emit(new_player)
