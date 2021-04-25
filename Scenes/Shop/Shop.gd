extends Control

signal close
signal on_repair

var arsenal = null

onready var owned_items = $ShopContainer/MarginContainer/VBoxContainer/main_container/owned_items
onready var sale_items = $ShopContainer/MarginContainer/VBoxContainer/main_container/items_for_sale/sale_items

onready var primary_label = owned_items.get_node("primary/value_label")
onready var secondary_label = owned_items.get_node("secondary/value_label")
onready var tertiary_label = owned_items.get_node("tertiary/value_label")
onready var repair_sale_item = sale_items.get_node("repair_sale_item")

onready var global = get_tree().get_root().get_node("GlobalVariables")

func _ready():
	pass

func _on_TextureButton_pressed():
	emit_signal("close")

func _on_Shop_visibility_changed():
	if self.visible:
		if arsenal.primary_weapon:
			primary_label.set_text(arsenal.primary_weapon.get_name())
		if arsenal.secondary_weapon:
			secondary_label.set_text(arsenal.secondary_weapon.get_name())
		if arsenal.tertiary_weapon:
			tertiary_label.set_text(arsenal.tertiary_label.get_name())

		repair_sale_item.set_cost(repair_cost())

func repair_cost():
	return global.max_health - global.get_health()

func _on_repair_sale_item_buy():
	global.set_health(global.max_health)
	repair_sale_item.set_cost(repair_cost())
	emit_signal("on_repair")
