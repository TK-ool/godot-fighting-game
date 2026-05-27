class_name Inventory
extends Resource

@export var cards: Array[WeaponResource] = []
const MAX_SIZE = 4

func add_card(weapon: WeaponResource):
	if cards.size() < MAX_SIZE:
		cards.append(weapon)

func remove_card(weapon: WeaponResource):
	cards.erase(weapon)
