extends Control

const BACKGROUND := preload("res://sources/pics/s1.png")
const CORRIDOR_BACKGROUND := preload("res://sources/pics/s2.png")
const ASSISTANT_DIALOGUE_BACKGROUND := preload("res://sources/pics/s3.png")
const MASTER_DIALOGUE_BACKGROUND := preload("res://sources/pics/oldman.png")
const WAREHOUSE_BACKGROUND := preload("res://sources/pics/s4.png")
const NOTEBOOK_BACKGROUND := preload("res://sources/pics/note.png")
const CASE_REVIEW_BACKGROUND := preload("res://sources/pics/s5.png")
const MAINPAGE_BACKGROUND := preload("res://sources/pics/mainpage.png")
const LIBRARY_DIALOGUE_BACKGROUND := preload("res://sources/pics/l2/s1-dialog.png")
const LIBRARY_CLUE_BACKGROUND := preload("res://sources/pics/l2/s1-Clue.png")
const LIBRARY_NOTEBOOK_BACKGROUND := preload("res://sources/pics/l2/note.png")
const LIBRARY_PHOTO_BACKGROUND := preload("res://sources/pics/l2/s2.png")
const LIBRARY_CAMERA_BACKGROUND := preload("res://sources/pics/l2/s3.png")
const BOY_AVATAR := preload("res://sources/pics/boy.png")
const GIRL_AVATAR := preload("res://sources/pics/girl.png")
const WRAPPED_PACKAGE := preload("res://sources/pics/clue_wrapped_package.png")
const BACKGROUND_MUSIC := preload("res://sources/bgmusic.mp3")
const SAVE_PATH := "user://player_progress.json"
const LIBRARY_CASE_PATH := "res://data/cases/library_002.json"
const LIBRARY_SAVE_PATH := "user://case_library_002_progress.json"
const CLUES := [
	{"id": "receipt", "title": "رسید خرید", "description": "یه رسید تازه اینجاست! شاید بگه چه کسی و چه وقتی خرید کرده.", "position": Vector2(0.36, 0.36), "size": Vector2(0.075, 0.10)},
	{"id": "thread", "title": "نخ قرمز", "description": "اوه! یه نخ قرمز به پیشخوان گیر کرده. شاید از لباس یا بستهٔ یکی جا مونده باشه.", "position": Vector2(0.45, 0.40), "size": Vector2(0.045, 0.14)},
	{"id": "clock", "title": "ساعت جیبی", "description": "ساعت روی ۴:۲۰ مونده. شاید اون موقع یه اتفاقی افتاده!", "position": Vector2(0.115, 0.66), "size": Vector2(0.14, 0.13)},
	{"id": "footprint", "title": "رد کفش", "description": "رد کفش تا درِ بازار می‌ره. بریم ببینیم به کجا می‌رسه!", "position": Vector2(0.56, 0.68), "size": Vector2(0.10, 0.12)},
	{"id": "number_paper", "title": "کاغذ اعداد", "description": "یه کاغذ کوچیک با چهار عدد پیدا کردی: ۲، ۱، ۴، ۳. شاید رمز قفل باشه!", "position": Vector2(0.57, 0.35), "size": Vector2(0.10, 0.08)}
]

var found_clues: Dictionary = {}
var hotspot_buttons: Array[Button] = []
var clue_count_label: Label
var score_label: Label
var home_button: Button
var prompt_label: Label
var game_footer: PanelContainer
var scene_shade: ColorRect
var scene_header: PanelContainer
var modal: PanelContainer
var modal_title: Label
var modal_description: Label
var modal_close_button: Button
var notebook: Control
var notebook_button: Button
var notebook_talk_button: Button
var notebook_return_texture: Texture2D
var intro_active := false
var main_menu: Control
var score_confirmation: PanelContainer
var score := 50
var completed_cases := 0
var earned_stars := 0
var earned_coins := 0
var bazaar_completed := false
var bazaar_stars := 0
var player_name := ""
var player_gender := ""
var selected_gender := ""
var main_case_count_label: Label
var main_star_count_label: Label
var main_coin_count_label: Label
var main_player_name_label: Label
var main_bazaar_star_label: Label
var main_avatar: TextureRect
var name_prompt: PanelContainer
var locked_case_notice: PanelContainer
var name_input: LineEdit
var name_error: Label
var boy_gender_button: Button
var girl_gender_button: Button
var lock_was_visible := false
var dialogue: PanelContainer
var dialogue_name: Label
var dialogue_text: Label
var dialogue_next_button: Button
var time_answers: HBoxContainer
var dialogue_step := 0
var time_puzzle_solved := false
var scene_background: TextureRect
var route_panel: PanelContainer
var route_text: Label
var route_choices: VBoxContainer
var assistant_panel: PanelContainer
var assistant_name: Label
var assistant_text: Label
var assistant_next_button: Button
var assistant_dialogue_step := 0
var lock_panel: PanelContainer
var lock_status: Label
var lock_sequence_label: Label
var cabinet_unlocked := false
var packaging_panel: PanelContainer
var packaging_title: Label
var packaging_question: Label
var packaging_preview: TextureRect
var packaging_choices: VBoxContainer
var packaging_solved := false
var packaging_was_visible := false
var case_panel: PanelContainer
var case_title: Label
var case_status: Label
var case_question: Label
var case_choices: VBoxContainer
var case_step := 0
var case_completed := false
var selected_symbols: Array[int] = []
var lock_code: Array[int] = []
var previous_lock_code: Array[int] = []
var notebook_clues_text: Label
var pulse_time := 0.0
var camera_delay := 35
var click_player: AudioStreamPlayer
var music_player: AudioStreamPlayer
var music_toggle_button: Button
var music_enabled := true
var exit_button: Button
var active_case_id := ""
var library_case_data: Dictionary = {}
var library_layer: Control
var library_background: TextureRect
var library_header: PanelContainer
var library_title_label: Label
var library_clue_count_label: Label
var library_score_label: Label
var library_prompt_label: Label
var library_footer: PanelContainer
var library_dialogue_panel: PanelContainer
var library_dialogue_name: Label
var library_dialogue_text: Label
var library_dialogue_next: Button
var library_modal: PanelContainer
var library_modal_title: Label
var library_modal_text: Label
var library_modal_action: Button
var library_notebook: Control
var library_notebook_text: Label
var library_notebook_close: Button
var library_notebook_confirmation: PanelContainer
var library_stage_hotspots: Array[Button] = []
var library_found_clues: Dictionary = {}
var library_score := 60
var library_stage_one_completed := false
var library_key_modal_open := false
var library_stage_two_started := false
var library_photo_seen := false
var library_stage_two_solved := false
var library_stage_three_started := false
var library_camera_count_solved := false
var library_camera_frame_solved := false
var library_photo_active := false
var library_photo_time_left := 0.0
var library_timer_label: Label
var library_choice_panel: PanelContainer
var library_choice_status: Label
var library_choice_buttons: Array[Button] = []
var library_continue_button: Button

# The menu artwork contains all visual buttons. These rectangles are only the
# transparent touch targets aligned to that 1280×720 artwork.
const BAZAAR_CASE_BUTTON_RECT := Rect2(76, 503, 209, 51)
const LOCKED_CASE_BUTTON_RECTS := [
	Rect2(318, 503, 192, 60),
	Rect2(543, 503, 193, 60),
	Rect2(768, 503, 207, 60),
	Rect2(1009, 503, 193, 60)
]
const MAIN_PROFILE_BUTTON_RECT := Rect2(782, 615, 155, 82)

const DIALOGUE_LINES := [
	{"speaker": "استاد قلم‌زن", "text": "آفرین، کارآگاه! خوب گشتی. من ساعت ۴:۴۵، درست قبل از بیرون رفتن، پلاک را توی جعبه دیدم."},
	{"speaker": "کارآگاه", "text": "پس ساعت جیبی زمان گم‌شدن پلاک را می‌گه؟"},
	{"speaker": "استاد قلم‌زن", "text": "نه، ساعت صبح افتاد و خراب شد. ولی دوربین بازار کمی بعد از ۴:۲۰، یک نفر را با بقچه دیده."}
]

const ASSISTANT_DIALOGUE_LINES := [
	{"speaker": "شاگرد مغازه", "text": "من از پنج تا پنج‌وربع توی انبار بودم؛ اصلاً هم بیرون نرفتم."},
	{"speaker": "کارآگاه", "text": "یعنی حتی یک لحظه هم از انبار بیرون نرفتی؟"},
	{"speaker": "شاگرد مغازه", "text": "آره... فقط فکر می‌کنم اگه یه چیز اصل نباشه، نباید توی نمایشگاه نشونش بدن، نه؟"},
	{"speaker": "پیک بازار", "text": "من نزدیک مغازه بودم و یه بسته می‌بردم، ولی ساعت ۴:۴۰ رفتم. استاد می‌گه ساعت ۴:۴۵ پلاک هنوز توی جعبه بود."},
	{"speaker": "فروشندهٔ کناری", "text": "کاغذ بسته‌بندی را ساعت ۵:۱۰ به خودِ شاگرد فروختم. می‌گفت برای یه چیز حساس، کاغذ محکم می‌خواد."},
	{"speaker": "مسئول انبار", "text": "من نزدیک کمد بودم. دیدم شاگرد با همون کاغذ تازه، یه بسته را گذاشت توی کمد. فکر کردم برای نمایشگاهه."}
]

const CASE_QUESTIONS := [
	{
		"question": "با دیدن همهٔ سرنخ‌ها، فکر می‌کنی چه کسی پلاک را برداشته؟",
		"choices": ["پیک بازار", "شاگرد مغازه", "فروشندهٔ کناری", "استاد قلم‌زن"],
		"correct": 1
	},
	{
		"question": "کدام سرنخ نشان می‌دهد شاگرد بسته را توی کمد گذاشته؟",
		"choices": ["نخ قرمز", "رد کفش", "رسید خرید، جور بودن بسته و حرف مسئول انبار", "ساعت شکسته"],
		"correct": 2
	},
	{
		"question": "چرا می‌گوییم شاگرد پلاک را برداشته؟",
		"choices": ["چون نخ قرمز داشت", "چون دروغ گفت", "چون کاغذ را خرید، بسته را توی کمد گذاشت و حرفش دربارهٔ انبار درست نبود"],
		"correct": 2
	}
]

func _ready() -> void:
	# Keep the canvas coordinate system independent from Persian text direction.
	# All positioned/anchored UI uses the 1280×720 LTR reference; labels and
	# text inputs explicitly opt into RTL where Persian shaping is required.
	layout_direction = Control.LAYOUT_DIRECTION_LTR
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_LANDSCAPE)
	setup_audio()
	load_player_progress()
	generate_lock_code()
	generate_time_delay()
	build_scene()
	build_main_menu()
	show_main_menu()

func setup_audio() -> void:
	# The click is synthesized at runtime, so it adds no external asset or license.
	click_player = AudioStreamPlayer.new()
	click_player.stream = create_click_sound()
	click_player.volume_db = -18.0
	add_child(click_player)

	music_player = AudioStreamPlayer.new()
	var looping_music := BACKGROUND_MUSIC.duplicate() as AudioStreamMP3
	looping_music.loop = true
	music_player.stream = looping_music
	music_player.volume_db = -15.0
	add_child(music_player)
	music_player.play()

	get_tree().node_added.connect(register_click_sound)

func create_click_sound() -> AudioStreamWAV:
	const SAMPLE_RATE := 22050
	const DURATION_SECONDS := 0.045
	var frame_count := int(SAMPLE_RATE * DURATION_SECONDS)
	var samples := PackedByteArray()
	samples.resize(frame_count * 2)
	for frame in range(frame_count):
		var time := float(frame) / float(SAMPLE_RATE)
		var envelope := pow(1.0 - float(frame) / float(frame_count), 4.0)
		var waveform := sin(TAU * 1100.0 * time) * 0.72 + sin(TAU * 1760.0 * time) * 0.28
		samples.encode_s16(frame * 2, roundi(clampf(waveform * envelope * 0.42, -1.0, 1.0) * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.data = samples
	return stream

func register_click_sound(node: Node) -> void:
	if node is BaseButton and not node.pressed.is_connected(play_click_sound):
		node.pressed.connect(play_click_sound)

func play_click_sound() -> void:
	if click_player:
		click_player.play()

func build_scene() -> void:
	scene_background = TextureRect.new()
	scene_background.texture = BACKGROUND
	scene_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	scene_background.stretch_mode = TextureRect.STRETCH_SCALE
	scene_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scene_background.z_index = -20
	scene_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(scene_background)

	scene_shade = ColorRect.new()
	scene_shade.color = Color(0.05, 0.025, 0.012, 0.18)
	scene_shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scene_shade.z_index = -10
	scene_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(scene_shade)
	build_header()
	build_hotspots()
	build_footer()
	build_clue_panel()

func build_main_menu() -> void:
	main_menu = Control.new()
	main_menu.layout_direction = Control.LAYOUT_DIRECTION_LTR
	main_menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_menu.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(main_menu)
	for index in range(LOCKED_CASE_BUTTON_RECTS.size()):
		var button_rect: Rect2 = LOCKED_CASE_BUTTON_RECTS[index]
		var locked_case_touch := Button.new()
		locked_case_touch.layout_direction = Control.LAYOUT_DIRECTION_LTR
		locked_case_touch.flat = true
		locked_case_touch.position = button_rect.position
		locked_case_touch.size = button_rect.size
		main_menu.add_child(locked_case_touch)
		# The first additional card is the playable prototype of case two.
		# Its transparent target shares the 1280×720 artwork coordinates.
		locked_case_touch.position = button_rect.position
		if index == 0:
			locked_case_touch.tooltip_text = "شروع پروندهٔ دزد کتابخانه"
			locked_case_touch.pressed.connect(begin_library_case)
		else:
			locked_case_touch.tooltip_text = "این پرونده هنوز توی بازی نیست"
			locked_case_touch.pressed.connect(show_locked_case_notice)
	var start := Button.new()
	start.layout_direction = Control.LAYOUT_DIRECTION_LTR
	start.flat = true
	start.position = BAZAAR_CASE_BUTTON_RECT.position
	start.size = BAZAAR_CASE_BUTTON_RECT.size
	start.tooltip_text = "شروع راز بازار بزرگ"
	start.pressed.connect(begin_bazaar_case)
	main_menu.add_child(start)
	main_coin_count_label = build_main_stat_label(Vector2(452, 43), Vector2(106, 38))
	main_star_count_label = build_main_stat_label(Vector2(649, 43), Vector2(72, 38))
	main_case_count_label = build_main_stat_label(Vector2(823, 43), Vector2(73, 38))
	main_player_name_label = build_main_stat_label(Vector2(115, 36), Vector2(130, 38))
	main_bazaar_star_label = build_main_stat_label(Vector2(185, 456), Vector2(66, 34))
	main_bazaar_star_label.add_theme_color_override("font_color", Color("2d2015"))
	main_avatar = TextureRect.new()
	main_avatar.layout_direction = Control.LAYOUT_DIRECTION_LTR
	main_avatar.position = Vector2(35, 28)
	main_avatar.size = Vector2(60, 60)
	main_avatar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	main_avatar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	main_avatar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main_menu.add_child(main_avatar)
	var profile_button := Button.new()
	profile_button.layout_direction = Control.LAYOUT_DIRECTION_LTR
	profile_button.flat = true
	profile_button.position = MAIN_PROFILE_BUTTON_RECT.position
	profile_button.size = MAIN_PROFILE_BUTTON_RECT.size
	profile_button.tooltip_text = "ویرایش پروفایل کارآگاه"
	profile_button.pressed.connect(open_player_profile)
	main_menu.add_child(profile_button)
	music_toggle_button = Button.new()
	music_toggle_button.layout_direction = Control.LAYOUT_DIRECTION_LTR
	music_toggle_button.flat = true
	music_toggle_button.size = Vector2(70, 70)
	music_toggle_button.pressed.connect(toggle_music)
	main_menu.add_child(music_toggle_button)
	# Reapply positions after parenting. On Android, an RTL system locale can
	# otherwise mirror a positioned child while it is attached, leaving its tap
	# rectangle somewhere other than the icon painted into the menu artwork.
	music_toggle_button.position = Vector2(1116, 18)
	update_music_toggle_button()
	exit_button = Button.new()
	exit_button.layout_direction = Control.LAYOUT_DIRECTION_LTR
	exit_button.flat = true
	exit_button.size = Vector2(70, 70)
	exit_button.tooltip_text = "خروج از بازی"
	exit_button.pressed.connect(exit_game)
	main_menu.add_child(exit_button)
	exit_button.position = Vector2(1198, 18)
	var credit_link := LinkButton.new()
	credit_link.layout_direction = Control.LAYOUT_DIRECTION_LTR
	credit_link.text = "✉"
	credit_link.uri = "mailto:mo.khoshkesht@gmail.com"
	credit_link.tooltip_text = "ارتباط با سازنده"
	credit_link.position = Vector2(26, 664)
	credit_link.size = Vector2(42, 42)
	credit_link.text_direction = Control.TEXT_DIRECTION_LTR
	credit_link.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	credit_link.add_theme_font_size_override("font_size", 30)
	credit_link.add_theme_color_override("font_color", Color("ffe09a"))
	main_menu.add_child(credit_link)
	update_main_menu_stats()
	build_name_prompt()
	build_locked_case_notice()

func build_locked_case_notice() -> void:
	locked_case_notice = PanelContainer.new()
	locked_case_notice.layout_direction = Control.LAYOUT_DIRECTION_LTR
	locked_case_notice.anchor_left = 0.5
	locked_case_notice.anchor_top = 0.5
	locked_case_notice.anchor_right = 0.5
	locked_case_notice.anchor_bottom = 0.5
	locked_case_notice.offset_left = -250
	locked_case_notice.offset_top = -105
	locked_case_notice.offset_right = 250
	locked_case_notice.offset_bottom = 105
	locked_case_notice.add_theme_stylebox_override("panel", panel_style(Color(0.10, 0.055, 0.027, 0.92), Color(0.96, 0.74, 0.31, 1), 18, 3))
	locked_case_notice.hide()
	main_menu.add_child(locked_case_notice)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 16)
	locked_case_notice.add_child(content)
	var title := Label.new()
	title.text = "این پرونده هنوز آماده نیست"
	title.text_direction = Control.TEXT_DIRECTION_RTL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("ffe09a"))
	content.add_child(title)
	var message := Label.new()
	message.text = "این پرونده هنوز توی بازی نیست. بعداً به بازی اضافه می‌شه."
	message.text_direction = Control.TEXT_DIRECTION_RTL
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.add_theme_font_size_override("font_size", 24)
	message.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(message)
	var close := Button.new()
	close.text = "باشه"
	close.custom_minimum_size = Vector2(150, 46)
	close.add_theme_font_size_override("font_size", 24)
	close.pressed.connect(func() -> void: locked_case_notice.hide())
	content.add_child(close)

func show_locked_case_notice() -> void:
	locked_case_notice.show()
	locked_case_notice.move_to_front()

func toggle_music() -> void:
	music_enabled = not music_enabled
	if music_player:
		music_player.stream_paused = not music_enabled
	update_music_toggle_button()

func update_music_toggle_button() -> void:
	if not music_toggle_button:
		return
	music_toggle_button.tooltip_text = "قطع موسیقی" if music_enabled else "پخش موسیقی"

func exit_game() -> void:
	get_tree().quit()

func build_main_stat_label(position_value: Vector2, size_value: Vector2) -> Label:
	var label := Label.new()
	label.layout_direction = Control.LAYOUT_DIRECTION_LTR
	label.position = position_value
	label.size = size_value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.text_direction = Control.TEXT_DIRECTION_RTL
	label.add_theme_font_size_override("font_size", 21)
	label.add_theme_color_override("font_color", Color("fff6e6"))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main_menu.add_child(label)
	return label

func update_main_menu_stats() -> void:
	main_case_count_label.text = "%s/۵" % to_persian_digits(str(completed_cases))
	main_star_count_label.text = to_persian_digits(str(average_stars()))
	main_coin_count_label.text = to_persian_digits(str(earned_coins))
	main_player_name_label.text = player_name
	main_bazaar_star_label.text = to_persian_digits(str(bazaar_stars))
	update_main_avatar()

func update_main_avatar() -> void:
	if player_gender.is_empty():
		main_avatar.hide()
		return
	var crop := AtlasTexture.new()
	crop.atlas = BOY_AVATAR if player_gender == "boy" else GIRL_AVATAR
	crop.region = Rect2(230, 0, 800, 800)
	main_avatar.texture = crop
	main_avatar.show()

func open_player_profile() -> void:
	name_input.text = player_name
	selected_gender = player_gender
	name_error.text = ""
	refresh_gender_buttons()
	name_prompt.show()
	name_prompt.move_to_front()
	name_input.grab_focus()

func average_stars() -> int:
	if completed_cases == 0:
		return 0
	return roundi(float(earned_stars) / float(completed_cases))

func build_name_prompt() -> void:
	name_prompt = PanelContainer.new()
	name_prompt.layout_direction = Control.LAYOUT_DIRECTION_LTR
	name_prompt.anchor_left = 0.5
	name_prompt.anchor_top = 0.5
	name_prompt.anchor_right = 0.5
	name_prompt.anchor_bottom = 0.5
	name_prompt.offset_left = -290
	name_prompt.offset_top = -210
	name_prompt.offset_right = 290
	name_prompt.offset_bottom = 210
	name_prompt.add_theme_stylebox_override("panel", panel_style(Color(0.10, 0.055, 0.027, 0.88), Color(0.96, 0.74, 0.31, 1), 18, 3))
	add_child(name_prompt)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 14)
	name_prompt.add_child(content)
	var title := Label.new()
	title.text = "پروفایل کارآگاه"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	title.text_direction = Control.TEXT_DIRECTION_RTL
	title.add_theme_font_size_override("font_size", 35)
	title.add_theme_color_override("font_color", Color("ffe09a"))
	content.add_child(title)
	var description := Label.new()
	description.text = "نام و آواتارت را انتخاب کن تا روی کارت کارآگاهت نمایش دهیم."
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	description.text_direction = Control.TEXT_DIRECTION_RTL
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.add_theme_font_size_override("font_size", 25)
	description.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(description)
	name_input = LineEdit.new()
	name_input.placeholder_text = "نام کارآگاه"
	name_input.max_length = 50
	name_input.alignment = HORIZONTAL_ALIGNMENT_RIGHT
	name_input.text_direction = Control.TEXT_DIRECTION_RTL
	name_input.custom_minimum_size = Vector2(360, 48)
	name_input.add_theme_font_size_override("font_size", 25)
	name_input.text_submitted.connect(save_player_name)
	content.add_child(name_input)
	var gender_title := Label.new()
	gender_title.text = "کارآگاهت را انتخاب کن:"
	gender_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	gender_title.text_direction = Control.TEXT_DIRECTION_RTL
	gender_title.add_theme_font_size_override("font_size", 22)
	gender_title.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(gender_title)
	var gender_choices := HBoxContainer.new()
	gender_choices.alignment = BoxContainer.ALIGNMENT_CENTER
	gender_choices.add_theme_constant_override("separation", 14)
	content.add_child(gender_choices)
	boy_gender_button = Button.new()
	boy_gender_button.custom_minimum_size = Vector2(145, 42)
	boy_gender_button.add_theme_font_size_override("font_size", 27)
	boy_gender_button.pressed.connect(select_player_gender.bind("boy"))
	gender_choices.add_child(boy_gender_button)
	girl_gender_button = Button.new()
	girl_gender_button.custom_minimum_size = Vector2(145, 42)
	girl_gender_button.add_theme_font_size_override("font_size", 27)
	girl_gender_button.pressed.connect(select_player_gender.bind("girl"))
	gender_choices.add_child(girl_gender_button)
	refresh_gender_buttons()
	name_error = Label.new()
	name_error.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	name_error.text_direction = Control.TEXT_DIRECTION_RTL
	name_error.add_theme_font_size_override("font_size", 16)
	name_error.add_theme_color_override("font_color", Color("ffbf9d"))
	content.add_child(name_error)
	var confirm := Button.new()
	confirm.text = "ذخیرهٔ تغییرات"
	confirm.custom_minimum_size = Vector2(210, 46)
	confirm.add_theme_font_size_override("font_size", 22)
	confirm.pressed.connect(save_player_name.bind(""))
	content.add_child(confirm)
	name_prompt.hide()

func select_player_gender(gender: String) -> void:
	selected_gender = gender
	name_error.text = ""
	refresh_gender_buttons()

func refresh_gender_buttons() -> void:
	if not boy_gender_button or not girl_gender_button:
		return
	boy_gender_button.text = "✓ پسر" if selected_gender == "boy" else "پسر"
	girl_gender_button.text = "✓ دختر" if selected_gender == "girl" else "دختر"

func save_player_name(submitted_name: String = "") -> void:
	var chosen_name := submitted_name.strip_edges()
	if chosen_name.is_empty():
		chosen_name = name_input.text.strip_edges()
	if chosen_name.is_empty():
		name_error.text = "لطفاً یک نام کوتاه بنویس."
		return
	if selected_gender.is_empty():
		name_error.text = "لطفاً دختر یا پسر را انتخاب کن."
		return
	player_name = chosen_name.left(50)
	player_gender = selected_gender
	save_player_progress()
	update_main_menu_stats()
	name_prompt.hide()

func load_player_progress() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return
	var data = json.data
	if not data is Dictionary:
		return
	player_name = str(data.get("player_name", "")).strip_edges().left(50)
	player_gender = str(data.get("player_gender", ""))
	if player_gender != "boy" and player_gender != "girl":
		player_gender = ""
	selected_gender = player_gender
	completed_cases = clampi(int(data.get("completed_cases", 0)), 0, 5)
	earned_stars = maxi(0, int(data.get("earned_stars", 0)))
	earned_coins = maxi(0, int(data.get("earned_coins", 0)))
	bazaar_completed = bool(data.get("bazaar_completed", completed_cases > 0))
	bazaar_stars = clampi(int(data.get("bazaar_stars", 0)), 0, 5)
	if bazaar_completed and bazaar_stars == 0:
		bazaar_stars = clampi(roundi(float(earned_coins) / 50.0 * 5.0), 1, 5)
		if completed_cases == 1:
			earned_stars = bazaar_stars

func save_player_progress() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	var data := {
		"version": 1,
		"player_name": player_name,
		"player_gender": player_gender,
		"completed_cases": completed_cases,
		"earned_stars": earned_stars,
		"earned_coins": earned_coins,
		"bazaar_completed": bazaar_completed,
		"bazaar_stars": bazaar_stars
	}
	file.store_string(JSON.stringify(data))

func show_main_menu() -> void:
	scene_background.texture = MAINPAGE_BACKGROUND
	scene_shade.hide()
	scene_header.hide()
	home_button.hide()
	game_footer.hide()
	modal.hide()
	for hotspot in hotspot_buttons:
		hotspot.hide()
	update_main_menu_stats()
	main_menu.show()
	main_menu.move_to_front()
	if player_name.is_empty() or player_gender.is_empty():
		name_input.text = player_name
		selected_gender = player_gender
		refresh_gender_buttons()
		name_prompt.show()
		name_prompt.move_to_front()
		name_input.grab_focus()
	else:
		name_prompt.hide()

func begin_bazaar_case() -> void:
	if player_name.is_empty() or player_gender.is_empty():
		name_prompt.show()
		name_prompt.move_to_front()
		return
	active_case_id = "bazaar_001"
	score = 50
	reset_investigation()
	main_menu.hide()
	update_clue_count()

func return_to_main_menu() -> void:
	if active_case_id == "library_002":
		leave_library_case()
		return
	reset_investigation()
	modal.hide()
	show_main_menu()

func begin_library_case() -> void:
	if player_name.is_empty() or player_gender.is_empty():
		name_prompt.show()
		name_prompt.move_to_front()
		return
	if not load_library_case_data():
		return
	active_case_id = "library_002"
	load_library_progress()
	main_menu.hide()
	hide_bazaar_case_ui()
	build_library_case_ui()
	library_layer.show()
	library_layer.move_to_front()
	show_library_stage_one()

func load_library_case_data() -> bool:
	if not library_case_data.is_empty():
		return true
	var file := FileAccess.open(LIBRARY_CASE_PATH, FileAccess.READ)
	if file == null:
		push_error("Library case data could not be opened.")
		return false
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK or not json.data is Dictionary:
		push_error("Library case data is invalid JSON.")
		return false
	library_case_data = json.data
	return str(library_case_data.get("case_id", "")) == "library_002"

func load_library_progress() -> void:
	library_score = int(library_case_data.get("initial_score", 60))
	library_found_clues.clear()
	library_stage_one_completed = false
	library_stage_two_started = false
	library_photo_seen = false
	library_stage_two_solved = false
	library_stage_three_started = false
	library_camera_count_solved = false
	library_camera_frame_solved = false
	library_photo_active = false
	library_photo_time_left = 0.0
	if not FileAccess.file_exists(LIBRARY_SAVE_PATH):
		return
	var file := FileAccess.open(LIBRARY_SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK or not json.data is Dictionary:
		return
	var data: Dictionary = json.data
	if str(data.get("case_id", "")) != "library_002":
		return
	library_score = clampi(int(data.get("score", library_score)), 0, int(library_case_data.get("initial_score", 60)))
	var clue_ids = data.get("clue_ids", [])
	if clue_ids is Array:
		for clue_id in clue_ids:
			library_found_clues[str(clue_id)] = true
	library_stage_one_completed = bool(data.get("stage_1_completed", false))
	library_stage_two_started = bool(data.get("stage_2_started", false))
	library_photo_seen = bool(data.get("stage_2_photo_seen", false))
	library_stage_two_solved = bool(data.get("stage_2_solved", false))
	library_stage_three_started = bool(data.get("stage_3_started", false))
	library_camera_count_solved = bool(data.get("camera_count_solved", false))
	library_camera_frame_solved = bool(data.get("camera_frame_solved", false))

func save_library_progress() -> void:
	var clue_ids: Array[String] = []
	for clue_id in library_found_clues.keys():
		clue_ids.append(str(clue_id))
	var file := FileAccess.open(LIBRARY_SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify({
		"save_version": 1,
		"case_id": "library_002",
		"score": library_score,
		"clue_ids": clue_ids,
		"stage_1_completed": library_stage_one_completed,
		"stage_2_started": library_stage_two_started,
		"stage_2_photo_seen": library_photo_seen,
		"stage_2_solved": library_stage_two_solved,
		"stage_3_started": library_stage_three_started,
		"camera_count_solved": library_camera_count_solved,
		"camera_frame_solved": library_camera_frame_solved,
		"case_status": "investigating"
	}))

func hide_bazaar_case_ui() -> void:
	scene_background.hide()
	scene_shade.hide()
	scene_header.hide()
	game_footer.hide()
	home_button.hide()
	modal.hide()
	notebook.hide()
	dialogue.hide()
	for hotspot in hotspot_buttons:
		hotspot.hide()

func leave_library_case() -> void:
	if library_layer:
		library_layer.hide()
	scene_background.show()
	active_case_id = ""
	show_main_menu()

func build_library_case_ui() -> void:
	if library_layer:
		return
	library_layer = Control.new()
	library_layer.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	library_layer.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(library_layer)
	library_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	library_background = TextureRect.new()
	library_background.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	library_background.stretch_mode = TextureRect.STRETCH_SCALE
	library_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	library_background.z_index = -20
	library_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	library_layer.add_child(library_background)
	library_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	build_library_header()
	build_library_footer()
	build_library_dialogue()
	build_library_modal()
	build_library_notebook()
	build_library_notebook_confirmation()
	build_library_photo_timer()

func build_library_header() -> void:
	library_header = PanelContainer.new()
	library_header.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_header.position = Vector2(28, 22)
	library_header.size = Vector2(400, 112)
	library_header.add_theme_stylebox_override("panel", panel_style(Color("123444e6"), Color("68b8c8"), 16, 2))
	library_layer.add_child(library_header)
	library_header.position = Vector2(28, 22)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 2)
	library_header.add_child(content)
	library_title_label = Label.new()
	library_title_label.text = "پروندهٔ دزد کتابخانه"
	library_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	library_title_label.text_direction = Control.TEXT_DIRECTION_RTL
	library_title_label.add_theme_font_size_override("font_size", 27)
	library_title_label.add_theme_color_override("font_color", Color("e9f8f8"))
	content.add_child(library_title_label)
	library_clue_count_label = Label.new()
	library_clue_count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	library_clue_count_label.text_direction = Control.TEXT_DIRECTION_RTL
	library_clue_count_label.add_theme_font_size_override("font_size", 19)
	library_clue_count_label.add_theme_color_override("font_color", Color("e1f5f6"))
	content.add_child(library_clue_count_label)
	library_score_label = Label.new()
	library_score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	library_score_label.text_direction = Control.TEXT_DIRECTION_RTL
	library_score_label.add_theme_font_size_override("font_size", 19)
	library_score_label.add_theme_color_override("font_color", Color("bdebf0"))
	content.add_child(library_score_label)

func build_library_footer() -> void:
	library_footer = PanelContainer.new()
	library_footer.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_footer.anchor_left = 0.5
	library_footer.anchor_top = 1.0
	library_footer.anchor_right = 0.5
	library_footer.anchor_bottom = 1.0
	library_footer.offset_left = -440
	library_footer.offset_top = -92
	library_footer.offset_right = 440
	library_footer.offset_bottom = -20
	library_footer.add_theme_stylebox_override("panel", panel_style(Color("123444e6"), Color("68b8c8"), 14, 2))
	library_layer.add_child(library_footer)
	library_footer.anchor_left = 0.5
	library_footer.anchor_top = 1.0
	library_footer.anchor_right = 0.5
	library_footer.anchor_bottom = 1.0
	library_footer.offset_left = -440
	library_footer.offset_top = -92
	library_footer.offset_right = 440
	library_footer.offset_bottom = -20
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 16)
	library_footer.add_child(row)
	library_prompt_label = Label.new()
	library_prompt_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	library_prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	library_prompt_label.text_direction = Control.TEXT_DIRECTION_RTL
	library_prompt_label.add_theme_font_size_override("font_size", 22)
	library_prompt_label.add_theme_color_override("font_color", Color("f2ffff"))
	row.add_child(library_prompt_label)
	var notebook_open := Button.new()
	notebook_open.text = "دفتر کارآگاه"
	notebook_open.custom_minimum_size = Vector2(165, 46)
	notebook_open.add_theme_font_size_override("font_size", 22)
	notebook_open.pressed.connect(request_library_notebook.bind(false))
	row.add_child(notebook_open)
	var home := Button.new()
	home.text = "صفحهٔ اصلی"
	home.custom_minimum_size = Vector2(150, 46)
	home.add_theme_font_size_override("font_size", 19)
	home.pressed.connect(leave_library_case)
	row.add_child(home)

func build_library_dialogue() -> void:
	library_dialogue_panel = PanelContainer.new()
	library_dialogue_panel.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_dialogue_panel.anchor_left = 0.5
	library_dialogue_panel.anchor_top = 1.0
	library_dialogue_panel.anchor_right = 0.5
	library_dialogue_panel.anchor_bottom = 1.0
	library_dialogue_panel.offset_left = -460
	library_dialogue_panel.offset_top = -365
	library_dialogue_panel.offset_right = 460
	library_dialogue_panel.offset_bottom = -187
	library_dialogue_panel.add_theme_stylebox_override("panel", panel_style(Color("123444ed"), Color("68b8c8"), 18, 3))
	library_layer.add_child(library_dialogue_panel)
	library_dialogue_panel.anchor_left = 0.5
	library_dialogue_panel.anchor_top = 1.0
	library_dialogue_panel.anchor_right = 0.5
	library_dialogue_panel.anchor_bottom = 1.0
	library_dialogue_panel.offset_left = -460
	library_dialogue_panel.offset_top = -365
	library_dialogue_panel.offset_right = 460
	library_dialogue_panel.offset_bottom = -187
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	library_dialogue_panel.add_child(content)
	library_dialogue_name = Label.new()
	library_dialogue_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	library_dialogue_name.text_direction = Control.TEXT_DIRECTION_RTL
	library_dialogue_name.add_theme_font_size_override("font_size", 27)
	library_dialogue_name.add_theme_color_override("font_color", Color("a8e1e9"))
	content.add_child(library_dialogue_name)
	library_dialogue_text = Label.new()
	library_dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	library_dialogue_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	library_dialogue_text.text_direction = Control.TEXT_DIRECTION_RTL
	library_dialogue_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	library_dialogue_text.add_theme_font_size_override("font_size", 25)
	library_dialogue_text.add_theme_color_override("font_color", Color("f4ffff"))
	content.add_child(library_dialogue_text)
	library_dialogue_next = Button.new()
	library_dialogue_next.text = "بررسی ویترین"
	library_dialogue_next.custom_minimum_size = Vector2(190, 46)
	library_dialogue_next.add_theme_font_size_override("font_size", 21)
	library_dialogue_next.pressed.connect(show_library_clue_scene)
	content.add_child(library_dialogue_next)

func build_library_modal() -> void:
	library_modal = PanelContainer.new()
	library_modal.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_modal.anchor_left = 0.5
	library_modal.anchor_top = 0.5
	library_modal.anchor_right = 0.5
	library_modal.anchor_bottom = 0.5
	library_modal.offset_left = -350
	library_modal.offset_top = -155
	library_modal.offset_right = 350
	library_modal.offset_bottom = 155
	library_modal.add_theme_stylebox_override("panel", panel_style(Color("123444f2"), Color("78cfda"), 18, 3))
	library_modal.hide()
	library_layer.add_child(library_modal)
	library_modal.anchor_left = 0.5
	library_modal.anchor_top = 0.5
	library_modal.anchor_right = 0.5
	library_modal.anchor_bottom = 0.5
	library_modal.offset_left = -350
	library_modal.offset_top = -155
	library_modal.offset_right = 350
	library_modal.offset_bottom = 155
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 14)
	library_modal.add_child(content)
	library_modal_title = Label.new()
	library_modal_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	library_modal_title.text_direction = Control.TEXT_DIRECTION_RTL
	library_modal_title.add_theme_font_size_override("font_size", 31)
	library_modal_title.add_theme_color_override("font_color", Color("a8e1e9"))
	content.add_child(library_modal_title)
	library_modal_text = Label.new()
	library_modal_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	library_modal_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	library_modal_text.text_direction = Control.TEXT_DIRECTION_RTL
	library_modal_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	library_modal_text.add_theme_font_size_override("font_size", 25)
	library_modal_text.add_theme_color_override("font_color", Color("f4ffff"))
	content.add_child(library_modal_text)
	library_modal_action = Button.new()
	library_modal_action.custom_minimum_size = Vector2(210, 46)
	library_modal_action.add_theme_font_size_override("font_size", 21)
	library_modal_action.pressed.connect(close_library_modal)
	content.add_child(library_modal_action)

func build_library_notebook() -> void:
	library_notebook = Control.new()
	library_notebook.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_notebook.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	library_notebook.mouse_filter = Control.MOUSE_FILTER_STOP
	library_notebook.hide()
	library_layer.add_child(library_notebook)
	library_notebook.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var background := TextureRect.new()
	background.layout_direction = Control.LAYOUT_DIRECTION_LTR
	background.texture = LIBRARY_NOTEBOOK_BACKGROUND
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	library_notebook.add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var title := Label.new()
	title.text = "دفتر کارآگاه"
	title.layout_direction = Control.LAYOUT_DIRECTION_LTR
	title.position = Vector2(672, 145)
	title.size = Vector2(335, 46)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	title.text_direction = Control.TEXT_DIRECTION_RTL
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("164350"))
	library_notebook.add_child(title)
	title.position = Vector2(672, 145)
	title.size = Vector2(335, 46)
	library_notebook_text = Label.new()
	library_notebook_text.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_notebook_text.position = Vector2(662, 225)
	library_notebook_text.size = Vector2(380, 215)
	library_notebook_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	library_notebook_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	library_notebook_text.text_direction = Control.TEXT_DIRECTION_RTL
	library_notebook_text.add_theme_font_size_override("font_size", 24)
	library_notebook_text.add_theme_constant_override("line_spacing", -3)
	library_notebook_text.add_theme_color_override("font_color", Color("214d57"))
	library_notebook.add_child(library_notebook_text)
	library_notebook_text.position = Vector2(662, 225)
	library_notebook_text.size = Vector2(380, 215)
	library_notebook_close = Button.new()
	library_notebook_close.text = "بستن دفتر"
	library_notebook_close.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_notebook_close.position = Vector2(265, 594)
	library_notebook_close.size = Vector2(190, 48)
	library_notebook_close.add_theme_font_size_override("font_size", 21)
	library_notebook_close.pressed.connect(close_library_notebook)
	library_notebook.add_child(library_notebook_close)
	library_notebook_close.position = Vector2(265, 594)

func build_library_notebook_confirmation() -> void:
	library_notebook_confirmation = PanelContainer.new()
	library_notebook_confirmation.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_notebook_confirmation.anchor_left = 0.5
	library_notebook_confirmation.anchor_top = 0.5
	library_notebook_confirmation.anchor_right = 0.5
	library_notebook_confirmation.anchor_bottom = 0.5
	library_notebook_confirmation.offset_left = -320
	library_notebook_confirmation.offset_top = -145
	library_notebook_confirmation.offset_right = 320
	library_notebook_confirmation.offset_bottom = 145
	library_notebook_confirmation.add_theme_stylebox_override("panel", panel_style(Color("123444f2"), Color("78cfda"), 18, 3))
	library_notebook_confirmation.hide()
	library_layer.add_child(library_notebook_confirmation)
	library_notebook_confirmation.anchor_left = 0.5
	library_notebook_confirmation.anchor_top = 0.5
	library_notebook_confirmation.anchor_right = 0.5
	library_notebook_confirmation.anchor_bottom = 0.5
	library_notebook_confirmation.offset_left = -320
	library_notebook_confirmation.offset_top = -145
	library_notebook_confirmation.offset_right = 320
	library_notebook_confirmation.offset_bottom = 145
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 14)
	library_notebook_confirmation.add_child(content)
	var message := Label.new()
	message.text = "مرور دفتر کارآگاه ۵ امتیاز کم می‌کند. ادامه می‌دهی؟"
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	message.text_direction = Control.TEXT_DIRECTION_RTL
	message.add_theme_font_size_override("font_size", 26)
	message.add_theme_color_override("font_color", Color("f4ffff"))
	content.add_child(message)
	var buttons := HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_theme_constant_override("separation", 16)
	content.add_child(buttons)
	var cancel := Button.new()
	cancel.text = "فعلاً نه"
	cancel.custom_minimum_size = Vector2(170, 46)
	cancel.add_theme_font_size_override("font_size", 21)
	cancel.pressed.connect(func() -> void: library_notebook_confirmation.hide())
	buttons.add_child(cancel)
	var confirm := Button.new()
	confirm.text = "بله"
	confirm.custom_minimum_size = Vector2(170, 46)
	confirm.add_theme_font_size_override("font_size", 21)
	confirm.pressed.connect(confirm_library_notebook_cost)
	buttons.add_child(confirm)

func build_library_photo_timer() -> void:
	library_timer_label = Label.new()
	library_timer_label.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_timer_label.position = Vector2(1080, 26)
	library_timer_label.size = Vector2(170, 52)
	library_timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	library_timer_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	library_timer_label.text_direction = Control.TEXT_DIRECTION_RTL
	library_timer_label.add_theme_font_size_override("font_size", 25)
	library_timer_label.add_theme_color_override("font_color", Color("f4ffff"))
	library_timer_label.add_theme_stylebox_override("normal", panel_style(Color("123444e6"), Color("78cfda"), 14, 2))
	library_timer_label.hide()
	library_layer.add_child(library_timer_label)
	library_timer_label.position = Vector2(1080, 26)
	library_timer_label.size = Vector2(170, 52)

func show_library_stage_one() -> void:
	clear_library_hotspots()
	library_modal.hide()
	library_notebook.hide()
	library_notebook_confirmation.hide()
	library_photo_active = false
	if library_timer_label:
		library_timer_label.hide()
	if library_choice_panel:
		library_choice_panel.hide()
	if library_stage_one_completed:
		show_library_stage_two()
		return
	library_background.texture = LIBRARY_DIALOGUE_BACKGROUND
	var stage: Dictionary = library_case_data.get("stage_1", {})
	var dialogue_data: Dictionary = stage.get("dialogue", {})
	library_dialogue_name.text = str(dialogue_data.get("speaker", "آقای براتی"))
	library_dialogue_text.text = str(dialogue_data.get("text", ""))
	if library_dialogue_next.pressed.is_connected(show_library_stage_two_photo):
		library_dialogue_next.pressed.disconnect(show_library_stage_two_photo)
	if not library_dialogue_next.pressed.is_connected(show_library_clue_scene):
		library_dialogue_next.pressed.connect(show_library_clue_scene)
	library_dialogue_next.text = "بررسی ویترین"
	library_dialogue_panel.show()
	library_prompt_label.text = "بیا از آقای براتی بپرسیم چه شده."
	update_library_score_label()

func show_library_clue_scene() -> void:
	library_dialogue_panel.hide()
	library_background.texture = LIBRARY_CLUE_BACKGROUND
	var stage: Dictionary = library_case_data.get("stage_1", {})
	library_prompt_label.text = str(stage.get("scene_prompt", "ویترین را بررسی کن."))
	build_library_stage_hotspots()

func build_library_stage_hotspots() -> void:
	clear_library_hotspots()
	var stage: Dictionary = library_case_data.get("stage_1", {})
	var hotspots = stage.get("hotspots", [])
	if not hotspots is Array:
		return
	for hotspot_data in hotspots:
		if not hotspot_data is Dictionary:
			continue
		var hotspot: Dictionary = hotspot_data
		var position_data: Array = hotspot.get("position", [0.5, 0.5])
		var size_data: Array = hotspot.get("size", [0.1, 0.1])
		var button := Button.new()
		button.layout_direction = Control.LAYOUT_DIRECTION_LTR
		button.top_level = true
		button.flat = true
		button.z_index = -5
		button.tooltip_text = "بررسی: " + str(hotspot.get("title", ""))
		button.size = Vector2(float(size_data[0]) * 1280.0, float(size_data[1]) * 720.0)
		button.pressed.connect(show_library_hotspot.bind(hotspot, button))
		var marker := Panel.new()
		marker.layout_direction = Control.LAYOUT_DIRECTION_LTR
		marker.position = button.size * 0.5 - Vector2(12, 12)
		marker.size = Vector2(24, 24)
		marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
		marker.add_theme_stylebox_override("panel", panel_style(Color("ffbf4d"), Color("fff1b0"), 12, 2))
		button.add_child(marker)
		marker.position = button.size * 0.5 - Vector2(12, 12)
		library_layer.add_child(button)
		# A top-level hotspot keeps its 1280×720 hit rectangle independent from
		# Android's RTL layout pass. Set it only after it has a parent.
		button.global_position = Vector2(float(position_data[0]) * 1280.0, float(position_data[1]) * 720.0) - button.size * 0.5
		if bool(hotspot.get("is_clue", false)) and library_found_clues.has(str(hotspot.get("id", ""))):
			button.disabled = true
			button.hide()
		library_stage_hotspots.append(button)

func clear_library_hotspots() -> void:
	for hotspot in library_stage_hotspots:
		if is_instance_valid(hotspot):
			hotspot.queue_free()
	library_stage_hotspots.clear()

func show_library_hotspot(hotspot: Dictionary, button: Button) -> void:
	var hotspot_id := str(hotspot.get("id", ""))
	library_modal_title.text = str(hotspot.get("title", ""))
	library_modal_text.text = str(hotspot.get("description", ""))
	if bool(hotspot.get("is_clue", false)):
		library_found_clues[hotspot_id] = true
		button.disabled = true
		button.hide()
		save_library_progress()
		update_library_score_label()
		library_key_modal_open = library_all_stage_one_clues_found()
		library_modal_action.text = "دیدن دفتر کارآگاه" if library_key_modal_open else "ادامهٔ جست‌وجو"
	else:
		library_key_modal_open = false
		library_modal_action.text = "ادامهٔ جست‌وجو"
	library_modal.show()
	library_modal.move_to_front()

func close_library_modal() -> void:
	library_modal.hide()
	if library_key_modal_open:
		library_key_modal_open = false
		library_stage_one_completed = true
		save_library_progress()
		request_library_notebook(true)

func request_library_notebook(is_story_required: bool) -> void:
	if is_story_required:
		open_library_notebook()
		return
	library_notebook_confirmation.show()
	library_notebook_confirmation.move_to_front()

func confirm_library_notebook_cost() -> void:
	library_notebook_confirmation.hide()
	library_score = maxi(0, library_score - 5)
	save_library_progress()
	update_library_score_label()
	open_library_notebook()

func open_library_notebook() -> void:
	var stage: Dictionary = library_case_data.get("stage_1", {})
	if not library_found_clues.is_empty():
		var entries: Array[String] = []
		var hotspots = stage.get("hotspots", [])
		if hotspots is Array:
			for hotspot_data in hotspots:
				if not hotspot_data is Dictionary:
					continue
				var hotspot: Dictionary = hotspot_data
				if library_found_clues.has(str(hotspot.get("id", ""))):
					entries.append("• " + str(hotspot.get("notebook_entry", hotspot.get("description", ""))))
		var stage_two: Dictionary = library_case_data.get("stage_2", {})
		var stage_two_clue: Dictionary = stage_two.get("clue", {})
		if library_found_clues.has(str(stage_two_clue.get("id", ""))):
			entries.append("• " + str(stage_two_clue.get("notebook_entry", "")))
		library_notebook_text.text = "\n".join(entries)
	else:
		library_notebook_text.text = "هنوز سرنخی پیدا نکردی. ویترین را نگاه کن."
	library_header.hide()
	library_footer.hide()
	library_notebook.show()
	library_notebook.move_to_front()

func close_library_notebook() -> void:
	library_notebook.hide()
	library_header.show()
	library_footer.show()
	if library_stage_one_completed:
		var stage: Dictionary = library_case_data.get("stage_1", {})
		library_prompt_label.text = str(stage.get("completion_text", "مرحلهٔ اول کامل شد."))
		if not library_stage_two_started:
			show_library_stage_two()

func show_library_stage_two() -> void:
	clear_library_hotspots()
	library_modal.hide()
	library_notebook_confirmation.hide()
	library_photo_active = false
	if library_timer_label:
		library_timer_label.hide()
	if library_choice_panel:
		library_choice_panel.hide()
	library_stage_two_started = true
	save_library_progress()
	if library_stage_two_solved:
		show_library_stage_three()
		return
	if library_photo_seen:
		show_library_stage_two_question()
		return
	var stage: Dictionary = library_case_data.get("stage_2", {})
	var dialogue_data: Dictionary = stage.get("dialogue", {})
	library_background.texture = LIBRARY_CLUE_BACKGROUND
	library_dialogue_name.text = str(dialogue_data.get("speaker", "خانم شریفی"))
	library_dialogue_text.text = str(dialogue_data.get("text", ""))
	if library_dialogue_next.pressed.is_connected(show_library_clue_scene):
		library_dialogue_next.pressed.disconnect(show_library_clue_scene)
	if not library_dialogue_next.pressed.is_connected(show_library_stage_two_photo):
		library_dialogue_next.pressed.connect(show_library_stage_two_photo)
	library_dialogue_next.text = "دیدن عکس"
	library_dialogue_panel.show()
	library_prompt_label.text = "به عکس خانم شریفی خوب نگاه کن."

func show_library_stage_two_photo() -> void:
	library_dialogue_panel.hide()
	if library_choice_panel:
		library_choice_panel.hide()
	var stage: Dictionary = library_case_data.get("stage_2", {})
	library_background.texture = LIBRARY_PHOTO_BACKGROUND
	library_photo_time_left = float(stage.get("photo_seconds", 10))
	library_photo_active = true
	library_timer_label.show()
	update_library_photo_timer()
	library_prompt_label.text = "عکس را با دقت ببین!"

func update_library_photo_timer() -> void:
	if library_timer_label:
		library_timer_label.text = "زمان: %d" % ceili(library_photo_time_left)

func finish_library_stage_two_photo() -> void:
	library_photo_active = false
	library_photo_seen = true
	save_library_progress()
	if library_timer_label:
		library_timer_label.hide()
	show_library_stage_two_question()

func show_library_stage_two_question() -> void:
	library_background.texture = LIBRARY_CLUE_BACKGROUND
	library_dialogue_panel.hide()
	var stage: Dictionary = library_case_data.get("stage_2", {})
	library_prompt_label.text = "عکس بسته شد. حالا جواب بده."
	build_library_choice_panel(str(stage.get("question", "")), stage.get("answers", []), "معمای عکس", answer_library_stage_two)

func build_library_choice_panel(question: String, answers, title_text: String, answer_handler: Callable) -> void:
	if library_choice_panel:
		library_choice_panel.queue_free()
		library_choice_panel = null
	library_choice_buttons.clear()
	library_continue_button = null
	library_choice_panel = PanelContainer.new()
	library_choice_panel.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_choice_panel.anchor_left = 0.5
	library_choice_panel.anchor_top = 0.5
	library_choice_panel.anchor_right = 0.5
	library_choice_panel.anchor_bottom = 0.5
	library_choice_panel.offset_left = -455
	library_choice_panel.offset_top = -205
	library_choice_panel.offset_right = 455
	library_choice_panel.offset_bottom = 205
	library_choice_panel.add_theme_stylebox_override("panel", panel_style(Color("123444f2"), Color("78cfda"), 18, 3))
	library_layer.add_child(library_choice_panel)
	library_choice_panel.anchor_left = 0.5
	library_choice_panel.anchor_top = 0.5
	library_choice_panel.anchor_right = 0.5
	library_choice_panel.anchor_bottom = 0.5
	library_choice_panel.offset_left = -455
	library_choice_panel.offset_top = -205
	library_choice_panel.offset_right = 455
	library_choice_panel.offset_bottom = 205
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	library_choice_panel.add_child(content)
	var title := Label.new()
	title.text = title_text
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	title.text_direction = Control.TEXT_DIRECTION_RTL
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("a8e1e9"))
	content.add_child(title)
	var question_label := Label.new()
	question_label.text = question
	question_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	question_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	question_label.text_direction = Control.TEXT_DIRECTION_RTL
	question_label.add_theme_font_size_override("font_size", 25)
	question_label.add_theme_color_override("font_color", Color("f4ffff"))
	content.add_child(question_label)
	if answers is Array:
		for answer_data in answers:
			if not answer_data is Dictionary:
				continue
			var answer: Dictionary = answer_data
			var choice := Button.new()
			choice.layout_direction = Control.LAYOUT_DIRECTION_LTR
			choice.text = str(answer.get("text", ""))
			choice.custom_minimum_size = Vector2(680, 44)
			choice.text_direction = Control.TEXT_DIRECTION_RTL
			choice.alignment = HORIZONTAL_ALIGNMENT_RIGHT
			choice.add_theme_font_size_override("font_size", 20)
			choice.pressed.connect(answer_handler.bind(bool(answer.get("correct", false))))
			content.add_child(choice)
			library_choice_buttons.append(choice)
	library_choice_status = Label.new()
	library_choice_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	library_choice_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	library_choice_status.text_direction = Control.TEXT_DIRECTION_RTL
	library_choice_status.add_theme_font_size_override("font_size", 21)
	library_choice_status.add_theme_color_override("font_color", Color("fff0a5"))
	content.add_child(library_choice_status)
	library_choice_panel.show()
	library_choice_panel.move_to_front()

func show_library_choice_continue(text: String, action: Callable) -> void:
	if not library_choice_status or not is_instance_valid(library_choice_status):
		return
	library_continue_button = Button.new()
	library_continue_button.layout_direction = Control.LAYOUT_DIRECTION_LTR
	library_continue_button.text = text
	library_continue_button.text_direction = Control.TEXT_DIRECTION_RTL
	library_continue_button.add_theme_font_size_override("font_size", 21)
	library_continue_button.custom_minimum_size = Vector2(310, 46)
	library_continue_button.pressed.connect(action)
	library_choice_status.get_parent().add_child(library_continue_button)

func answer_library_stage_two(is_correct: bool) -> void:
	if library_stage_two_solved:
		return
	var stage: Dictionary = library_case_data.get("stage_2", {})
	if not is_correct:
		library_score = maxi(0, library_score - 1)
		library_choice_status.text = str(stage.get("wrong_feedback", "پاسخ درست نبود."))
		save_library_progress()
		update_library_score_label()
		return
	library_stage_two_solved = true
	var clue: Dictionary = stage.get("clue", {})
	library_found_clues[str(clue.get("id", "brown_bag_near_display"))] = true
	for choice in library_choice_buttons:
		choice.disabled = true
	library_choice_status.text = str(stage.get("correct_feedback", "آفرین!")) + " سرنخ در دفتر ثبت شد."
	save_library_progress()
	update_library_score_label()
	show_library_choice_continue("رفتن به دوربین‌ها", show_library_stage_three)

func show_library_stage_three() -> void:
	clear_library_hotspots()
	library_modal.hide()
	library_notebook_confirmation.hide()
	library_photo_active = false
	if library_timer_label:
		library_timer_label.hide()
	if library_choice_panel:
		library_choice_panel.hide()
	library_stage_three_started = true
	save_library_progress()
	library_background.texture = LIBRARY_CAMERA_BACKGROUND
	if library_camera_frame_solved:
		library_dialogue_panel.hide()
		library_prompt_label.text = "تصویر درست دوربین پیدا شد: قاب B."
		return
	if library_camera_count_solved:
		show_library_stage_three_frame_question()
		return
	var stage: Dictionary = library_case_data.get("stage_3", {})
	var dialogue_data: Dictionary = stage.get("dialogue", {})
	library_dialogue_name.text = str(dialogue_data.get("speaker", "آقای براتی"))
	library_dialogue_text.text = str(dialogue_data.get("text", ""))
	if library_dialogue_next.pressed.is_connected(show_library_stage_two_photo):
		library_dialogue_next.pressed.disconnect(show_library_stage_two_photo)
	if not library_dialogue_next.pressed.is_connected(show_library_stage_three_math_question):
		library_dialogue_next.pressed.connect(show_library_stage_three_math_question)
	library_dialogue_next.text = "شروع حساب"
	library_dialogue_panel.show()
	library_prompt_label.text = "اول تعداد آدم‌های داخل سالن را حساب کن."

func show_library_stage_three_math_question() -> void:
	library_background.texture = LIBRARY_CAMERA_BACKGROUND
	library_dialogue_panel.hide()
	var stage: Dictionary = library_case_data.get("stage_3", {})
	library_prompt_label.text = "یادت باشد: دو نفر فقط از سالن نمایش بیرون رفته‌اند."
	build_library_choice_panel(str(stage.get("math_question", "")), stage.get("math_answers", []), "حساب دوربین", answer_library_stage_three_math)

func answer_library_stage_three_math(is_correct: bool) -> void:
	var stage: Dictionary = library_case_data.get("stage_3", {})
	if not is_correct:
		library_score = maxi(0, library_score - 1)
		library_choice_status.text = str(stage.get("wrong_feedback", "پاسخ درست نبود."))
		save_library_progress()
		update_library_score_label()
		return
	library_camera_count_solved = true
	for choice in library_choice_buttons:
		choice.disabled = true
	library_choice_status.text = str(stage.get("math_correct_feedback", "آفرین!"))
	save_library_progress()
	show_library_choice_continue("انتخاب تصویر دوربین", show_library_stage_three_frame_question)

func show_library_stage_three_frame_question() -> void:
	library_background.texture = LIBRARY_CAMERA_BACKGROUND
	library_dialogue_panel.hide()
	var stage: Dictionary = library_case_data.get("stage_3", {})
	library_prompt_label.text = "سه قاب را نگاه کن و قابی را انتخاب کن که ۶ نفر دارد."
	build_library_choice_panel(str(stage.get("frame_question", "")), stage.get("frame_answers", []), "انتخاب قاب دوربین", answer_library_stage_three_frame)

func answer_library_stage_three_frame(is_correct: bool) -> void:
	var stage: Dictionary = library_case_data.get("stage_3", {})
	if not is_correct:
		library_score = maxi(0, library_score - 1)
		library_choice_status.text = str(stage.get("wrong_feedback", "پاسخ درست نبود."))
		save_library_progress()
		update_library_score_label()
		return
	library_camera_frame_solved = true
	for choice in library_choice_buttons:
		choice.disabled = true
	library_choice_status.text = str(stage.get("frame_correct_feedback", "آفرین!"))
	save_library_progress()
	update_library_score_label()


func update_library_score_label() -> void:
	if library_score_label:
		library_score_label.text = "امتیاز پرونده: %d" % library_score
	if library_clue_count_label:
		var stage: Dictionary = library_case_data.get("stage_1", {})
		var clue_total := 0
		var found_stage_one_clues := 0
		var hotspots = stage.get("hotspots", [])
		if hotspots is Array:
			for hotspot_data in hotspots:
				if hotspot_data is Dictionary and bool(hotspot_data.get("is_clue", false)):
					clue_total += 1
					if library_found_clues.has(str(hotspot_data.get("id", ""))):
						found_stage_one_clues += 1
		library_clue_count_label.text = "سرنخ‌ها: %d از %d" % [found_stage_one_clues, clue_total]

func library_all_stage_one_clues_found() -> bool:
	var stage: Dictionary = library_case_data.get("stage_1", {})
	var hotspots = stage.get("hotspots", [])
	var clue_total := 0
	if hotspots is Array:
		for hotspot_data in hotspots:
			if hotspot_data is Dictionary and bool(hotspot_data.get("is_clue", false)):
				clue_total += 1
	return clue_total > 0 and library_found_clues.size() >= clue_total

func build_header() -> void:
	scene_header = PanelContainer.new()
	scene_header.layout_direction = Control.LAYOUT_DIRECTION_LTR
	scene_header.position = Vector2(28, 22)
	scene_header.size = Vector2(430, 92)
	scene_header.add_theme_stylebox_override("panel", panel_style(Color(0.10, 0.055, 0.027, 0.81), Color(0.88, 0.64, 0.25, 0.85), 16, 2))
	add_child(scene_header)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 2)
	scene_header.add_child(content)
	var title := Label.new()
	title.text = "راز بازار بزرگ"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	title.text_direction = Control.TEXT_DIRECTION_RTL
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color("ffe0a0"))
	content.add_child(title)
	clue_count_label = Label.new()
	clue_count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	clue_count_label.text_direction = Control.TEXT_DIRECTION_RTL
	clue_count_label.add_theme_font_size_override("font_size", 19)
	clue_count_label.add_theme_color_override("font_color", Color("f5ead8"))
	content.add_child(clue_count_label)
	score_label = Label.new()
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	score_label.text_direction = Control.TEXT_DIRECTION_RTL
	score_label.add_theme_font_size_override("font_size", 19)
	score_label.add_theme_color_override("font_color", Color("ffe09a"))
	content.add_child(score_label)
	update_clue_count()
	home_button = Button.new()
	home_button.layout_direction = Control.LAYOUT_DIRECTION_LTR
	home_button.text = "صفحهٔ اصلی"
	home_button.anchor_left = 1.0
	home_button.anchor_top = 0.0
	home_button.anchor_right = 1.0
	home_button.anchor_bottom = 0.0
	home_button.offset_left = -205
	home_button.offset_top = 24
	home_button.offset_right = -28
	home_button.offset_bottom = 72
	home_button.add_theme_font_size_override("font_size", 19)
	home_button.pressed.connect(return_to_main_menu)
	add_child(home_button)

func build_hotspots() -> void:
	for clue in CLUES:
		var button := Button.new()
		button.layout_direction = Control.LAYOUT_DIRECTION_LTR
		# Hotspots use coordinates from the 1280×720 scene reference.  Keeping
		# them top-level prevents Android RTL layout from transforming both their
		# drawing position and their hit rectangle.
		button.top_level = true
		button.name = "Hotspot_" + clue.id
		# Markers stay above the scene but below all panels, labels, and buttons.
		button.z_index = -5
		var base_size := Vector2(clue.size.x * 1280.0, clue.size.y * 720.0)
		var hotspot_position := Vector2(clue.position.x * 1280.0, clue.position.y * 720.0) - base_size * 0.2
		button.position = hotspot_position
		button.size = base_size * 1.4
		button.tooltip_text = "بررسی: " + clue.title
		button.flat = true
		# A text glyph for the hotspot can be missing on Android fonts.  Draw a
		# small marker instead, while retaining the larger invisible tap target.
		var marker := Panel.new()
		marker.layout_direction = Control.LAYOUT_DIRECTION_LTR
		marker.position = button.size * 0.5 - Vector2(12, 12)
		marker.size = Vector2(24, 24)
		marker.add_theme_stylebox_override("panel", panel_style(Color("fff238"), Color("fff9a8"), 12, 2))
		marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(marker)
		button.modulate = Color(1, 0.95, 0.25, 0.8)
		button.pressed.connect(show_clue.bind(clue, button))
		add_child(button)
		# Reparenting a top-level Control on an RTL Android viewport can change its
		# local position. Set the final canvas position after it has a parent.
		button.global_position = hotspot_position
		hotspot_buttons.append(button)

func build_footer() -> void:
	game_footer = PanelContainer.new()
	game_footer.layout_direction = Control.LAYOUT_DIRECTION_LTR
	game_footer.anchor_left = 0.5
	game_footer.anchor_top = 1.0
	game_footer.anchor_right = 0.5
	game_footer.anchor_bottom = 1.0
	game_footer.offset_left = -390
	game_footer.offset_top = -94
	game_footer.offset_right = 390
	game_footer.offset_bottom = -24
	game_footer.add_theme_stylebox_override("panel", panel_style(Color(0.10, 0.055, 0.027, 0.792), Color(0.88, 0.64, 0.25, 0.75), 14, 2))
	add_child(game_footer)
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 18)
	game_footer.add_child(row)
	prompt_label = Label.new()
	prompt_label.text = "نقطه‌های طلایی را پیدا کن و بزن روشون!"
	prompt_label.text_direction = Control.TEXT_DIRECTION_RTL
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	prompt_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	prompt_label.add_theme_font_size_override("font_size", 24)
	prompt_label.add_theme_color_override("font_color", Color("fff1d3"))
	row.add_child(prompt_label)
	var reset := Button.new()
	reset.text = "شروع دوباره"
	reset.custom_minimum_size = Vector2(145, 44)
	reset.add_theme_font_size_override("font_size", 24)
	reset.pressed.connect(reset_investigation)
	row.add_child(reset)
	notebook_button = Button.new()
	notebook_button.text = "دفتر کارآگاه"
	notebook_button.custom_minimum_size = Vector2(155, 44)
	notebook_button.add_theme_font_size_override("font_size", 24)
	notebook_button.disabled = true
	notebook_button.pressed.connect(open_notebook)
	row.add_child(notebook_button)

func build_clue_panel() -> void:
	modal = PanelContainer.new()
	modal.anchor_left = 0.5
	modal.anchor_top = 0.5
	modal.anchor_right = 0.5
	modal.anchor_bottom = 0.5
	modal.offset_left = -350
	modal.offset_top = -155
	modal.offset_right = 350
	modal.offset_bottom = 155
	modal.visible = false
	modal.add_theme_stylebox_override("panel", panel_style(Color(0.12, 0.067, 0.032, 0.738), Color(0.96, 0.74, 0.31, 1), 18, 3))
	add_child(modal)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	modal.add_child(box)
	modal_title = Label.new()
	modal_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	modal_title.text_direction = Control.TEXT_DIRECTION_RTL
	modal_title.add_theme_font_size_override("font_size", 35)
	modal_title.add_theme_color_override("font_color", Color("ffe09a"))
	box.add_child(modal_title)
	modal_description = Label.new()
	modal_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	modal_description.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	modal_description.text_direction = Control.TEXT_DIRECTION_RTL
	modal_description.size_flags_vertical = Control.SIZE_EXPAND_FILL
	modal_description.add_theme_font_size_override("font_size", 28)
	modal_description.add_theme_color_override("font_color", Color("fff6e6"))
	box.add_child(modal_description)
	modal_close_button = Button.new()
	modal_close_button.text = "ادامهٔ جست‌وجو"
	modal_close_button.custom_minimum_size = Vector2(190, 46)
	modal_close_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	modal_close_button.add_theme_font_size_override("font_size", 22)
	modal_close_button.pressed.connect(close_clue_panel)
	box.add_child(modal_close_button)
	build_notebook()

func show_clue(clue: Dictionary, button: Button) -> void:
	if intro_active:
		return
	var first_discovery := not found_clues.has(clue.id)
	found_clues[clue.id] = true
	button.disabled = true
	button.tooltip_text = "بررسی شد: " + clue.title
	modal_title.text = clue.title
	if clue.id == "number_paper":
		modal_description.text = "یه کاغذ کوچیک با این چهار عدد پیدا کردی: %s. شاید رمز قفل باشه!" % format_code(lock_code)
	else:
		modal_description.text = clue.description
	modal.show()
	update_clue_count()
	if first_discovery:
		prompt_label.text = "آفرین! یه سرنخ پیدا کردی. بقیه را هم پیدا کن."
	if found_clues.size() == CLUES.size():
		prompt_label.text = "آفرین! هر پنج سرنخ را پیدا کردی. حالا دفتر کارآگاه را ببینیم."
		modal_close_button.text = "باز کردن دفتر کارآگاه"
		notebook_button.disabled = false

func close_clue_panel() -> void:
	if intro_active:
		intro_active = false
		modal.hide()
		modal_close_button.text = "ادامهٔ جست‌وجو"
		prompt_label.text = "پنج سرنخ را پیدا کن تا بفهمیم چه کسی پلاک را برداشته."
		return
	modal.hide()
	if found_clues.size() == CLUES.size():
		open_notebook()

func show_intro() -> void:
	intro_active = true
	modal_title.text = "درخواست استاد قلم‌زن"
	modal_description.text = "یه پلاک مهم از جعبهٔ من گم شده. باید فردا برای نمایشگاه آماده باشه. شاگردم فکر می‌کرد نشان روی پلاک کم‌رنگ شده. گفتم بعداً با هم نگاهش می‌کنیم. حالا سرنخ‌ها را پیدا کن تا بفهمیم چی شده. این پرونده 50 تا سکه داره."
	modal_close_button.text = "پیدا کردن سرنخ"
	modal.show()

func reset_investigation() -> void:
	found_clues.clear()
	time_puzzle_solved = false
	cabinet_unlocked = false
	packaging_solved = false
	case_step = 0
	case_completed = false
	selected_symbols.clear()
	generate_lock_code()
	generate_time_delay()
	update_notebook_code_text()
	modal.hide()
	notebook.hide()
	game_footer.show()
	scene_shade.show()
	scene_header.show()
	home_button.show()
	dialogue.hide()
	if route_panel:
		route_panel.hide()
	if assistant_panel:
		assistant_panel.hide()
	if lock_panel:
		lock_panel.hide()
	if packaging_panel:
		packaging_panel.hide()
	if case_panel:
		case_panel.hide()
	if score_confirmation:
		score_confirmation.hide()
	scene_background.texture = BACKGROUND
	notebook_button.disabled = true
	modal_close_button.text = "ادامهٔ جست‌وجو"
	prompt_label.text = ""
	for button in hotspot_buttons:
		button.disabled = false
		button.show()
		button.tooltip_text = "بررسی سرنخ"
	update_clue_count()
	show_intro()

func update_clue_count() -> void:
	clue_count_label.text = "حجرهٔ استاد قلم‌زن  •  سرنخ‌ها: %d از %d" % [found_clues.size(), CLUES.size()]
	score_label.text = "امتیاز پرونده: %d سکه" % score

func lose_score(amount: int) -> void:
	score = maxi(0, score - amount)
	update_clue_count()

func _process(delta: float) -> void:
	pulse_time += delta
	for button in hotspot_buttons:
		if not button.disabled:
			button.modulate = Color(1.0, 0.96, 0.24, 0.62 + (sin(pulse_time * 2.4) + 1.0) * 0.16)
	if library_photo_active:
		library_photo_time_left = maxf(0.0, library_photo_time_left - delta)
		update_library_photo_timer()
		if library_photo_time_left <= 0.0:
			finish_library_stage_two_photo()

func _input(event: InputEvent) -> void:
	# The visual card buttons are painted into the menu background. Some Android
	# devices deliver the touch to the full-screen menu control instead of its
	# transparent TextureButton, so start the unlocked case from that same touch.
	if not main_menu or not main_menu.visible:
		return
	if event is InputEventScreenTouch and event.pressed and BAZAAR_CASE_BUTTON_RECT.has_point(event.position):
		begin_bazaar_case()
		get_viewport().set_input_as_handled()
		return
	if event is InputEventScreenTouch and event.pressed and LOCKED_CASE_BUTTON_RECTS[0].has_point(event.position):
		begin_library_case()
		get_viewport().set_input_as_handled()

func build_notebook() -> void:
	notebook = Control.new()
	# The notebook artwork already fills the complete 1280×720 reference canvas.
	# Give its interactive layer that same explicit rectangle instead of centering
	# a nested control: inherited RTL layout had collapsed this container on Android.
	notebook.layout_direction = Control.LAYOUT_DIRECTION_LTR
	notebook.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	notebook.visible = false
	add_child(notebook)
	var title := Label.new()
	title.layout_direction = Control.LAYOUT_DIRECTION_LTR
	title.text = "دفتر کارآگاه"
	title.position = Vector2(600, 150)
	title.size = Vector2(360, 42)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	title.text_direction = Control.TEXT_DIRECTION_RTL
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color("57351e"))
	notebook.add_child(title)
	var intro := Label.new()
	intro.layout_direction = Control.LAYOUT_DIRECTION_LTR
	intro.text = "سرنخ‌های پرونده"
	intro.position = Vector2(620, 195)
	intro.size = Vector2(360, 30)
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	intro.text_direction = Control.TEXT_DIRECTION_RTL
	intro.add_theme_font_size_override("font_size", 22)
	intro.add_theme_color_override("font_color", Color("57351e"))
	notebook.add_child(intro)
	notebook_clues_text = Label.new()
	notebook_clues_text.layout_direction = Control.LAYOUT_DIRECTION_LTR
	notebook_clues_text.position = Vector2(590, 235)
	notebook_clues_text.size = Vector2(400, 235)
	notebook_clues_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	notebook_clues_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	notebook_clues_text.text_direction = Control.TEXT_DIRECTION_RTL
	notebook_clues_text.add_theme_font_size_override("font_size", 19)
	notebook_clues_text.add_theme_color_override("font_color", Color("57351e"))
	notebook.add_child(notebook_clues_text)
	update_notebook_code_text()
	notebook_talk_button = Button.new()
	notebook_talk_button.layout_direction = Control.LAYOUT_DIRECTION_LTR
	notebook_talk_button.text = "با استاد حرف بزنیم"
	notebook_talk_button.position = Vector2(260, 535)
	notebook_talk_button.size = Vector2(220, 42)
	notebook_talk_button.custom_minimum_size = Vector2(210, 46)
	notebook_talk_button.add_theme_font_size_override("font_size", 22)
	notebook_talk_button.pressed.connect(open_dialogue)
	notebook.add_child(notebook_talk_button)
	# Set positioned buttons after parenting: otherwise Android's RTL locale
	# mirrors their X coordinate during attachment.
	notebook_talk_button.position = Vector2(260, 535)
	var close := Button.new()
	close.layout_direction = Control.LAYOUT_DIRECTION_LTR
	close.text = "بستن دفتر"
	close.position = Vector2(260, 595)
	close.size = Vector2(220, 42)
	close.custom_minimum_size = Vector2(195, 46)
	close.add_theme_font_size_override("font_size", 22)
	close.pressed.connect(close_notebook)
	notebook.add_child(close)
	close.position = Vector2(260, 595)
	build_dialogue()

func open_notebook() -> void:
	if lock_panel != null and lock_panel.visible and not cabinet_unlocked:
		show_notebook_score_confirmation()
		return
	open_notebook_screen()

func open_notebook_screen() -> void:
	if found_clues.size() == CLUES.size():
		modal.hide()
		notebook_return_texture = scene_background.texture
		scene_background.texture = NOTEBOOK_BACKGROUND
		scene_shade.hide()
		scene_header.hide()
		game_footer.hide()
		for hotspot in hotspot_buttons:
			hotspot.hide()
		home_button.hide()
		lock_was_visible = lock_panel != null and lock_panel.visible
		if lock_was_visible:
			lock_panel.hide()
		packaging_was_visible = packaging_panel != null and packaging_panel.visible
		if packaging_was_visible:
			packaging_panel.hide()
		notebook_talk_button.visible = not time_puzzle_solved
		notebook.move_to_front()
		notebook.show()

func show_notebook_score_confirmation() -> void:
	if not score_confirmation:
		score_confirmation = PanelContainer.new()
		score_confirmation.anchor_left = 0.5
		score_confirmation.anchor_top = 0.5
		score_confirmation.anchor_right = 0.5
		score_confirmation.anchor_bottom = 0.5
		score_confirmation.offset_left = -300
		score_confirmation.offset_top = -150
		score_confirmation.offset_right = 300
		score_confirmation.offset_bottom = 150
		score_confirmation.add_theme_stylebox_override("panel", panel_style(Color(0.10, 0.055, 0.027, 0.82), Color(0.96, 0.74, 0.31, 1), 18, 3))
		add_child(score_confirmation)
		var content := VBoxContainer.new()
		content.add_theme_constant_override("separation", 14)
		score_confirmation.add_child(content)
		var title := Label.new()
		title.text = "کمک از دفتر کارآگاه"
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		title.text_direction = Control.TEXT_DIRECTION_RTL
		title.add_theme_font_size_override("font_size", 27)
		title.add_theme_color_override("font_color", Color("ffe09a"))
		content.add_child(title)
		var message := Label.new()
		message.text = "اگر ترتیب رمز را در دفتر ببینی، ۵ سکه از امتیازت کم می‌شه. می‌خوای دفتر را باز کنی؟"
		message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		message.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		message.text_direction = Control.TEXT_DIRECTION_RTL
		message.add_theme_font_size_override("font_size", 28)
		message.add_theme_color_override("font_color", Color("fff6e6"))
		content.add_child(message)
		var buttons := HBoxContainer.new()
		buttons.alignment = BoxContainer.ALIGNMENT_CENTER
		buttons.add_theme_constant_override("separation", 16)
		content.add_child(buttons)
		var cancel := Button.new()
		cancel.text = "نه، خودم حل می‌کنم"
		cancel.custom_minimum_size = Vector2(205, 46)
		cancel.add_theme_font_size_override("font_size", 19)
		cancel.pressed.connect(func() -> void: score_confirmation.hide())
		buttons.add_child(cancel)
		var confirm := Button.new()
		confirm.text = "آره، ۵ سکه کم بشه"
		confirm.custom_minimum_size = Vector2(205, 46)
		confirm.add_theme_font_size_override("font_size", 19)
		confirm.pressed.connect(confirm_notebook_score_cost)
		buttons.add_child(confirm)
	score_confirmation.show()
	score_confirmation.move_to_front()

func confirm_notebook_score_cost() -> void:
	score_confirmation.hide()
	lose_score(5)
	prompt_label.text = "برای دیدن دفتر، ۵ سکه کم شد."
	open_notebook_screen()

func close_notebook() -> void:
	if notebook_return_texture:
		scene_background.texture = notebook_return_texture
	scene_shade.show()
	scene_header.show()
	home_button.show()
	game_footer.show()
	if lock_was_visible and lock_panel:
		lock_panel.show()
	lock_was_visible = false
	if packaging_was_visible and packaging_panel:
		packaging_panel.show()
	packaging_was_visible = false
	notebook.hide()

func build_dialogue() -> void:
	dialogue = PanelContainer.new()
	dialogue.anchor_left = 0.5
	dialogue.anchor_top = 0.5
	dialogue.anchor_right = 0.5
	dialogue.anchor_bottom = 0.5
	dialogue.offset_left = -430
	dialogue.offset_top = -138
	dialogue.offset_right = 430
	dialogue.offset_bottom = 138
	dialogue.visible = false
	dialogue.add_theme_stylebox_override("panel", panel_style(Color(0.11, 0.06, 0.03, 0.747), Color(0.72, 0.82, 0.68, 1), 18, 3))
	add_child(dialogue)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 16)
	dialogue.add_child(content)
	dialogue_name = Label.new()
	dialogue_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	dialogue_name.text_direction = Control.TEXT_DIRECTION_RTL
	dialogue_name.add_theme_font_size_override("font_size", 27)
	dialogue_name.add_theme_color_override("font_color", Color("d9efbd"))
	content.add_child(dialogue_name)
	dialogue_text = Label.new()
	dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	dialogue_text.text_direction = Control.TEXT_DIRECTION_RTL
	dialogue_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dialogue_text.add_theme_font_size_override("font_size", 27)
	dialogue_text.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(dialogue_text)
	dialogue_next_button = Button.new()
	dialogue_next_button.custom_minimum_size = Vector2(180, 48)
	dialogue_next_button.add_theme_font_size_override("font_size", 22)
	dialogue_next_button.pressed.connect(show_next_dialogue)
	content.add_child(dialogue_next_button)

func open_dialogue() -> void:
	close_notebook()
	scene_background.texture = MASTER_DIALOGUE_BACKGROUND
	reset_dialogue_next_action()
	dialogue_step = 0
	dialogue.show()
	show_dialogue_line()

func reset_dialogue_next_action() -> void:
	if dialogue_next_button.pressed.is_connected(start_corridor):
		dialogue_next_button.pressed.disconnect(start_corridor)
	if dialogue_next_button.pressed.is_connected(retry_time_question):
		dialogue_next_button.pressed.disconnect(retry_time_question)
	if not dialogue_next_button.pressed.is_connected(show_next_dialogue):
		dialogue_next_button.pressed.connect(show_next_dialogue)

func show_dialogue_line() -> void:
	var line: Dictionary = DIALOGUE_LINES[dialogue_step]
	dialogue_name.text = line.speaker
	if dialogue_step == DIALOGUE_LINES.size() - 1:
		dialogue_text.text = "نه، ساعت صبح افتاد و خراب شد. ولی دوربین بازار %d دقیقه بعد از ۴:۲۰، یک نفر را با بقچه دیده." % camera_delay
	else:
		dialogue_text.text = line.text
	if dialogue_step == DIALOGUE_LINES.size() - 1:
		dialogue_next_button.text = "حل معمای زمان"
	else:
		dialogue_next_button.text = "ادامه"

func show_next_dialogue() -> void:
	if dialogue_step < DIALOGUE_LINES.size() - 1:
		dialogue_step += 1
		show_dialogue_line()
	else:
		show_time_question()

func show_time_question() -> void:
	if time_answers and is_instance_valid(time_answers):
		time_answers.hide()
		time_answers.queue_free()
		time_answers = null
	if time_puzzle_solved:
		dialogue_name.text = "معمای زمان حل شده"
		dialogue_text.text = "آفرین! جواب %s بود. حالا بریم راهروی بازار." % camera_answer()
		dialogue_next_button.show()
		dialogue_next_button.text = "بریم راهروی بازار"
		if dialogue_next_button.pressed.is_connected(show_next_dialogue):
			dialogue_next_button.pressed.disconnect(show_next_dialogue)
		if not dialogue_next_button.pressed.is_connected(start_corridor):
			dialogue_next_button.pressed.connect(start_corridor)
		return
	dialogue_name.text = "معمای زمان"
	dialogue_text.text = "دوربین %d دقیقه بعد از ساعت ۴:۲۰، یک نفر را با بقچه دیده. ساعت چند بوده؟" % camera_delay
	dialogue_next_button.hide()
	time_answers = HBoxContainer.new()
	time_answers.alignment = BoxContainer.ALIGNMENT_CENTER
	time_answers.add_theme_constant_override("separation", 16)
	dialogue.get_child(0).add_child(time_answers)
	var correct_minutes := 4 * 60 + 20 + camera_delay
	var answers: Array[String] = [format_clock_time(correct_minutes - 5), format_clock_time(correct_minutes), format_clock_time(correct_minutes + 5)]
	shuffle_answers(answers)
	for answer in answers:
		var button := Button.new()
		button.text = answer
		button.custom_minimum_size = Vector2(125, 46)
		button.add_theme_font_size_override("font_size", 27)
		button.pressed.connect(answer_time_question.bind(answer))
		time_answers.add_child(button)

func answer_time_question(answer: String) -> void:
	if time_puzzle_solved:
		return
	if time_answers and is_instance_valid(time_answers):
		for choice in time_answers.get_children():
			choice.disabled = true
		time_answers.hide()
		time_answers.queue_free()
		time_answers = null
	dialogue_next_button.show()
	if answer == camera_answer():
		time_puzzle_solved = true
		dialogue_name.text = "آفرین!"
		dialogue_text.text = "درست گفتی: ۴:۲۰ با %d دقیقه می‌شه %s. حالا بریم مسیر این آدم را پیدا کنیم." % [camera_delay, camera_answer()]
		dialogue_next_button.text = "بریم راهروی بازار"
		dialogue_next_button.pressed.disconnect(show_next_dialogue)
		dialogue_next_button.pressed.connect(start_corridor)
	else:
		lose_score(1)
		dialogue_name.text = "یه بار دیگه فکر کن"
		dialogue_text.text = "اشکالی نداره! یک سکه کم شد. از ۴:۲۰ دقیقه‌ها را جلو ببر و دوباره امتحان کن."
		dialogue_next_button.text = "دوباره تلاش کن"
		dialogue_next_button.pressed.disconnect(show_next_dialogue)
		dialogue_next_button.pressed.connect(retry_time_question)

func retry_time_question() -> void:
	dialogue_next_button.pressed.disconnect(retry_time_question)
	dialogue_next_button.pressed.connect(show_next_dialogue)
	show_time_question()

func close_dialogue() -> void:
	dialogue.hide()
	prompt_label.text = "راه بازار باز شد! حالا بریم راهرو و مسیر را پیدا کنیم."

func start_corridor() -> void:
	dialogue.hide()
	scene_background.texture = CORRIDOR_BACKGROUND
	for hotspot in hotspot_buttons:
		hotspot.hide()
	notebook_button.disabled = false
	prompt_label.text = "رد کفش را دنبال کن و راه درست را انتخاب کن."
	build_route_panel()
	route_panel.show()

func build_route_panel() -> void:
	if route_panel:
		return
	route_panel = PanelContainer.new()
	route_panel.anchor_left = 0.5
	route_panel.anchor_top = 0.5
	route_panel.anchor_right = 0.5
	route_panel.anchor_bottom = 0.5
	route_panel.offset_left = -375
	route_panel.offset_top = -155
	route_panel.offset_right = 375
	route_panel.offset_bottom = 155
	route_panel.add_theme_stylebox_override("panel", panel_style(Color(0.10, 0.055, 0.027, 0.738), Color(0.88, 0.64, 0.25, 1), 18, 3))
	add_child(route_panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 14)
	route_panel.add_child(content)
	var title := Label.new()
	title.text = "نقشهٔ راهرو"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	title.text_direction = Control.TEXT_DIRECTION_RTL
	title.add_theme_font_size_override("font_size", 31)
	title.add_theme_color_override("font_color", Color("ffe09a"))
	content.add_child(title)
	route_text = Label.new()
	route_text.text = "رد کفش‌ها و نخ قرمز به یک راه باز می‌رسند. از کدوم راه بریم تا به انبار برسیم؟"
	route_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	route_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	route_text.text_direction = Control.TEXT_DIRECTION_RTL
	route_text.add_theme_font_size_override("font_size", 24)
	route_text.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(route_text)
	route_choices = VBoxContainer.new()
	route_choices.add_theme_constant_override("separation", 9)
	content.add_child(route_choices)
	add_route_choice("رد پا نمی‌بینم", false)
	add_route_choice("راهروی مستقیم انبار", true)
	add_route_choice("مغازهٔ بغلی", false)

func add_route_choice(text: String, is_correct: bool) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(300, 43)
	button.add_theme_font_size_override("font_size", 27)
	button.pressed.connect(choose_route.bind(is_correct))
	route_choices.add_child(button)

func choose_route(is_correct: bool) -> void:
	if is_correct:
		route_text.text = "آفرین! راه مستقیم به انبار می‌رسه و رد کفش‌ها هم همون طرف می‌رن. بریم انبار!"
		for choice in route_choices.get_children():
			choice.queue_free()
		var next := Button.new()
		next.text = "با آدم‌ها حرف بزنیم"
		next.custom_minimum_size = Vector2(290, 46)
		next.add_theme_font_size_override("font_size", 22)
		next.pressed.connect(start_assistant_dialogue)
		route_choices.add_child(next)
		prompt_label.text = "راه درست را پیدا کردی. حالا انبار و رمز کمد."
	else:
		lose_score(1)
		route_text.text = "این راه به انبار نمی‌رسه. یک سکه کم شد؛ دوباره به رد کفش‌ها نگاه کن."

func start_assistant_dialogue() -> void:
	route_panel.hide()
	scene_background.texture = ASSISTANT_DIALOGUE_BACKGROUND
	prompt_label.text = "با آدم‌ها حرف بزن و حرف‌هایشان را با سرنخ‌ها بسنج."
	build_assistant_dialogue()
	assistant_dialogue_step = 0
	assistant_panel.show()
	show_assistant_line()

func build_assistant_dialogue() -> void:
	if assistant_panel:
		return
	assistant_panel = PanelContainer.new()
	assistant_panel.anchor_left = 0.5
	assistant_panel.anchor_top = 1.0
	assistant_panel.anchor_right = 0.5
	assistant_panel.anchor_bottom = 1.0
	assistant_panel.offset_left = -480
	assistant_panel.offset_top = -290
	assistant_panel.offset_right = 480
	assistant_panel.offset_bottom = -22
	assistant_panel.add_theme_stylebox_override("panel", panel_style(Color(0.10, 0.055, 0.027, 0.729), Color(0.72, 0.82, 0.68, 1), 18, 3))
	add_child(assistant_panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	assistant_panel.add_child(content)
	assistant_name = Label.new()
	assistant_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	assistant_name.text_direction = Control.TEXT_DIRECTION_RTL
	assistant_name.add_theme_font_size_override("font_size", 27)
	assistant_name.add_theme_color_override("font_color", Color("d9efbd"))
	content.add_child(assistant_name)
	assistant_text = Label.new()
	assistant_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	assistant_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	assistant_text.text_direction = Control.TEXT_DIRECTION_RTL
	assistant_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	assistant_text.add_theme_font_size_override("font_size", 26)
	assistant_text.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(assistant_text)
	assistant_next_button = Button.new()
	assistant_next_button.custom_minimum_size = Vector2(180, 46)
	assistant_next_button.add_theme_font_size_override("font_size", 22)
	assistant_next_button.pressed.connect(show_next_assistant_line)
	content.add_child(assistant_next_button)

func show_assistant_line() -> void:
	var line: Dictionary = ASSISTANT_DIALOGUE_LINES[assistant_dialogue_step]
	assistant_name.text = line.speaker
	assistant_text.text = line.text
	if assistant_dialogue_step == ASSISTANT_DIALOGUE_LINES.size() - 1:
		assistant_next_button.text = "بریم انبار"
	else:
		assistant_next_button.text = "ادامه"

func show_next_assistant_line() -> void:
	if assistant_dialogue_step < ASSISTANT_DIALOGUE_LINES.size() - 1:
		assistant_dialogue_step += 1
		show_assistant_line()
	else:
		assistant_panel.hide()
		start_warehouse()

func start_warehouse() -> void:
	route_panel.hide()
	scene_background.texture = WAREHOUSE_BACKGROUND
	prompt_label.text = "کمد انبار قفله. ترتیب نشانه‌ها را از روی کاغذ اعداد یادت بیار."
	build_lock_panel()
	lock_panel.show()

func build_lock_panel() -> void:
	if lock_panel:
		return
	lock_panel = PanelContainer.new()
	lock_panel.anchor_left = 0.5
	lock_panel.anchor_top = 0.5
	lock_panel.anchor_right = 0.5
	lock_panel.anchor_bottom = 0.5
	lock_panel.offset_left = -380
	lock_panel.offset_top = -220
	lock_panel.offset_right = 380
	lock_panel.offset_bottom = 220
	lock_panel.add_theme_stylebox_override("panel", panel_style(Color(0.10, 0.055, 0.027, 0.738), Color(0.96, 0.74, 0.31, 1), 18, 3))
	add_child(lock_panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 13)
	lock_panel.add_child(content)
	var title := Label.new()
	title.text = "رمز کمد انبار"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	title.text_direction = Control.TEXT_DIRECTION_RTL
	title.add_theme_font_size_override("font_size", 31)
	title.add_theme_color_override("font_color", Color("ffe09a"))
	content.add_child(title)
	lock_status = Label.new()
	lock_status.text = "کمد پشت سرمون یه رمز داره. رمز یادت هست؟ اگر نیست دکمهٔ «دفتر کارآگاه» پایین صفحه را بزن و کاغذ اعداد را ببین."
	lock_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lock_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	lock_status.text_direction = Control.TEXT_DIRECTION_RTL
	lock_status.add_theme_font_size_override("font_size", 25)
	lock_status.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(lock_status)
	lock_sequence_label = Label.new()
	lock_sequence_label.text = "ترتیب تو: —"
	lock_sequence_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lock_sequence_label.text_direction = Control.TEXT_DIRECTION_RTL
	lock_sequence_label.add_theme_font_size_override("font_size", 25)
	lock_sequence_label.add_theme_color_override("font_color", Color("fff0a5"))
	content.add_child(lock_sequence_label)
	var symbols := HBoxContainer.new()
	symbols.alignment = BoxContainer.ALIGNMENT_CENTER
	symbols.add_theme_constant_override("separation", 12)
	content.add_child(symbols)
	for symbol in [1, 2, 3, 4]:
		var button := Button.new()
		button.text = "نشانهٔ " + ["", "۱", "۲", "۳", "۴"][symbol]
		button.custom_minimum_size = Vector2(135, 52)
		button.add_theme_font_size_override("font_size", 24)
		button.pressed.connect(choose_symbol.bind(symbol))
		symbols.add_child(button)
	var clear := Button.new()
	clear.text = "پاک کردن ترتیب"
	clear.custom_minimum_size = Vector2(185, 42)
	clear.add_theme_font_size_override("font_size", 19)
	clear.pressed.connect(clear_lock_sequence)
	content.add_child(clear)

func choose_symbol(symbol: int) -> void:
	if cabinet_unlocked or selected_symbols.size() >= 4:
		return
	selected_symbols.append(symbol)
	update_lock_sequence()
	if selected_symbols.size() == 4:
		if selected_symbols == lock_code:
			cabinet_unlocked = true
			lock_status.text = "آفرین! قفل باز شد. توی کمد یک بسته با کاغذ تازه پیدا کردی."
			prompt_label.text = "کمد باز شد! حالا بسته‌بندی را با نمونه‌ها مقایسه کن."
			start_packaging_stage()
		else:
			lose_score(1)
			lock_status.text = "این ترتیب قفل را باز نکرد و یک سکه کم شد. اشکالی نداره؛ دفتر کارآگاه را باز کن و کاغذ اعداد را دوباره ببین."
			selected_symbols.clear()
			update_lock_sequence()

func clear_lock_sequence() -> void:
	if cabinet_unlocked:
		return
	selected_symbols.clear()
	lock_status.text = "ترتیب پاک شد. اگر لازم داری، دفتر کارآگاه را باز کن و کاغذ اعداد را ببین."
	update_lock_sequence()

func start_packaging_stage() -> void:
	lock_panel.hide()
	build_packaging_panel()
	reset_packaging_stage()
	packaging_panel.show()

func build_packaging_panel() -> void:
	if packaging_panel:
		return
	packaging_panel = PanelContainer.new()
	packaging_panel.anchor_left = 0.5
	packaging_panel.anchor_top = 0.5
	packaging_panel.anchor_right = 0.5
	packaging_panel.anchor_bottom = 0.5
	packaging_panel.offset_left = -390
	packaging_panel.offset_top = -180
	packaging_panel.offset_right = 390
	packaging_panel.offset_bottom = 180
	packaging_panel.add_theme_stylebox_override("panel", panel_style(Color(0.10, 0.055, 0.027, 0.738), Color(0.72, 0.82, 0.68, 1), 18, 3))
	add_child(packaging_panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 13)
	packaging_panel.add_child(content)
	packaging_title = Label.new()
	packaging_title.text = "بستهٔ داخل کمد"
	packaging_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	packaging_title.text_direction = Control.TEXT_DIRECTION_RTL
	packaging_title.add_theme_font_size_override("font_size", 35)
	packaging_title.add_theme_color_override("font_color", Color("d9efbd"))
	content.add_child(packaging_title)
	packaging_preview = TextureRect.new()
	packaging_preview.texture = WRAPPED_PACKAGE
	packaging_preview.custom_minimum_size = Vector2(240, 135)
	packaging_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	packaging_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	packaging_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(packaging_preview)
	packaging_question = Label.new()
	packaging_question.visible = false
	packaging_question.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	packaging_question.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	packaging_question.text_direction = Control.TEXT_DIRECTION_RTL
	packaging_question.add_theme_font_size_override("font_size", 22)
	packaging_question.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(packaging_question)
	packaging_choices = VBoxContainer.new()
	packaging_choices.add_theme_constant_override("separation", 9)
	content.add_child(packaging_choices)

func reset_packaging_stage() -> void:
	if not packaging_choices:
		return
	packaging_solved = false
	packaging_title.text = "بستهٔ داخل کمد"
	packaging_question.text = ""
	packaging_question.hide()
	packaging_preview.show()
	for choice in packaging_choices.get_children():
		choice.queue_free()
	var inspect := Button.new()
	inspect.text = "بسته را بررسی کردم"
	inspect.custom_minimum_size = Vector2(250, 46)
	inspect.add_theme_font_size_override("font_size", 22)
	inspect.pressed.connect(show_packaging_question)
	packaging_choices.add_child(inspect)

func show_packaging_question() -> void:
	for choice in packaging_choices.get_children():
		choice.queue_free()
	packaging_title.text = "تطبیق بسته‌بندی"
	packaging_question.text = "کدوم نمونه با این بسته جور درمیاد؟"
	packaging_question.show()
	packaging_preview.hide()
	add_packaging_choice("کاغذ سادهٔ کرم", false)
	add_packaging_choice("کاغذ گل‌دار با لبهٔ پاره", true)
	add_packaging_choice("کاغذ راه‌راه آبی", false)

func add_packaging_choice(text: String, is_correct: bool) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(350, 43)
	button.add_theme_font_size_override("font_size", 27)
	button.pressed.connect(choose_packaging.bind(is_correct))
	packaging_choices.add_child(button)

func choose_packaging(is_correct: bool) -> void:
	if packaging_solved:
		return
	if not is_correct:
		lose_score(1)
		for choice in packaging_choices.get_children():
			choice.queue_free()
		packaging_question.text = "این یکی جور نیست و یک سکه کم شد. می‌خوای دوباره بسته را ببینی؟"
		var review := Button.new()
		review.text = "دوباره بسته را ببین"
		review.custom_minimum_size = Vector2(250, 46)
		review.add_theme_font_size_override("font_size", 22)
		review.pressed.connect(reset_packaging_stage)
		packaging_choices.add_child(review)
		return
	packaging_solved = true
	for choice in packaging_choices.get_children():
		choice.queue_free()
	packaging_question.text = "آفرین! نقش کاغذ و لبهٔ پاره با بستهٔ کمد جور شد."
	var next := Button.new()
	next.text = "مرحلهٔ بعد: مرور پرونده"
	next.custom_minimum_size = Vector2(270, 46)
	next.add_theme_font_size_override("font_size", 22)
	next.pressed.connect(start_case_review)
	packaging_choices.add_child(next)
	prompt_label.text = "بسته را هم بررسی کردی. حالا همهٔ سرنخ‌ها را ببین و جواب بده."

func start_case_review() -> void:
	packaging_panel.hide()
	scene_background.texture = CASE_REVIEW_BACKGROUND
	prompt_label.text = "حالا سرنخ‌ها را کنار هم بگذار و جواب پرونده را پیدا کن."
	build_case_panel()
	case_step = 0
	case_completed = false
	case_panel.show()
	show_case_question()

func build_case_panel() -> void:
	if case_panel:
		return
	case_panel = PanelContainer.new()
	case_panel.anchor_left = 0.5
	case_panel.anchor_top = 0.5
	case_panel.anchor_right = 0.5
	case_panel.anchor_bottom = 0.5
	case_panel.offset_left = -465
	case_panel.offset_top = -193
	case_panel.offset_right = 465
	case_panel.offset_bottom = 193
	case_panel.add_theme_stylebox_override("panel", panel_style(Color(0.10, 0.055, 0.027, 0.792), Color(0.96, 0.74, 0.31, 1), 18, 3))
	add_child(case_panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	case_panel.add_child(content)
	case_title = Label.new()
	case_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	case_title.text_direction = Control.TEXT_DIRECTION_RTL
	case_title.add_theme_font_size_override("font_size", 31)
	case_title.add_theme_color_override("font_color", Color("ffe09a"))
	content.add_child(case_title)
	case_status = Label.new()
	case_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	case_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	case_status.text_direction = Control.TEXT_DIRECTION_RTL
	case_status.add_theme_font_size_override("font_size", 22)
	case_status.add_theme_color_override("font_color", Color("d9efbd"))
	content.add_child(case_status)
	case_question = Label.new()
	case_question.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	case_question.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	case_question.text_direction = Control.TEXT_DIRECTION_RTL
	case_question.add_theme_font_size_override("font_size", 25)
	case_question.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(case_question)
	case_choices = VBoxContainer.new()
	case_choices.add_theme_constant_override("separation", 8)
	content.add_child(case_choices)

func show_case_question() -> void:
	for choice in case_choices.get_children():
		choice.queue_free()
	var current: Dictionary = CASE_QUESTIONS[case_step]
	case_title.text = "جواب پرونده  •  پرسش %d از %d" % [case_step + 1, CASE_QUESTIONS.size()]
	case_status.text = "رسید خرید، بسته، حرف مسئول انبار و پلاک پیدا‌شده را با هم ببین."
	case_question.text = current.question
	for index in range(current.choices.size()):
		var button := Button.new()
		button.text = current.choices[index]
		button.custom_minimum_size = Vector2(540, 42)
		button.add_theme_font_size_override("font_size", 24)
		button.pressed.connect(choose_case_answer.bind(index))
		case_choices.add_child(button)

func choose_case_answer(answer_index: int) -> void:
	if case_completed:
		return
	var current: Dictionary = CASE_QUESTIONS[case_step]
	if answer_index != current.correct:
		lose_score(1)
		case_status.text = "هنوز سرنخ کافی نداری و یک سکه کم شد. دوباره نگاه کن: این نشانه چه ربطی به بستهٔ توی کمد داره؟"
		return
	case_step += 1
	if case_step < CASE_QUESTIONS.size():
		show_case_question()
		return
	show_case_ending()

func show_case_ending() -> void:
	case_completed = true
	var first_completion := not bazaar_completed
	if first_completion:
		bazaar_completed = true
		bazaar_stars = clampi(roundi(float(score) / 50.0 * 5.0), 1, 5)
		completed_cases = clampi(completed_cases + 1, 0, 5)
		earned_stars += bazaar_stars
		earned_coins += score
		save_player_progress()
	for choice in case_choices.get_children():
		choice.queue_free()
	case_title.text = "پرونده حل شد!"
	if first_completion:
		case_status.text = "پرونده را با %d سکه و %d ستاره حل کردی! شاگرد کاغذ را خرید، بستهٔ پلاک را توی کمد گذاشت و حرفش دربارهٔ انبار هم درست نبود." % [score, bazaar_stars]
	else:
		case_status.text = "این پرونده را قبلاً حل کردی. این بار %d سکه گرفتی، ولی سکه و ستارهٔ تازه‌ای نمی‌گیری." % score
	case_question.text = "شاگرد می‌گوید: «من پلاک را برداشتم. فکر کردم شاید عوض شده. می‌ترسیدم یه چیز تقلبی را توی نمایشگاه نشون بدیم. می‌خواستم تا وقتی مطمئن می‌شم، جاش امن باشه؛ بعدش هم ترسیدم راستش را بگم.»\n\nاستاد می‌گوید: «پلاک اصله. نشانش توی یک تعمیر قدیمی کم‌رنگ شده. خوب شد نگرانی‌ات را گفتی، ولی باید همون موقع با من حرف می‌زدی؛ نباید یواشکی پنهانش می‌کردی.»\n\nپلاک دوباره توی جعبه گذاشته می‌شه و شاگرد هم برای نمایشگاه فردا کمک می‌کنه."
	var home := Button.new()
	home.text = "بازگشت به صفحهٔ اصلی"
	home.custom_minimum_size = Vector2(255, 46)
	home.add_theme_font_size_override("font_size", 22)
	home.pressed.connect(return_to_main_menu)
	case_choices.add_child(home)
	prompt_label.text = "پرونده حل شد! با دیدن سرنخ‌ها، جواب درست را پیدا کردی."

func update_lock_sequence() -> void:
	if selected_symbols.is_empty():
		lock_sequence_label.text = "ترتیب تو: —"
	else:
		var shown: Array[String] = []
		for symbol in selected_symbols:
			shown.append(["", "۱", "۲", "۳", "۴"][symbol])
		lock_sequence_label.text = "ترتیب تو: " + " ← ".join(shown)

func generate_lock_code() -> void:
	var random := RandomNumberGenerator.new()
	random.randomize()
	var old_code: Array[int] = lock_code.duplicate()
	var new_code: Array[int] = []
	for attempt in range(8):
		new_code = [1, 2, 3, 4]
		for index in range(new_code.size() - 1, 0, -1):
			var other_index := random.randi_range(0, index)
			var temporary := new_code[index]
			new_code[index] = new_code[other_index]
			new_code[other_index] = temporary
		if new_code != old_code:
			break
	previous_lock_code = old_code
	lock_code = new_code

func generate_time_delay() -> void:
	var random := RandomNumberGenerator.new()
	random.randomize()
	camera_delay = random.randi_range(10, 35)

func camera_answer() -> String:
	return format_clock_time(4 * 60 + 20 + camera_delay)

func format_clock_time(total_minutes: int) -> String:
	var hours := int(total_minutes / 60)
	var minutes := total_minutes % 60
	return to_persian_digits("%d:%02d" % [hours, minutes])

func to_persian_digits(text: String) -> String:
	var result := text
	var persian_digits := ["۰", "۱", "۲", "۳", "۴", "۵", "۶", "۷", "۸", "۹"]
	for digit in range(10):
		result = result.replace(str(digit), persian_digits[digit])
	return result

func shuffle_answers(answers: Array[String]) -> void:
	var random := RandomNumberGenerator.new()
	random.randomize()
	for index in range(answers.size() - 1, 0, -1):
		var other_index := random.randi_range(0, index)
		var temporary := answers[index]
		answers[index] = answers[other_index]
		answers[other_index] = temporary

func format_code(code: Array[int]) -> String:
	var shown: Array[String] = []
	for symbol in code:
		shown.append(["", "۱", "۲", "۳", "۴"][symbol])
	return " ← ".join(shown)

func update_notebook_code_text() -> void:
	if notebook_clues_text:
		notebook_clues_text.text = "• ساعت روی ۴:۲۰ مونده، ولی خرابه\n• رسید خرید، نخ قرمز، رد کفش و کاغذ اعداد\n• ترتیب روی کاغذ: %s\n\nاین سرنخ‌ها را یادت نگه دار." % format_code(lock_code)

func panel_style(background: Color, border: Color, radius: float, width: float) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(int(width))
	style.set_corner_radius_all(int(radius))
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style
