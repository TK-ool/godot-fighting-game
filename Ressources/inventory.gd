class_name Inventory
extends Resource

@export var cards: Array[WeaponResource] = []

func add_card(weapon: WeaponResource):
	cards.append(weapon)

func remove_card(weapon: WeaponResource):
	cards.erase(weapon)
