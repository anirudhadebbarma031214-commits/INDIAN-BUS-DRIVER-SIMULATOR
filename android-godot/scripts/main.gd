extends Node3D

# Standalone Godot port of the Roblox prototype. Original low-cost procedural scenery.
# ANI STUDIO — Indian Bus Driver Simulator

var bus: Node3D
var camera: Camera3D
var hud: CanvasLayer
var menu: Control
var drive_ui: Control
var speed_label: Label
var route_label: Label
var throttle := 0.0
var steering := 0.0
var driving := false
var speed := 0.0
var fuel := 100.0
var current_route := "Agartala City Loop"
var bus_color := Color(0.82, 0.12, 0.08)

func _ready() -> void:
	_build_world()
	_build_bus()
	_build_camera()
	_build_ui()
	set_process(true)

func _process(delta: float) -> void:
	if driving:
		var target_speed := throttle * 22.0
		speed = move_toward(speed, target_speed, 20.0 * delta)
		bus.rotate_y(-steering * 0.8 * delta * clamp(abs(speed) / 5.0, 0.2, 1.0))
		bus.global_position += -bus.global_basis.z * speed * delta
		fuel = maxf(0.0, fuel - abs(speed) * delta * 0.006)
	else:
		speed = move_toward(speed, 0.0, 25.0 * delta)
	_update_camera()
	if is_instance_valid(speed_label):
		speed_label.text = "SPEED  %03d km/h     FUEL  %d%%" % [int(abs(speed) * 3.6), int(fuel)]

func _material(color: Color, roughness: float = 0.9) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	return m

func _box(parent: Node3D, name: String, size: Vector3, pos: Vector3, color: Color) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = name
	var mesh := BoxMesh.new()
	mesh.size = size
	node.mesh = mesh
	node.position = pos
	node.material_override = _material(color)
	parent.add_child(node)
	return node

func _build_world() -> void:
	var world_env := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.50, 0.72, 0.86)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.75, 0.78, 0.82)
	env.ambient_light_energy = 0.8
	world_env.environment = env
	add_child(world_env)

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48, -28, 0)
	sun.light_energy = 1.15
	add_child(sun)

	_box(self, "Grassland", Vector3(600, 0.5, 600), Vector3(0, -0.4, 0), Color(0.25, 0.43, 0.25))
	# Main road network around the city.
	_box(self, "Main Agartala Road", Vector3(600, 0.12, 18), Vector3(0, -0.08, 0), Color(0.12, 0.13, 0.15))
	_box(self, "North South Road", Vector3(18, 0.13, 420), Vector3(0, -0.06, -35), Color(0.12, 0.13, 0.15))
	_box(self, "Airport Road", Vector3(13, 0.13, 230), Vector3(72, -0.05, -75), Color(0.14, 0.15, 0.17))
	_box(self, "Udaipur Highway", Vector3(15, 0.13, 250), Vector3(-78, -0.05, 95), Color(0.14, 0.15, 0.17))
	for x in range(-280, 281, 14):
		_box(self, "Road Dash", Vector3(6, 0.03, 0.35), Vector3(x, 0.01, 0), Color(0.94, 0.88, 0.60))
	for z in range(-230, 181, 14):
		_box(self, "Road Dash", Vector3(0.35, 0.03, 6), Vector3(0, 0.02, z), Color(0.94, 0.88, 0.60))
	# Sidewalk strips and small market buildings.
	for side in [-1.0, 1.0]:
		_box(self, "Market Sidewalk", Vector3(600, 0.18, 3), Vector3(0, 0.0, side * 12), Color(0.58, 0.56, 0.48))
		for i in range(18):
			var x := -245.0 + float(i) * 28.0
			var depth := 10.0 + float((i * 7) % 7)
			var height := 7.0 + float((i * 5) % 8)
			var shop := _box(self, "Agartala Market Shop", Vector3(15, height, depth), Vector3(x, height / 2.0, side * (24.0 + depth / 2.0)), Color.from_hsv(float(i % 9) / 9.0, 0.45, 0.83))
			_box(shop, "Shop Sign", Vector3(8, 1.2, 0.25), Vector3(0, height * 0.18, -depth / 2.0 - 0.15), Color(0.96, 0.83, 0.32))
	# Badarghat-inspired homes.
	for i in range(12):
		var x := -160.0 + float(i) * 29.0
		for side in [-1.0, 1.0]:
			var home := _box(self, "Badarghat Home", Vector3(13, 5, 12), Vector3(x, 2.5, side * 62.0), Color(0.78, 0.68, 0.52))
			_box(home, "Roof", Vector3(14, 1.5, 13), Vector3(0, 3.1, 0), Color(0.55, 0.20, 0.14))
	# Trees: low-part-count stylized foliage.
	for i in range(42):
		var x := float((i * 47) % 520) - 260.0
		var z := float((i * 31) % 380) - 190.0
		if absf(z) > 17.0 and absf(x) > 12.0:
			_box(self, "Tree Trunk", Vector3(1.2, 4, 1.2), Vector3(x, 2, z), Color(0.32, 0.20, 0.12))
			_box(self, "Tree Canopy", Vector3(5, 5, 5), Vector3(x, 5, z), Color(0.12, 0.38, 0.17))
	# Ujjayanta Palace-inspired landmark.
	_box(self, "Palace Grounds", Vector3(54, 0.4, 42), Vector3(105, 0.0, 65), Color(0.34, 0.50, 0.28))
	_box(self, "Ujjayanta Palace", Vector3(30, 12, 18), Vector3(105, 6.2, 65), Color(0.89, 0.86, 0.74))
	_box(self, "Palace Central Dome", Vector3(9, 8, 9), Vector3(105, 16, 65), Color(0.91, 0.88, 0.78))
	for dx in [-12.0, 12.0]:
		_box(self, "Palace Tower", Vector3(4, 16, 4), Vector3(105 + dx, 8, 65), Color(0.90, 0.87, 0.76))
	# Railway station and platforms.
	_box(self, "Agartala Railway Platform", Vector3(65, 0.5, 12), Vector3(-130, 0.0, -110), Color(0.65, 0.62, 0.54))
	_box(self, "Agartala Railway Station", Vector3(40, 7, 10), Vector3(-130, 3.7, -123), Color(0.82, 0.77, 0.65))
	_box(self, "Railway Track", Vector3(75, 0.12, 2), Vector3(-130, 0.2, -96), Color(0.23, 0.23, 0.24))
	# Airport terminal, apron and runway.
	_box(self, "Airport Apron", Vector3(100, 0.15, 55), Vector3(72, 0.0, -200), Color(0.32, 0.33, 0.34))
	_box(self, "Agartala Airport Terminal", Vector3(55, 10, 16), Vector3(72, 5, -178), Color(0.79, 0.81, 0.78))
	_box(self, "Airport Runway", Vector3(35, 0.15, 110), Vector3(125, 0.0, -215), Color(0.17, 0.18, 0.20))
	for z in range(-260, -160, 14):
		_box(self, "Runway Marking", Vector3(1.0, 0.04, 7), Vector3(125, 0.12, z), Color(0.94, 0.94, 0.90))
	# Udaipur destination marker.
	_box(self, "Udaipur Bus Stop", Vector3(22, 4, 5), Vector3(-78, 2, 205), Color(0.10, 0.35, 0.65))
	_box(self, "Bus Stop Sign", Vector3(8, 1, 0.3), Vector3(-78, 3.3, 202.3), Color(0.95, 0.85, 0.25))
	# City entrance sign.
	_box(self, "City Welcome Sign", Vector3(22, 5, 1), Vector3(35, 2.5, -20), Color(0.07, 0.32, 0.20))
	_box(self, "Welcome Sign Panel", Vector3(18, 2, 0.3), Vector3(35, 3, -20.7), Color(0.90, 0.84, 0.56))

func _build_bus() -> void:
	bus = Node3D.new()
	bus.name = "PlayerBus"
	bus.position = Vector3(0, 0.3, 34)
	add_child(bus)
	_box(bus, "Bus Lower Body", Vector3(4.3, 1.5, 10), Vector3(0, 1.4, 0), bus_color)
	_box(bus, "Bus Upper Body", Vector3(4.0, 1.7, 6.7), Vector3(0, 2.95, -0.25), Color(0.88, 0.89, 0.84))
	_box(bus, "Front Windshield", Vector3(3.3, 1.15, 0.12), Vector3(0, 3.05, -3.67), Color(0.13, 0.23, 0.29))
	_box(bus, "Rear Window", Vector3(3.1, 0.9, 0.12), Vector3(0, 3.05, 3.12), Color(0.13, 0.23, 0.29))
	for side in [-1.0, 1.0]:
		for i in range(4):
			_box(bus, "Passenger Window", Vector3(0.12, 0.85, 1.0), Vector3(side * 2.04, 3.05, -2.1 + float(i) * 1.4), Color(0.14, 0.28, 0.34))
		for z in [-3.2, 3.2]:
			_box(bus, "Wheel", Vector3(0.45, 0.95, 1.0), Vector3(side * 2.15, 0.65, z), Color(0.06, 0.06, 0.06))
	_box(bus, "Front Bumper", Vector3(3.8, 0.35, 0.3), Vector3(0, 0.8, -5.0), Color(0.78, 0.78, 0.75))
	_box(bus, "Bus Destination Board", Vector3(2.5, 0.45, 0.12), Vector3(0, 3.9, -3.68), Color(0.98, 0.77, 0.12))

func _build_camera() -> void:
	camera = Camera3D.new()
	camera.name = "FollowCamera"
	camera.fov = 70
	add_child(camera)
	_update_camera()
	camera.current = true

func _update_camera() -> void:
	if not is_instance_valid(camera) or not is_instance_valid(bus):
		return
	var target := bus.global_position + bus.global_basis * Vector3(0, 5.0, 12.5)
	camera.global_position = camera.global_position.lerp(target, 0.10)
	camera.look_at(bus.global_position + Vector3(0, 1.8, 0), Vector3.UP)

func _build_ui() -> void:
	hud = CanvasLayer.new()
	add_child(hud)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hud.add_child(root)

	var top := PanelContainer.new()
	top.position = Vector2(18, 16)
	top.custom_minimum_size = Vector2(460, 52)
	root.add_child(top)
	var top_row := HBoxContainer.new()
	top.add_child(top_row)
	var title := Label.new()
	title.text = "ANI STUDIO  |  INDIAN BUS DRIVER SIMULATOR"
	title.add_theme_font_size_override("font_size", 18)
	top_row.add_child(title)

	speed_label = Label.new()
	speed_label.position = Vector2(20, 80)
	speed_label.add_theme_font_size_override("font_size", 21)
	speed_label.text = "SPEED  000 km/h     FUEL  100%"
	root.add_child(speed_label)

	route_label = Label.new()
	route_label.text = "AGARTALA • TRIPURA"
	route_label.position = Vector2(20, 112)
	route_label.add_theme_font_size_override("font_size", 16)
	root.add_child(route_label)

	drive_ui = Control.new()
	drive_ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(drive_ui)
	_add_drive_button(drive_ui, "◀", Vector2(24, -142), Vector2(78, 78), "left")
	_add_drive_button(drive_ui, "▶", Vector2(112, -142), Vector2(78, 78), "right")
	_add_drive_button(drive_ui, "▲", Vector2(-194, -230), Vector2(82, 82), "forward", true)
	_add_drive_button(drive_ui, "▼", Vector2(-194, -140), Vector2(82, 82), "reverse", true)

	menu = Panel.new()
	menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	menu.add_theme_stylebox_override("panel", _panel_style(Color(0.025, 0.055, 0.08, 0.92)))
	root.add_child(menu)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	menu.add_child(center)
	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(420, 0)
	column.add_theme_constant_override("separation", 16)
	center.add_child(column)
	var game_title := Label.new()
	game_title.text = "INDIAN BUS DRIVER\nSIMULATOR"
	game_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_title.add_theme_font_size_override("font_size", 34)
	column.add_child(game_title)
	var sub := Label.new()
	sub.text = "AGARTALA • TRIPURA  |  A GAME BY ANI STUDIO"
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override("font_size", 15)
	column.add_child(sub)
	var route_pick := OptionButton.new()
	route_pick.add_item("Agartala City Loop")
	route_pick.add_item("Agartala to Udaipur")
	route_pick.add_item("Agartala to Dharmanagar")
	route_pick.add_item("Agartala to Guwahati")
	route_pick.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	route_pick.item_selected.connect(_choose_route)
	column.add_child(route_pick)
	var play := Button.new()
	play.text = "START DRIVING"
	play.custom_minimum_size = Vector2(0, 58)
	play.add_theme_font_size_override("font_size", 22)
	play.pressed.connect(_start_driving)
	column.add_child(play)
	var credits := Label.new()
	credits.text = "Touch controls supported • WASD / arrow keys on PC"
	credits.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(credits)

func _panel_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style

func _add_drive_button(parent: Control, text_value: String, pos: Vector2, size_value: Vector2, action: String, bottom_right: bool = false) -> void:
	var b := Button.new()
	b.text = text_value
	b.custom_minimum_size = size_value
	b.add_theme_font_size_override("font_size", 28)
	var normal_style := _panel_style(Color(0.04, 0.10, 0.15, 0.82))
	var pressed_style := _panel_style(Color(0.10, 0.40, 0.65, 0.95))
	for s in [normal_style, pressed_style]:
		s.content_margin_top = 2
		s.content_margin_bottom = 2
		s.content_margin_left = 2
		s.content_margin_right = 2
	b.add_theme_stylebox_override("normal", normal_style)
	b.add_theme_stylebox_override("pressed", pressed_style)
	b.add_theme_stylebox_override("hover", normal_style)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	# Anchor to the bottom-left or bottom-right corner and size explicitly via offsets.
	var anchor_x := 1.0 if bottom_right else 0.0
	b.anchor_left = anchor_x
	b.anchor_right = anchor_x
	b.anchor_top = 1.0
	b.anchor_bottom = 1.0
	b.offset_left = pos.x
	b.offset_top = pos.y
	b.offset_right = pos.x + size_value.x
	b.offset_bottom = pos.y + size_value.y
	b.button_down.connect(_set_control.bind(action, true))
	b.button_up.connect(_set_control.bind(action, false))
	parent.add_child(b)

func _set_control(action: String, pressed: bool) -> void:
	match action:
		"forward": throttle = 1.0 if pressed else ( -1.0 if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN) else 0.0 )
		"reverse": throttle = -1.0 if pressed else (1.0 if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP) else 0.0)
		"left": steering = -1.0 if pressed else (1.0 if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT) else 0.0)
		"right": steering = 1.0 if pressed else (-1.0 if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT) else 0.0)

func _choose_route(index: int) -> void:
	var routes := ["Agartala City Loop", "Agartala to Udaipur", "Agartala to Dharmanagar", "Agartala to Guwahati"]
	current_route = routes[index]

func _start_driving() -> void:
	driving = true
	menu.visible = false
	route_label.text = "AGARTALA • TRIPURA  |  ROUTE: " + current_route.to_upper()

func _unhandled_input(event: InputEvent) -> void:
	if not driving:
		return
	if event is InputEventKey:
		var key := event as InputEventKey
		if key.keycode in [KEY_W, KEY_UP]:
			throttle = 1.0 if key.pressed else 0.0
		elif key.keycode in [KEY_S, KEY_DOWN]:
			throttle = -1.0 if key.pressed else 0.0
		elif key.keycode in [KEY_A, KEY_LEFT]:
			steering = -1.0 if key.pressed else 0.0
		elif key.keycode in [KEY_D, KEY_RIGHT]:
			steering = 1.0 if key.pressed else 0.0
