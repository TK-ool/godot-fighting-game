extends Control

@onready var margin_container: MarginContainer = $MarginContainer

@onready var h_box: HBoxContainer = $MarginContainer/HBoxContainer

@onready var slots: Array = [
	$MarginContainer/HBoxContainer/Slot1,
	$MarginContainer/HBoxContainer/Slot2,
	$MarginContainer/HBoxContainer/Slot3,
	$MarginContainer/HBoxContainer/Slot4
]

var is_updating: bool = false
const WEAPON_CARD = preload("res://scenen/weapon_card.tscn")


func open_inventory():
	var tween = get_tree().create_tween()
	tween.tween_property(margin_container, "position", Vector2(0, 42.19),0.3)
	
func close_inventory():
	var tween = get_tree().create_tween()
	tween.tween_property(margin_container, "position", Vector2(0, 131.59),0.3)


func update_display(inventory: Inventory):
	if is_updating:
		return
	is_updating = true
	#clear cards
	for slot in slots:
		var children = slot.get_children()
		for i in range(children.size()):
			if i > 0:
				children[i].queue_free()
	
	#wait for queue to finish
	await get_tree().process_frame
	
	#load cards
	for i in inventory.cards.size():
		if i >= slots.size():
			break
		var card_instance = WEAPON_CARD.instantiate()
		slots[i].add_child(card_instance)
		card_instance.setup(inventory.cards[i])
	is_updating = false
	
