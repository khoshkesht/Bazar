extends Control

const BACKGROUND := preload("res://sources/pics/s1.png")
const CORRIDOR_BACKGROUND := preload("res://sources/pics/s2.png")
const ASSISTANT_DIALOGUE_BACKGROUND := preload("res://sources/pics/s3.png")
const MASTER_DIALOGUE_BACKGROUND := preload("res://sources/pics/oldman.png")
const WAREHOUSE_BACKGROUND := preload("res://sources/pics/s4.png")
const NOTEBOOK_BACKGROUND := preload("res://sources/pics/note.png")
const CASE_REVIEW_BACKGROUND := preload("res://sources/pics/s5.png")
const WRAPPED_PACKAGE := preload("res://sources/pics/clue_wrapped_package.png")
const CLUES := [
	{"id": "receipt", "title": "رسید کاغذی", "description": "یه رسید تازه کنار پیشخوان افتاده! شاید بگوید چه کسی و چه وقتی خرید کرده.", "position": Vector2(0.36, 0.36), "size": Vector2(0.075, 0.10)},
	{"id": "thread", "title": "نخ قرمز", "description": "اِ... یه نخ قرمز به پیشخوان گیر کرده. شاید از لباس یا بستهٔ کسی جا مانده باشد.", "position": Vector2(0.45, 0.40), "size": Vector2(0.045, 0.14)},
	{"id": "clock", "title": "ساعت جیبی", "description": "این ساعت جیبی روی ۴:۲۰ گیر کرده. یعنی آن موقع شاید اتفاق مهمی افتاده!", "position": Vector2(0.115, 0.66), "size": Vector2(0.14, 0.13)},
	{"id": "footprint", "title": "رد کفش", "description": "این رد کفش تا درِ بازار می‌رود. ببینیم صاحبش کی بوده!", "position": Vector2(0.56, 0.68), "size": Vector2(0.10, 0.12)},
	{"id": "number_paper", "title": "کاغذ اعداد", "description": "یه کاغذ کوچیک با چهار عدد رویش پیدا کردی: ۲، ۱، ۴، ۳. شاید رمز یک قفل باشد!", "position": Vector2(0.57, 0.35), "size": Vector2(0.10, 0.08)}
]

var found_clues: Dictionary = {}
var hotspot_buttons: Array[Button] = []
var clue_count_label: Label
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

const DIALOGUE_LINES := [
	{"speaker": "استاد قلم‌زن", "text": "آفرین، کارآگاه! حسابی گشتی. من ساعت ۴:۴۵، درست قبل از بیرون رفتنم، پلاک را توی جعبه دیدم."},
	{"speaker": "کارآگاه", "text": "پس ساعت جیبی می‌گوید پلاک کی گم شده؟"},
	{"speaker": "استاد قلم‌زن", "text": "نه، آن ساعت صبح افتاد و خراب شد. ولی دوربین بازار ۳۵ دقیقه بعد از ۴:۲۰، یک نفر را با بقچه دیده."}
]

const ASSISTANT_DIALOGUE_LINES := [
	{"speaker": "شاگرد مغازه", "text": "من از پنج تا پنج‌وربع توی انبار بودم؛ اصلاً هم بیرون نرفتم."},
	{"speaker": "کارآگاه", "text": "یعنی مطمئنی حتی یک لحظه هم از انبار بیرون نرفتی؟"},
	{"speaker": "شاگرد مغازه", "text": "آره... فقط به نظرم اگر یه کار اصل نباشه، نباید توی نمایشگاه نشونش بدن، نه؟"},
	{"speaker": "پیک بازار", "text": "من نزدیک حجره بودم و یه بسته می‌بردم، ولی ساعت ۴:۴۰ رفتم. استاد می‌گه ساعت ۴:۴۵ هنوز پلاک توی جعبه بوده."},
	{"speaker": "فروشندهٔ کناری", "text": "کاغذ بسته‌بندی را ساعت ۵:۱۰ به خودِ شاگرد فروختم. می‌گفت برای نگه‌داشتن یه چیز ظریف، کاغذ محکم می‌خواد."},
	{"speaker": "مسئول انبار", "text": "من نزدیک کمد انبار بودم. دیدم شاگرد با همون کاغذ تازه، یه بسته را گذاشت توی کمد. فکر کردم وسیلهٔ نمایشگاهه."}
]

const CASE_QUESTIONS := [
	{
		"question": "با کنار هم گذاشتن همهٔ شواهد، مظنون اصلی پرونده کیست؟",
		"choices": ["پیک بازار", "شاگرد مغازه", "فروشندهٔ کناری", "استاد قلم‌زن"],
		"correct": 1
	},
	{
		"question": "کدام مدرک، شاگرد را به بستهٔ داخل کمد وصل می‌کند؟",
		"choices": ["نخ قرمز", "رد کفش", "رسید خرید، تطبیق بسته‌بندی و گفتهٔ مسئول انبار", "ساعت شکسته"],
		"correct": 2
	},
	{
		"question": "دلیل درست برای نتیجه‌گیری چیست؟",
		"choices": ["چون نخ قرمز داشت", "چون دروغ گفت", "چون کاغذ را خرید، بستهٔ حاوی قطعه را در کمد گذاشت و ادعایش دربارهٔ انبار درست نبود"],
		"correct": 2
	}
]

func _ready() -> void:
	generate_lock_code()
	build_scene()

func build_scene() -> void:
	scene_background = TextureRect.new()
	scene_background.texture = BACKGROUND
	scene_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	scene_background.stretch_mode = TextureRect.STRETCH_SCALE
	scene_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scene_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(scene_background)

	scene_shade = ColorRect.new()
	scene_shade.color = Color(0.05, 0.025, 0.012, 0.18)
	scene_shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scene_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(scene_shade)
	build_header()
	build_hotspots()
	build_footer()
	build_clue_panel()
	show_intro()

func build_header() -> void:
	scene_header = PanelContainer.new()
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
	clue_count_label.add_theme_font_size_override("font_size", 17)
	clue_count_label.add_theme_color_override("font_color", Color("f5ead8"))
	content.add_child(clue_count_label)
	update_clue_count()

func build_hotspots() -> void:
	for clue in CLUES:
		var button := Button.new()
		button.name = "Hotspot_" + clue.id
		var base_size := Vector2(clue.size.x * 1280.0, clue.size.y * 720.0)
		button.position = Vector2(clue.position.x * 1280.0, clue.position.y * 720.0) - base_size * 0.2
		button.size = base_size * 1.4
		button.tooltip_text = "بررسی: " + clue.title
		button.flat = true
		button.text = "●"
		button.add_theme_font_size_override("font_size", 48)
		button.add_theme_color_override("font_color", Color("fff238"))
		button.modulate = Color(1, 0.95, 0.25, 0.8)
		button.pressed.connect(show_clue.bind(clue, button))
		add_child(button)
		hotspot_buttons.append(button)

func build_footer() -> void:
	game_footer = PanelContainer.new()
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
	prompt_label.text = "دنبال نقطه‌های طلایی بگرد و روشون بزن!"
	prompt_label.text_direction = Control.TEXT_DIRECTION_RTL
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	prompt_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	prompt_label.add_theme_font_size_override("font_size", 19)
	prompt_label.add_theme_color_override("font_color", Color("fff1d3"))
	row.add_child(prompt_label)
	var reset := Button.new()
	reset.text = "شروع دوباره"
	reset.custom_minimum_size = Vector2(145, 44)
	reset.add_theme_font_size_override("font_size", 17)
	reset.pressed.connect(reset_investigation)
	row.add_child(reset)
	notebook_button = Button.new()
	notebook_button.text = "دفتر کارآگاه"
	notebook_button.custom_minimum_size = Vector2(155, 44)
	notebook_button.add_theme_font_size_override("font_size", 17)
	notebook_button.disabled = true
	notebook_button.pressed.connect(open_notebook)
	row.add_child(notebook_button)

func build_clue_panel() -> void:
	modal = PanelContainer.new()
	modal.anchor_left = 0.5
	modal.anchor_top = 0.5
	modal.anchor_right = 0.5
	modal.anchor_bottom = 0.5
	modal.offset_left = -270
	modal.offset_top = -155
	modal.offset_right = 270
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
	modal_title.add_theme_font_size_override("font_size", 30)
	modal_title.add_theme_color_override("font_color", Color("ffe09a"))
	box.add_child(modal_title)
	modal_description = Label.new()
	modal_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	modal_description.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	modal_description.text_direction = Control.TEXT_DIRECTION_RTL
	modal_description.size_flags_vertical = Control.SIZE_EXPAND_FILL
	modal_description.add_theme_font_size_override("font_size", 20)
	modal_description.add_theme_color_override("font_color", Color("fff6e6"))
	box.add_child(modal_description)
	modal_close_button = Button.new()
	modal_close_button.text = "ادامهٔ جست‌وجو"
	modal_close_button.custom_minimum_size = Vector2(190, 46)
	modal_close_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	modal_close_button.add_theme_font_size_override("font_size", 18)
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
		modal_description.text = "یه کاغذ کوچیک با چهار عدد رویش پیدا کردی: %s. شاید رمز یک قفل باشد!" % format_code(lock_code)
	else:
		modal_description.text = clue.description
	modal.show()
	update_clue_count()
	if first_discovery:
		prompt_label.text = "آفرین! یه سرنخ پیدا کردی. بقیه‌شون رو هم پیدا کن."
	if found_clues.size() == CLUES.size():
		prompt_label.text = "آفرین! هر پنج سرنخ را پیدا کردی. حالا بیا دفتر کارآگاه را ببینیم."
		modal_close_button.text = "باز کردن دفتر کارآگاه"
		notebook_button.disabled = false

func close_clue_panel() -> void:
	if intro_active:
		intro_active = false
		modal.hide()
		modal_close_button.text = "ادامهٔ جست‌وجو"
		prompt_label.text = "پنج سرنخ را پیدا کن تا بفهمیم چه کسی قطعه را برداشته است."
		return
	modal.hide()
	if found_clues.size() == CLUES.size():
		open_notebook()

func show_intro() -> void:
	intro_active = true
	modal_title.text = "درخواست استاد قلم‌زن"
	modal_description.text = "یه پلاک قلم‌زنی‌شدهٔ ارزشمند از جعبهٔ من گم شده و باید فردا برای نمایشگاه آماده باشد. شاگردم امروز نگران نشان کم‌رنگ روی آن بود؛ گفتم بعد از آماده‌سازی با هم نگاهش می‌کنیم. حالا سرنخ‌ها را پیدا کن و ببین چه اتفاقی افتاده."
	modal_close_button.text = "شروع تحقیق"
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
	update_notebook_code_text()
	modal.hide()
	notebook.hide()
	game_footer.show()
	scene_shade.show()
	scene_header.show()
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

func _process(delta: float) -> void:
	pulse_time += delta
	for button in hotspot_buttons:
		if not button.disabled:
			button.modulate = Color(1.0, 0.96, 0.24, 0.62 + (sin(pulse_time * 2.4) + 1.0) * 0.16)

func build_notebook() -> void:
	notebook = Control.new()
	notebook.anchor_left = 0.5
	notebook.anchor_top = 0.5
	notebook.anchor_right = 0.5
	notebook.anchor_bottom = 0.5
	notebook.offset_left = -500
	notebook.offset_top = -300
	notebook.offset_right = 500
	notebook.offset_bottom = 300
	notebook.visible = false
	add_child(notebook)
	var title := Label.new()
	title.text = "دفتر کارآگاه"
	title.position = Vector2(350, 82)
	title.size = Vector2(360, 42)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	title.text_direction = Control.TEXT_DIRECTION_RTL
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color("57351e"))
	notebook.add_child(title)
	var intro := Label.new()
	intro.text = "سرنخ‌های پرونده"
	intro.position = Vector2(350, 128)
	intro.size = Vector2(360, 30)
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	intro.text_direction = Control.TEXT_DIRECTION_RTL
	intro.add_theme_font_size_override("font_size", 18)
	intro.add_theme_color_override("font_color", Color("57351e"))
	notebook.add_child(intro)
	notebook_clues_text = Label.new()
	notebook_clues_text.position = Vector2(330, 165)
	notebook_clues_text.size = Vector2(400, 235)
	notebook_clues_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	notebook_clues_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	notebook_clues_text.text_direction = Control.TEXT_DIRECTION_RTL
	notebook_clues_text.add_theme_font_size_override("font_size", 17)
	notebook_clues_text.add_theme_color_override("font_color", Color("57351e"))
	notebook.add_child(notebook_clues_text)
	update_notebook_code_text()
	notebook_talk_button = Button.new()
	notebook_talk_button.text = "با استاد حرف بزنیم"
	notebook_talk_button.position = Vector2(165, 430)
	notebook_talk_button.size = Vector2(220, 42)
	notebook_talk_button.custom_minimum_size = Vector2(210, 46)
	notebook_talk_button.add_theme_font_size_override("font_size", 18)
	notebook_talk_button.pressed.connect(open_dialogue)
	notebook.add_child(notebook_talk_button)
	var close := Button.new()
	close.text = "بستن دفتر"
	close.position = Vector2(165, 485)
	close.size = Vector2(220, 42)
	close.custom_minimum_size = Vector2(195, 46)
	close.add_theme_font_size_override("font_size", 18)
	close.pressed.connect(close_notebook)
	notebook.add_child(close)
	build_dialogue()

func open_notebook() -> void:
	if found_clues.size() == CLUES.size():
		modal.hide()
		notebook_return_texture = scene_background.texture
		scene_background.texture = NOTEBOOK_BACKGROUND
		scene_shade.hide()
		scene_header.hide()
		game_footer.hide()
		for hotspot in hotspot_buttons:
			hotspot.hide()
		lock_was_visible = lock_panel != null and lock_panel.visible
		if lock_was_visible:
			lock_panel.hide()
		packaging_was_visible = packaging_panel != null and packaging_panel.visible
		if packaging_was_visible:
			packaging_panel.hide()
		notebook_talk_button.visible = not time_puzzle_solved
		notebook.move_to_front()
		notebook.show()

func close_notebook() -> void:
	if notebook_return_texture:
		scene_background.texture = notebook_return_texture
	scene_shade.show()
	scene_header.show()
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
	dialogue.offset_top = -230
	dialogue.offset_right = 430
	dialogue.offset_bottom = 230
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
	dialogue_text.add_theme_font_size_override("font_size", 24)
	dialogue_text.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(dialogue_text)
	dialogue_next_button = Button.new()
	dialogue_next_button.custom_minimum_size = Vector2(180, 48)
	dialogue_next_button.add_theme_font_size_override("font_size", 18)
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
		dialogue_text.text = "آفرین! جواب ۴:۵۵ را قبلاً پیدا کردی. حالا می‌توانیم راهی راهروی بازار شویم."
		dialogue_next_button.show()
		dialogue_next_button.text = "بریم راهروی بازار"
		if dialogue_next_button.pressed.is_connected(show_next_dialogue):
			dialogue_next_button.pressed.disconnect(show_next_dialogue)
		if not dialogue_next_button.pressed.is_connected(start_corridor):
			dialogue_next_button.pressed.connect(start_corridor)
		return
	dialogue_name.text = "معمای زمان"
	dialogue_text.text = "دوربین ۳۵ دقیقه بعد از ساعت ۴:۲۰، فردی با بقچه را دیده. ساعت دوربین چند بوده؟"
	dialogue_next_button.hide()
	time_answers = HBoxContainer.new()
	time_answers.alignment = BoxContainer.ALIGNMENT_CENTER
	time_answers.add_theme_constant_override("separation", 16)
	dialogue.get_child(0).add_child(time_answers)
	for answer in ["۴:۴۵", "۴:۵۵", "۵:۲۰"]:
		var button := Button.new()
		button.text = answer
		button.custom_minimum_size = Vector2(125, 46)
		button.add_theme_font_size_override("font_size", 18)
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
	if answer == "۴:۵۵":
		time_puzzle_solved = true
		dialogue_name.text = "آفرین!"
		dialogue_text.text = "درست گفتی: ۴:۲۰ + ۳۵ دقیقه می‌شود ۴:۵۵. حالا مسیر فردِ بقچه‌به‌دست را در راهروی بازار پیدا می‌کنیم."
		dialogue_next_button.text = "بریم راهروی بازار"
		dialogue_next_button.pressed.disconnect(show_next_dialogue)
		dialogue_next_button.pressed.connect(start_corridor)
	else:
		dialogue_name.text = "یه بار دیگه فکر کن"
		dialogue_text.text = "اشکالی نداره! از ۴:۲۰، اول ۳۰ دقیقه و بعد ۵ دقیقه جلو برو. دوباره امتحان کن."
		dialogue_next_button.text = "دوباره تلاش کن"
		dialogue_next_button.pressed.disconnect(show_next_dialogue)
		dialogue_next_button.pressed.connect(retry_time_question)

func retry_time_question() -> void:
	dialogue_next_button.pressed.disconnect(retry_time_question)
	dialogue_next_button.pressed.connect(show_next_dialogue)
	show_time_question()

func close_dialogue() -> void:
	dialogue.hide()
	prompt_label.text = "مسیر بازار باز شد! در قدم بعد راهرو و نقشهٔ مسیر را می‌سازیم."

func start_corridor() -> void:
	dialogue.hide()
	scene_background.texture = CORRIDOR_BACKGROUND
	for hotspot in hotspot_buttons:
		hotspot.hide()
	notebook_button.disabled = false
	prompt_label.text = "راهروی بازار: رد کفش را دنبال کن و مسیر درست را انتخاب کن."
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
	route_panel.offset_top = -245
	route_panel.offset_right = 375
	route_panel.offset_bottom = 245
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
	route_text.text = "رد کفش‌ها و نخ قرمز به یک گذر باز می‌رسند. از کدام مسیر باید برویم تا به انبار برسیم؟"
	route_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	route_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	route_text.text_direction = Control.TEXT_DIRECTION_RTL
	route_text.add_theme_font_size_override("font_size", 21)
	route_text.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(route_text)
	route_choices = VBoxContainer.new()
	route_choices.add_theme_constant_override("separation", 9)
	content.add_child(route_choices)
	add_route_choice("راه اصلیِ شلوغ", false)
	add_route_choice("گذر خدماتیِ باز", true)
	add_route_choice("کوچهٔ بن‌بست", false)

func add_route_choice(text: String, is_correct: bool) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(300, 43)
	button.add_theme_font_size_override("font_size", 18)
	button.pressed.connect(choose_route.bind(is_correct))
	route_choices.add_child(button)

func choose_route(is_correct: bool) -> void:
	if is_correct:
		route_text.text = "آفرین! گذر خدماتی باز است و رد کفش‌ها هم به همان سمت می‌روند. حالا می‌توانیم راهی انبار شویم."
		for choice in route_choices.get_children():
			choice.queue_free()
		var next := Button.new()
		next.text = "با افراد مرتبط گفت‌وگو کنیم"
		next.custom_minimum_size = Vector2(290, 46)
		next.add_theme_font_size_override("font_size", 18)
		next.pressed.connect(start_assistant_dialogue)
		route_choices.add_child(next)
		prompt_label.text = "مسیر درست پیدا شد. قدم بعدی: بررسی انبار و رمز کمد."
	else:
		route_text.text = "این مسیر به انبار نمی‌رسد. دوباره به رد کفش و گذرِ باز نگاه کن."

func start_assistant_dialogue() -> void:
	route_panel.hide()
	scene_background.texture = ASSISTANT_DIALOGUE_BACKGROUND
	prompt_label.text = "با افراد مرتبط حرف بزن و گفته‌هایشان را با سرنخ‌ها مقایسه کن."
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
	assistant_text.add_theme_font_size_override("font_size", 23)
	assistant_text.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(assistant_text)
	assistant_next_button = Button.new()
	assistant_next_button.custom_minimum_size = Vector2(180, 46)
	assistant_next_button.add_theme_font_size_override("font_size", 18)
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
	prompt_label.text = "انبار: کمد قفل است. ترتیب نشانه‌ها را از کاغذ اعداد یادآوری کن."
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
	lock_status.text = "ترتیب یادت نیست؟ دکمهٔ «دفتر کارآگاه» پایین صفحه را بزن و کاغذ اعداد را ببین."
	lock_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lock_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	lock_status.text_direction = Control.TEXT_DIRECTION_RTL
	lock_status.add_theme_font_size_override("font_size", 20)
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
		button.add_theme_font_size_override("font_size", 17)
		button.pressed.connect(choose_symbol.bind(symbol))
		symbols.add_child(button)
	var clear := Button.new()
	clear.text = "پاک کردن ترتیب"
	clear.custom_minimum_size = Vector2(185, 42)
	clear.add_theme_font_size_override("font_size", 17)
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
			lock_status.text = "آفرین! صدای باز شدن قفل آمد. داخل کمد یک بسته با کاغذ تازه پیدا کردی."
			prompt_label.text = "کمد باز شد! حالا بسته‌بندی را با نمونه‌ها مقایسه کن."
			start_packaging_stage()
		else:
			lock_status.text = "این ترتیب قفل را باز نکرد. اشکالی ندارد؛ دفتر کارآگاه پایین صفحه را باز کن و کاغذ اعداد را دوباره ببین."
			selected_symbols.clear()
			update_lock_sequence()

func clear_lock_sequence() -> void:
	if cabinet_unlocked:
		return
	selected_symbols.clear()
	lock_status.text = "ترتیب پاک شد. اگر لازم داری، دفتر کارآگاه پایین صفحه را باز کن و کاغذ اعداد را ببین."
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
	packaging_panel.offset_top = -220
	packaging_panel.offset_right = 390
	packaging_panel.offset_bottom = 220
	packaging_panel.add_theme_stylebox_override("panel", panel_style(Color(0.10, 0.055, 0.027, 0.738), Color(0.72, 0.82, 0.68, 1), 18, 3))
	add_child(packaging_panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 13)
	packaging_panel.add_child(content)
	packaging_title = Label.new()
	packaging_title.text = "بستهٔ داخل کمد"
	packaging_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	packaging_title.text_direction = Control.TEXT_DIRECTION_RTL
	packaging_title.add_theme_font_size_override("font_size", 30)
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
	packaging_question.add_theme_font_size_override("font_size", 19)
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
	inspect.add_theme_font_size_override("font_size", 18)
	inspect.pressed.connect(show_packaging_question)
	packaging_choices.add_child(inspect)

func show_packaging_question() -> void:
	for choice in packaging_choices.get_children():
		choice.queue_free()
	packaging_title.text = "تطبیق بسته‌بندی"
	packaging_question.text = "کدام نمونه با این بسته جور درمی‌آید؟"
	packaging_question.show()
	packaging_preview.hide()
	add_packaging_choice("کاغذ سادهٔ کرم", false)
	add_packaging_choice("کاغذ گل‌دار با لبهٔ پاره", true)
	add_packaging_choice("کاغذ راه‌راه آبی", false)

func add_packaging_choice(text: String, is_correct: bool) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(350, 43)
	button.add_theme_font_size_override("font_size", 18)
	button.pressed.connect(choose_packaging.bind(is_correct))
	packaging_choices.add_child(button)

func choose_packaging(is_correct: bool) -> void:
	if packaging_solved:
		return
	if not is_correct:
		for choice in packaging_choices.get_children():
			choice.queue_free()
		packaging_question.text = "این یکی جور نیست. می‌خوای دوباره بسته را ببینی؟"
		var review := Button.new()
		review.text = "دوباره بسته را ببین"
		review.custom_minimum_size = Vector2(250, 46)
		review.add_theme_font_size_override("font_size", 18)
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
	next.add_theme_font_size_override("font_size", 18)
	next.pressed.connect(start_case_review)
	packaging_choices.add_child(next)
	prompt_label.text = "بسته‌بندی هم بررسی شد. قدم بعدی: مرور همهٔ مدرک‌ها و نتیجه‌گیری."

func start_case_review() -> void:
	packaging_panel.hide()
	scene_background.texture = CASE_REVIEW_BACKGROUND
	prompt_label.text = "میز نتیجه‌گیری: شواهد را با دقت کنار هم بگذار."
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
	case_panel.offset_top = -275
	case_panel.offset_right = 465
	case_panel.offset_bottom = 275
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
	case_status.add_theme_font_size_override("font_size", 18)
	case_status.add_theme_color_override("font_color", Color("d9efbd"))
	content.add_child(case_status)
	case_question = Label.new()
	case_question.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	case_question.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	case_question.text_direction = Control.TEXT_DIRECTION_RTL
	case_question.add_theme_font_size_override("font_size", 22)
	case_question.add_theme_color_override("font_color", Color("fff6e6"))
	content.add_child(case_question)
	case_choices = VBoxContainer.new()
	case_choices.add_theme_constant_override("separation", 8)
	content.add_child(case_choices)

func show_case_question() -> void:
	for choice in case_choices.get_children():
		choice.queue_free()
	var current: Dictionary = CASE_QUESTIONS[case_step]
	case_title.text = "تشکیل پرونده  •  گام %d از %d" % [case_step + 1, CASE_QUESTIONS.size()]
	case_status.text = "رسیدِ خرید، تطبیق بسته‌بندی، گفتهٔ مسئول انبار و قطعهٔ بازیابی‌شده را با هم مرور کن."
	case_question.text = current.question
	for index in range(current.choices.size()):
		var button := Button.new()
		button.text = current.choices[index]
		button.custom_minimum_size = Vector2(540, 42)
		button.add_theme_font_size_override("font_size", 17)
		button.pressed.connect(choose_case_answer.bind(index))
		case_choices.add_child(button)

func choose_case_answer(answer_index: int) -> void:
	if case_completed:
		return
	var current: Dictionary = CASE_QUESTIONS[case_step]
	if answer_index != current.correct:
		case_status.text = "مدرکت کافی نیست؛ دوباره بررسی کن. این نشانه به‌تنهایی چه ارتباطی با بستهٔ داخل کمد دارد؟"
		return
	case_step += 1
	if case_step < CASE_QUESTIONS.size():
		show_case_question()
		return
	show_case_ending()

func show_case_ending() -> void:
	case_completed = true
	for choice in case_choices.get_children():
		choice.queue_free()
	case_title.text = "پرونده حل شد!"
	case_status.text = "زنجیرهٔ شواهد کامل شد: شاگرد کاغذ را خرید، بستهٔ حاوی قطعه را در کمد گذاشت و ادعای ماندنش در انبار هم درست نبود."
	case_question.text = "شاگرد می‌گوید: «من برداشتمش. فکر کردم عوض شده و ترسیدم به‌جای یه کار اصل، توی نمایشگاه نشانش بدن.»\n\nاستاد می‌گوید: «پلاک اصل است؛ نشانش توی یک تعمیر قدیمی کم‌رنگ شده. خوب شد نگرانی‌ات را گفتی، ولی نباید یواشکی پنهانش می‌کردی.»"
	var restart := Button.new()
	restart.text = "شروع دوبارهٔ پرونده"
	restart.custom_minimum_size = Vector2(255, 46)
	restart.add_theme_font_size_override("font_size", 18)
	restart.pressed.connect(reset_investigation)
	case_choices.add_child(restart)
	prompt_label.text = "پرونده با بررسی شواهد و پذیرفتن مسئولیت حل شد."

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

func format_code(code: Array[int]) -> String:
	var shown: Array[String] = []
	for symbol in code:
		shown.append(["", "۱", "۲", "۳", "۴"][symbol])
	return " ← ".join(shown)

func update_notebook_code_text() -> void:
	if notebook_clues_text:
		notebook_clues_text.text = "• ساعت روی ۴:۲۰ مانده، اما خراب است\n• رسید کاغذی، نخ قرمز، رد کفش و کاغذ اعداد\n• ترتیب روی کاغذ: %s\n\nاین دفتر همیشه برای مرور سرنخ‌ها در دسترس است." % format_code(lock_code)

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
