extends CanvasLayer

@onready var weapon_change: CanvasGroup = $"Weapon change"
@onready var inventory_label_1: Label = $"Weapon change/inventory_label_1"
@onready var inventory_label_2: Label = $"Weapon change/inventory_label_2"


signal weapon_equiped_P1(weapon_selected: int)
signal weapon_equiped_P2(weapon_selected: int)


func _ready() -> void:
	weapon_change.visible = false
		

func _on_option_button_item_selected(index: int) -> void:
	weapon_equiped_P1.emit(index)


func _on_option_button_2_item_selected(index: int) -> void:
	weapon_equiped_P2.emit(index)

func update_inventory_display_1(inventory: Inventory):
	var text = "Inventar: "
	for card in inventory.cards:
		text += card.weapon_name
	inventory_label_1.text = text

func update_inventory_display_2(inventory: Inventory):
	var text = "Inventar: "
	for card in inventory.cards:
		text += card.weapon_name
	inventory_label_2.text = text

func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		weapon_change.visible = true
	else:
		weapon_change.visible = false
