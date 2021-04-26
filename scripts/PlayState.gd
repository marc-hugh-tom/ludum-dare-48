extends Node2D

signal quit
signal restart

var explosion_length = 0.5

onready var global = get_tree().get_root().get_node("GlobalVariables")

var explosion_array = []
var twitter_depth
var player_blood_threshold = 30.0

func _ready():
	setup_callbacks()
	randomize()

func update_blood():
	var blood_t = 0
	var current_value = $HUD/HullIntegrity.lag_value
	if current_value < player_blood_threshold:
		blood_t = 1.0 - (current_value/player_blood_threshold)
	$PostProcessing.get_material().set_shader_param("blood_intensity", blood_t)

var shop_visible = false

func _process(delta):
	if Input.is_action_just_pressed("shop") and not shop_visible:
		toggle_pause()
		$Shop.arsenal = $ViewportContainer/Viewport/Foreground/sub.get_node("Arsenal")
		shop_visible = true
		$Shop.show()
	update_explosions(delta)
	update_blood()
	if global.is_max_depth():
		$HUD/BossHealth.show()

func _on_Shop_close():
	toggle_pause()
	shop_visible = false
	$Shop.hide()

func explosion_event(explosion_pos):
	explosion_array.append({
		'pos': explosion_pos,
		't': 0.0
	})

func update_explosions(delta):
	var screen_size = get_viewport_rect().size
	var new_array = []
	for explosion in explosion_array:
		explosion['t'] += delta
		if explosion['t'] < explosion_length:
			new_array.append(explosion)
	if len(new_array) > 0:
		var data_image = Image.new()
		data_image.create(1, len(new_array), false, Image.FORMAT_RGBA8)
		data_image.lock()
		for i in range(len(new_array)):
			data_image.set_pixel(0, i,
				Color(
					new_array[i]['pos'].x / screen_size.x,
					1.0-new_array[i]['pos'].y / screen_size.y,
					new_array[i]['t'] / explosion_length
				)
			)
		data_image.unlock()
		var texture = ImageTexture.new()
		texture.create_from_image(data_image, 0)
		$PostProcessing.get_material().set_shader_param("no_explosion", false)
		$PostProcessing.get_material().set_shader_param("data_texture", texture)
	else:
		$PostProcessing.get_material().set_shader_param("no_explosion", true)
	explosion_array = new_array

func _input(event):
	if event.is_action_released("pause"):
		toggle_pause_menu()

func setup_callbacks():
	# Died Restart
	$DiedMenu/VBoxContainer/Retry.connect(
		"button_up", self, "emit_signal", ["restart"])
	# Died Restart
	$DiedMenu/VBoxContainer/Share.connect(
		"button_up", self, "twitter_share", [false])
	# Died Quit
	$DiedMenu/VBoxContainer/Quit.connect(
		"button_up", self, "emit_signal", ["quit"])

	# Won Restart
	$WonMenu/VBoxContainer/Retry.connect(
		"button_up", self, "emit_signal", ["restart"])
	# Won Restart
	$WonMenu/VBoxContainer/Share.connect(
		"button_up", self, "twitter_share", [true])
	# Won Quit
	$WonMenu/VBoxContainer/Quit.connect(
		"button_up", self, "emit_signal", ["quit"])

	# Pause Continue
	$PauseMenu/VBoxContainer/Continue.connect(
		"button_up", self, "toggle_pause_menu")
	# Pause Quit
	$PauseMenu/VBoxContainer/Quit.connect(
		"button_up", self, "emit_signal", ["quit"])

func twitter_share(won):
	if won:
		var _return = OS.shell_open("http://twitter.com/share?text=" +
			"I defeated the boss in SUBGUNNER!&url=" +
			"https://manicmoleman.itch.io/subgunner" +
			"&hashtags=LDJAM,ldjam48,LD48,GodotEngine")
	else:
		var _return = OS.shell_open("http://twitter.com/share?text=" +
			"I made it " + str(int(twitter_depth)) + "m under the sea in SUBGUNNER!&url=" +
			"https://manicmoleman.itch.io/subgunner" +
			"&hashtags=LDJAM,ldjam48,LD48,GodotEngine")

func toggle_pause_menu():
	if get_tree().paused:
		$PauseMenu.hide()
	else:
		$PauseMenu.show()
	toggle_pause()

func player_died():
	$DiedMenu.show()
	toggle_pause()

func won():
	$WonMenu.show()
	toggle_pause()

func toggle_pause():
	if get_tree().paused:
		pause_mode = PAUSE_MODE_INHERIT
		$ViewportContainer.pause_mode = PAUSE_MODE_INHERIT
		global.pause_mode = PAUSE_MODE_INHERIT
		get_tree().paused = false
	else:
		twitter_depth = global.get_depth()
		pause_mode = PAUSE_MODE_PROCESS
		$ViewportContainer.pause_mode = PAUSE_MODE_STOP
		global.pause_mode = PAUSE_MODE_STOP
		get_tree().paused = true
