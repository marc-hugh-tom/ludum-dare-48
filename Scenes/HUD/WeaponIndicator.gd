extends Node2D

onready var primary_label = $Panel/Grid/Primary
onready var secondary_label = $Panel/Grid/Secondary
onready var tertiary_label = $Panel/Grid/Tertiary

func _ready():
	add_to_group("WeaponSlots")

func equip_primary(weapon):
	primary_label.text = get_weapon_name(weapon)
	
func equip_secondary(weapon):
	secondary_label.text = get_weapon_name(weapon)
	
func equip_tertiary(weapon):
	tertiary_label.text = get_weapon_name(weapon)

func get_weapon_name(weapon):
	if weapon and weapon.has_method("get_weapon_name"):
		return weapon.get_weapon_name()
	if weapon and weapon.has_method("get_name"):
		return weapon.get_name()
	return "Weapon"
