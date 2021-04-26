extends Node2D

const base_path = "Panel/MarginContainer/VBoxContainer/"

onready var primary_label = get_node(base_path + "Primary")
onready var secondary_label = get_node(base_path + "Secondary")
onready var tertiary_label = get_node(base_path + "Tertiary")

func _ready():
	add_to_group("WeaponSlots")

func equip_primary(weapon):
	primary_label.text = "1. " + get_weapon_name(weapon)
	
func equip_secondary(weapon):
	secondary_label.text = "2. " + get_weapon_name(weapon)
	
func equip_tertiary(weapon):
	tertiary_label.text = "3. " + get_weapon_name(weapon)

func get_weapon_name(weapon):
	if weapon and weapon.has_method("get_weapon_name"):
		return weapon.get_weapon_name()
	if weapon and weapon.has_method("get_name"):
		return weapon.get_name()
	return "Weapon"
