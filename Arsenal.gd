extends Node2D

onready var sub = get_parent()
onready var turret = sub.get_node("Turret")
onready var global = get_tree().get_root().get_node("GlobalVariables")

const WeaponResources = {
	"HarpoonGun": preload("res://Scenes/Weapons/HarpoonGun.tscn"),
	"SubGun": preload("res://Scenes/Weapons/SubGun.tscn"),
	"DepthCharges": preload("res://Scenes/Weapons/Blunderbuss.tscn"),
	"RocketLauncher": preload("res://Scenes/Weapons/RocketLauncher.tscn"),
	"TorpedoTube": preload("res://Scenes/Weapons/TorpedoTube.tscn")
}

var primary_weapon = null
var secondary_weapon = null
var tertiary_weapon = null


func _ready():
	equip_primary("HarpoonGun")
	# equip_secondary("RocketLauncher")


func _process(delta):
	if global.get_health() > 0:
		if Input.is_action_pressed("fire_primary"):
			if primary_weapon and primary_weapon.has_method("firing"):
				primary_weapon.firing(get_parent())
		if Input.is_action_just_pressed("fire_primary"):
			if primary_weapon and primary_weapon.has_method("fire_once"):
				primary_weapon.fire_once(get_parent())
		
		if Input.is_action_pressed("fire_secondary"):
			if secondary_weapon and secondary_weapon.has_method("firing"):
				secondary_weapon.firing(get_parent())
		if Input.is_action_just_pressed("fire_secondary"):
			if secondary_weapon and secondary_weapon.has_method("fire_once"):
				secondary_weapon.fire_once(get_parent())

		if Input.is_action_pressed("fire_tertiary"):
			if tertiary_weapon and tertiary_weapon.has_method("firing"):
				tertiary_weapon.firing(get_parent())
		if Input.is_action_just_pressed("fire_tertiary"):
			if tertiary_weapon and tertiary_weapon.has_method("fire_once"):
				tertiary_weapon.fire_once(get_parent())

func equip_primary(weapon_name):
	if primary_weapon:
		primary_weapon.queue_free()
	var weapon = WeaponResources[weapon_name].instance()
	primary_weapon = weapon
	equip_weapon(weapon)
	get_tree().call_group("WeaponSlots", "equip_primary", weapon)

func equip_secondary(weapon_name):
	if secondary_weapon:
		secondary_weapon.queue_free()
	var weapon = WeaponResources[weapon_name].instance()
	secondary_weapon = weapon
	equip_weapon(weapon)
	get_tree().call_group("WeaponSlots", "equip_secondary", weapon)
	

func equip_tertiary(weapon_name):
	if tertiary_weapon:
		tertiary_weapon.queue_free()
	var weapon = WeaponResources[weapon_name].instance()
	tertiary_weapon = weapon
	equip_weapon(weapon)
	get_tree().call_group("WeaponSlots", "equip_tertiary", weapon)


func equip_weapon(weapon):
	turret.add_child(weapon)
	weapon.foreground_ref = sub.get_parent()
	$AudioStreamPlayer.stream = load("res://assets/sounds/equip_weapon.ogg")
	$AudioStreamPlayer.play()
	get_tree().call_group("WeaponSlots", "equip", weapon, self)
	
	
func weapon_is_equipped(weapon_name) -> bool:
	return (
		(primary_weapon and primary_weapon.get_weapon_name() == weapon_name) or
		(secondary_weapon and secondary_weapon.get_weapon_name() == weapon_name) or
		(tertiary_weapon and tertiary_weapon.get_weapon_name() == weapon_name)
	)
