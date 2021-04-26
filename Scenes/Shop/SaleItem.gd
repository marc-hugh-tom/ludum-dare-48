extends Control

onready var global = get_tree().get_root().get_node("GlobalVariables")

export(String) var item_name = ""
export(int) var cost = 0
export(String) var weapon_name = ""

var my_weapon_equipped = false

signal buy

func _ready():
	sync_ui()

func sync_ui():
	$hbox/item_name.set_text(item_name)
	$hbox/TextureButton/CenterContainer/cost_label.set_text(str(cost) + " scrap")
	
	if cost == 0 or cost > global.get_scrap():
		disable()
	elif my_weapon_equipped:
		disable()
	else:
		enable()

func set_cost(val):
	cost = val
	sync_ui()

func _on_TextureButton_pressed():
	$click.play()
	global.decrement_scrap(cost)
	sync_ui()
	emit_signal("buy")

func disable():
	$hbox/TextureButton.disabled = true

func enable():
	$hbox/TextureButton.disabled = false

func equip(_weapon, arsenal):
	my_weapon_equipped = (
		weapon_name and 
		arsenal.weapon_is_equipped(weapon_name)
	)
	sync_ui()
