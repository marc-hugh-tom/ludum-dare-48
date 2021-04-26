extends Control

signal close
signal on_repair

var arsenal = null

onready var sale_items = $ShopContainer/MarginContainer/VBoxContainer/main_container/items_for_sale/sale_items

onready var repair_sale_item = sale_items.get_node("repair_sale_item")

onready var global = get_tree().get_root().get_node("GlobalVariables")


func _on_TextureButton_pressed():
	emit_signal("close")

func _on_Shop_visibility_changed():
	if self.visible:
		repair_sale_item.set_cost(repair_cost())

func repair_cost():
	return global.max_health - global.get_health()

func _on_repair_sale_item_buy():
	global.set_health(global.max_health)
	repair_sale_item.set_cost(repair_cost())
	emit_signal("on_repair")
	
func _on_SubGun_buy():
	get_tree().call_group("Arsenal", "equip_primary", "SubGun")

func _on_Depth_Charges_buy():
	get_tree().call_group("Arsenal", "equip_secondary", "DepthCharges")
	
func _on_AquaRocket_buy():
	get_tree().call_group("Arsenal", "equip_secondary", "RocketLauncher")

func _on_Torpedo_buy():
	get_tree().call_group("Arsenal", "equip_tertiary", "TorpedoTube")
