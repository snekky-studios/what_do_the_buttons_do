class_name Main
extends Control

#region Preloads
const BUTTON_TEXTURE_BLANK : Texture2D = preload("res://assets/sprites/buttons/button_blank.png")
const BUTTON_SYMBOL_TEXTURE_BETA : Texture2D = preload("res://assets/sprites/buttons/symbol_beta.png")
const BUTTON_SYMBOL_TEXTURE_GAMMA : Texture2D = preload("res://assets/sprites/buttons/symbol_gamma.png")
const BUTTON_SYMBOL_TEXTURE_OMEGA : Texture2D = preload("res://assets/sprites/buttons/symbol_omega.png")
const BUTTON_SYMBOL_TEXTURE_THETA : Texture2D = preload("res://assets/sprites/buttons/symbol_theta.png")
#endregion

#region Constants
enum Difficulty
{
	EASY,
	HARD
}

enum ButtonIdentifier
{
	SHAPE_CIRCLE = 0,
	SHAPE_SQUARE = 1,
	SHAPE_TRIANGLE = 2,
	SHAPE_PENTAGON = 3,
	COLOR_PINK = 4,
	COLOR_ORANGE = 5,
	COLOR_YELLOW = 6,
	COLOR_TEAL = 7,
	SYMBOL_BETA = 8,
	SYMBOL_GAMMA = 9,
	SYMBOL_OMEGA = 10,
	SYMBOL_THETA = 11,
	NONE = 12
}

const ButtonShape : Dictionary = {
	ButtonIdentifier.SHAPE_CIRCLE : 0,
	ButtonIdentifier.SHAPE_SQUARE : 1,
	ButtonIdentifier.SHAPE_TRIANGLE : 2,
	ButtonIdentifier.SHAPE_PENTAGON : 3
}

const ButtonColor : Dictionary = {
	ButtonIdentifier.COLOR_PINK : COLOR_PINK,
	ButtonIdentifier.COLOR_ORANGE : COLOR_ORANGE,
	ButtonIdentifier.COLOR_YELLOW : COLOR_YELLOW,
	ButtonIdentifier.COLOR_TEAL : COLOR_TEAL
}

const ButtonSymbol : Dictionary = {
	ButtonIdentifier.SYMBOL_BETA : BUTTON_SYMBOL_TEXTURE_BETA,
	ButtonIdentifier.SYMBOL_GAMMA : BUTTON_SYMBOL_TEXTURE_GAMMA,
	ButtonIdentifier.SYMBOL_OMEGA : BUTTON_SYMBOL_TEXTURE_OMEGA,
	ButtonIdentifier.SYMBOL_THETA : BUTTON_SYMBOL_TEXTURE_THETA
}

enum Operator
{
	ADD_COLOR_RECT,
	MULT_HORIZONTAL_SIZE,
	MULT_SPEED,
	NONE
}

enum Operand
{
	_025_NEG_2,
	_050_NEG_1,
	_150_POS_1,
	_200_POS_2,
	NONE
}

const COLOR_PURPLE : Color = Color(0.169, 0.059, 0.329)
const COLOR_RED : Color = Color(0.671, 0.122, 0.396)
const COLOR_PINK : Color = Color(1.0, 0.31, 0.412)
const COLOR_WHITE : Color = Color(1.0, 0.969, 0.973)
const COLOR_ORANGE : Color = Color(1.0, 0.506, 0.259)
const COLOR_YELLOW : Color = Color(1.0, 0.855, 0.271)
const COLOR_BLUE : Color = Color(0.2, 0.408, 0.863)
const COLOR_TEAL : Color = Color(0.286, 0.906, 0.925)

const LOOP_VALUE_MAX : float = 1840.0

const COLOR_RECT_CHANGE_THRESHOLD_MIN : float = (1.0 / 60.0)

const PROGRESS_BAR_UPDATE_SPEED : float = 0.5
#endregion

#region Global Variables
var difficulty : Difficulty = Difficulty.HARD
var started : bool = false

var loop_value : float = 0.0
var loop_value_increment : float = 1.0
var loop_value_start : float = 0.0
var loop_value_end : float = 0.0

var color_rects : Array[ColorRect] = []
var index_color_rect_active : int = 0

var color_rect_count : int = 10
var color_rect_width : float = 20
var color_rect_change_progress : float = 0.0
var color_rect_change_threshold : float = 1.0

var BUTTON_IDENTIFIERS : Array[ButtonIdentifier] = [
	ButtonIdentifier.SHAPE_CIRCLE, ButtonIdentifier.SHAPE_SQUARE, ButtonIdentifier.SHAPE_TRIANGLE, ButtonIdentifier.SHAPE_PENTAGON,
	ButtonIdentifier.COLOR_PINK, ButtonIdentifier.COLOR_ORANGE, ButtonIdentifier.COLOR_YELLOW, ButtonIdentifier.COLOR_TEAL,
	ButtonIdentifier.SYMBOL_BETA, ButtonIdentifier.SYMBOL_GAMMA, ButtonIdentifier.SYMBOL_OMEGA, ButtonIdentifier.SYMBOL_THETA
]

var selected_button_operator : int = -1
var selected_button_operand : int = -1
var selected_texture_button_operator : TextureButton = null
var selected_texture_button_operand : TextureButton = null
var selected_button_symbol_operator : Sprite2D = null
var selected_button_symbol_operand : Sprite2D = null

var OPERATOR_IDENTIFIERS : Dictionary = {}
var OPERAND_IDENTIFIERS : Dictionary = {}

var taken_identifiers_operator : Array[ButtonIdentifier] = []
var available_shapes_operator : Array[ButtonIdentifier] = [ButtonIdentifier.SHAPE_CIRCLE, ButtonIdentifier.SHAPE_SQUARE, ButtonIdentifier.SHAPE_TRIANGLE, ButtonIdentifier.SHAPE_PENTAGON]
var available_colors_operator : Array[ButtonIdentifier] = [ButtonIdentifier.COLOR_PINK, ButtonIdentifier.COLOR_ORANGE, ButtonIdentifier.COLOR_YELLOW, ButtonIdentifier.COLOR_TEAL]
var available_symbols_operator : Array[ButtonIdentifier] = [ButtonIdentifier.SYMBOL_BETA, ButtonIdentifier.SYMBOL_GAMMA, ButtonIdentifier.SYMBOL_OMEGA, ButtonIdentifier.SYMBOL_THETA]

var taken_identifiers_operand : Array[ButtonIdentifier] = []
var available_shapes_operand : Array[ButtonIdentifier] = [ButtonIdentifier.SHAPE_CIRCLE, ButtonIdentifier.SHAPE_SQUARE, ButtonIdentifier.SHAPE_TRIANGLE, ButtonIdentifier.SHAPE_PENTAGON]
var available_colors_operand : Array[ButtonIdentifier] = [ButtonIdentifier.COLOR_PINK, ButtonIdentifier.COLOR_ORANGE, ButtonIdentifier.COLOR_YELLOW, ButtonIdentifier.COLOR_TEAL]
var available_symbols_operand : Array[ButtonIdentifier] = [ButtonIdentifier.SYMBOL_BETA, ButtonIdentifier.SYMBOL_GAMMA, ButtonIdentifier.SYMBOL_OMEGA, ButtonIdentifier.SYMBOL_THETA]
#endregion

#region Node Declarations
var vbox_container_menu : VBoxContainer = null
var texture_rect_game_over : TextureRect = null

var audio_stream_player_c : AudioStreamPlayer = null
var audio_stream_player_e : AudioStreamPlayer = null
var audio_stream_player_g : AudioStreamPlayer = null
var timer_game : Timer = null
var timer_update : Timer = null
var label_difficulty : Label = null
var label_score : Label = null
var label_time : Label = null

var vbox_container_color_rects : VBoxContainer = null
var vbox_container_buttons_operator : VBoxContainer = null
var vbox_container_buttons_operand : VBoxContainer = null

var texture_button_operator_0 : TextureButton = null
var texture_button_operator_1 : TextureButton = null
var texture_button_operator_2 : TextureButton = null
var texture_button_operator_3 : TextureButton = null

var button_symbol_operator_0 : Sprite2D = null
var button_symbol_operator_1 : Sprite2D = null
var button_symbol_operator_2 : Sprite2D = null
var button_symbol_operator_3 : Sprite2D = null

var button_halo_operator_0 : Sprite2D = null
var button_halo_operator_1 : Sprite2D = null
var button_halo_operator_2 : Sprite2D = null
var button_halo_operator_3 : Sprite2D = null

var texture_button_operand_0 : TextureButton = null
var texture_button_operand_1 : TextureButton = null
var texture_button_operand_2 : TextureButton = null
var texture_button_operand_3 : TextureButton = null

var button_symbol_operand_0 : Sprite2D = null
var button_symbol_operand_1 : Sprite2D = null
var button_symbol_operand_2 : Sprite2D = null
var button_symbol_operand_3 : Sprite2D = null

var button_halo_operand_0 : Sprite2D = null
var button_halo_operand_1 : Sprite2D = null
var button_halo_operand_2 : Sprite2D = null
var button_halo_operand_3 : Sprite2D = null

var texture_progress_top_left : TextureProgressBar = null
var texture_progress_top : TextureProgressBar = null
var texture_progress_top_right : TextureProgressBar = null
var texture_progress_right : TextureProgressBar = null
var texture_progress_bottom_right : TextureProgressBar = null
var texture_progress_bottom : TextureProgressBar = null
var texture_progress_bottom_left : TextureProgressBar = null
var texture_progress_left : TextureProgressBar = null

var button_blocker : Control = null
#endregion

func _ready() -> void:
	#region Node Assignments
	vbox_container_menu = %VBoxContainerMenu
	texture_rect_game_over = %TextureRectGameOver
	
	audio_stream_player_c = %AudioStreamPlayerC
	audio_stream_player_e = %AudioStreamPlayerE
	audio_stream_player_g = %AudioStreamPlayerG
	timer_game = %TimerGame
	timer_update = %TimerUpdate
	label_difficulty = %LabelDifficulty
	label_score = %LabelScore
	label_time = %LabelTime
	
	vbox_container_color_rects = %VBoxContainerColorRects
	vbox_container_buttons_operator = %VBoxContainerButtonsOperator
	vbox_container_buttons_operand = %VBoxContainerButtonsOperand
	
	texture_button_operator_0 = %TextureButtonOperator0
	texture_button_operator_1 = %TextureButtonOperator1
	texture_button_operator_2 = %TextureButtonOperator2
	texture_button_operator_3 = %TextureButtonOperator3

	button_symbol_operator_0 = %ButtonSymbolOperator0
	button_symbol_operator_1 = %ButtonSymbolOperator1
	button_symbol_operator_2 = %ButtonSymbolOperator2
	button_symbol_operator_3 = %ButtonSymbolOperator3
	
	button_halo_operator_0 = %ButtonHaloOperator0
	button_halo_operator_1 = %ButtonHaloOperator1
	button_halo_operator_2 = %ButtonHaloOperator2
	button_halo_operator_3 = %ButtonHaloOperator3
	
	texture_button_operand_0 = %TextureButtonOperand0
	texture_button_operand_1 = %TextureButtonOperand1
	texture_button_operand_2 = %TextureButtonOperand2
	texture_button_operand_3 = %TextureButtonOperand3

	button_symbol_operand_0 = %ButtonSymbolOperand0
	button_symbol_operand_1 = %ButtonSymbolOperand1
	button_symbol_operand_2 = %ButtonSymbolOperand2
	button_symbol_operand_3 = %ButtonSymbolOperand3

	button_halo_operand_0 = %ButtonHaloOperand0
	button_halo_operand_1 = %ButtonHaloOperand1
	button_halo_operand_2 = %ButtonHaloOperand2
	button_halo_operand_3 = %ButtonHaloOperand3

	texture_progress_top_left = %TextureProgressTopLeft
	texture_progress_top = %TextureProgressTop
	texture_progress_top_right = %TextureProgressTopRight
	texture_progress_right = %TextureProgressRight
	texture_progress_bottom_right = %TextureProgressBottomRight
	texture_progress_bottom = %TextureProgressBottom
	texture_progress_bottom_left = %TextureProgressBottomLeft
	texture_progress_left = %TextureProgressLeft
	
	button_blocker = %ButtonBlocker
	#endregion
	
	assign_operator_identifiers()
	assign_operand_identifiers()
	
	setup_operator_buttons()
	setup_operand_buttons()
	return

func _physics_process(delta: float) -> void:
	if(not started):
		return
	color_rect_change_progress += delta
	if(color_rect_change_progress >= color_rect_change_threshold):
		var index_audio_to_play : int = index_color_rect_active % 3
		match index_audio_to_play:
			0:
				audio_stream_player_c.play()
				audio_stream_player_e.stop()
				audio_stream_player_g.stop()
			1:
				audio_stream_player_c.stop()
				audio_stream_player_e.play()
				audio_stream_player_g.stop()
			2:
				audio_stream_player_c.stop()
				audio_stream_player_e.stop()
				audio_stream_player_g.play()
			_:
				audio_stream_player_c.stop()
				audio_stream_player_e.stop()
				audio_stream_player_g.stop()
		color_rect_change_progress = 0.0
		index_color_rect_active += 1
		if(index_color_rect_active >= color_rect_count):
			loop_value_start = loop_value
			loop_value += loop_value_increment
			loop_value_end = loop_value
			index_color_rect_active = 0
			var tween : Tween = get_tree().create_tween()
			tween.tween_method(update_progress_bars, loop_value_start, loop_value_end, 1.0 * color_rect_count * color_rect_change_threshold)
			update_score(loop_value)
			if(loop_value >= LOOP_VALUE_MAX):
				game_over()
				return
		update_color_rects()
	return

func update_color_rects() -> void:
	for index_color_rect : int in range(color_rect_count):
		# set colors
		if(index_color_rect == index_color_rect_active):
			color_rects[index_color_rect].color = COLOR_RED
		else:
			color_rects[index_color_rect].color = COLOR_WHITE
		# set size
		color_rects[index_color_rect].custom_minimum_size = Vector2(color_rect_width, 0)
	return

func delete_color_rects() -> void:
	var num_color_rects_alive : int = color_rects.size()
	for index_color_rect : int in range(0, num_color_rects_alive):
			color_rects[index_color_rect].queue_free()
	color_rects.resize(0)
	index_color_rect_active = 0
	return

func update_progress_bars(value : float) -> void:
	texture_progress_top_left.value = value
	texture_progress_top.value = value
	texture_progress_top_right.value = value
	texture_progress_right.value = value
	texture_progress_bottom_right.value = value
	texture_progress_bottom.value = value
	texture_progress_bottom_left.value = value
	texture_progress_left.value = value
	return

func update_score(value : float) -> void:
	label_score.text = str(int(snappedf(value, 1.0)))
	return

func add_color_rect(num_to_add : int) -> void:
	if(num_to_add > 0):
		color_rect_count += num_to_add
		for index_color_rect : int in range(num_to_add):
			var color_rect : ColorRect = ColorRect.new()
			color_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			color_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
			color_rect.custom_minimum_size = Vector2(color_rect_width, 0)
			color_rects.append(color_rect)
			vbox_container_color_rects.add_child(color_rect)
	elif(num_to_add < 0):
		color_rect_count += num_to_add
		if(color_rect_count <= 2):
			# don't let color rect count drop below 2, we want to make sure the "active" rectangle keeps switching
			color_rect_count = 2
		var num_color_rects_alive : int = color_rects.size()
		for index_color_rect : int in range(color_rect_count, num_color_rects_alive):
			color_rects[index_color_rect].queue_free()
		color_rects.resize(color_rect_count)
		if(index_color_rect_active >= color_rect_count):
			index_color_rect_active = color_rect_count - 2
		pass
	return

func mult_horizontal_size(value : float) -> void:
	color_rect_width *= value
	if(color_rect_width > 380):
		color_rect_width = 380
	elif(color_rect_width < 10):
		color_rect_width = 10
	loop_value_increment = color_rect_width / 10.0
	update_color_rects()
	return

func mult_speed(value : float) -> void:
	color_rect_change_threshold *= value
	if(color_rect_change_threshold < COLOR_RECT_CHANGE_THRESHOLD_MIN):
		color_rect_change_threshold = COLOR_RECT_CHANGE_THRESHOLD_MIN
	if(color_rect_change_progress >= color_rect_change_threshold):
		color_rect_change_progress = 0
	return

func assign_operator_identifiers() -> void:
	BUTTON_IDENTIFIERS.shuffle()
	
	OPERATOR_IDENTIFIERS[Operator.ADD_COLOR_RECT] = BUTTON_IDENTIFIERS[0]
	taken_identifiers_operator.append(BUTTON_IDENTIFIERS[0])
	available_shapes_operator.erase(BUTTON_IDENTIFIERS[0])
	available_colors_operator.erase(BUTTON_IDENTIFIERS[0])
	available_symbols_operator.erase(BUTTON_IDENTIFIERS[0])
	
	OPERATOR_IDENTIFIERS[Operator.MULT_HORIZONTAL_SIZE] = BUTTON_IDENTIFIERS[1]
	taken_identifiers_operator.append(BUTTON_IDENTIFIERS[1])
	available_shapes_operator.erase(BUTTON_IDENTIFIERS[1])
	available_colors_operator.erase(BUTTON_IDENTIFIERS[1])
	available_symbols_operator.erase(BUTTON_IDENTIFIERS[1])
	
	OPERATOR_IDENTIFIERS[Operator.MULT_SPEED] = BUTTON_IDENTIFIERS[2]
	taken_identifiers_operator.append(BUTTON_IDENTIFIERS[2])
	available_shapes_operator.erase(BUTTON_IDENTIFIERS[2])
	available_colors_operator.erase(BUTTON_IDENTIFIERS[2])
	available_symbols_operator.erase(BUTTON_IDENTIFIERS[2])
	
	OPERATOR_IDENTIFIERS[Operator.NONE] = BUTTON_IDENTIFIERS[3]
	taken_identifiers_operator.append(BUTTON_IDENTIFIERS[3])
	available_shapes_operator.erase(BUTTON_IDENTIFIERS[3])
	available_colors_operator.erase(BUTTON_IDENTIFIERS[3])
	available_symbols_operator.erase(BUTTON_IDENTIFIERS[3])
	return

func assign_operand_identifiers() -> void:
	BUTTON_IDENTIFIERS.shuffle()
	
	#operand_025_NEG_2_identifier = BUTTON_IDENTIFIERS[0]
	OPERAND_IDENTIFIERS[Operand._025_NEG_2] = BUTTON_IDENTIFIERS[0]
	taken_identifiers_operand.append(BUTTON_IDENTIFIERS[0])
	available_shapes_operand.erase(BUTTON_IDENTIFIERS[0])
	available_colors_operand.erase(BUTTON_IDENTIFIERS[0])
	available_symbols_operand.erase(BUTTON_IDENTIFIERS[0])
	
	#operand_050_NEG_1_identifier = BUTTON_IDENTIFIERS[1]
	OPERAND_IDENTIFIERS[Operand._050_NEG_1] = BUTTON_IDENTIFIERS[1]
	taken_identifiers_operand.append(BUTTON_IDENTIFIERS[1])
	available_shapes_operand.erase(BUTTON_IDENTIFIERS[1])
	available_colors_operand.erase(BUTTON_IDENTIFIERS[1])
	available_symbols_operand.erase(BUTTON_IDENTIFIERS[1])
	
	#operand_150_POS_1_identifier = BUTTON_IDENTIFIERS[2]
	OPERAND_IDENTIFIERS[Operand._150_POS_1] = BUTTON_IDENTIFIERS[2]
	taken_identifiers_operand.append(BUTTON_IDENTIFIERS[2])
	available_shapes_operand.erase(BUTTON_IDENTIFIERS[2])
	available_colors_operand.erase(BUTTON_IDENTIFIERS[2])
	available_symbols_operand.erase(BUTTON_IDENTIFIERS[2])
	
	#operand_200_POS_2_identifier = BUTTON_IDENTIFIERS[3]
	OPERAND_IDENTIFIERS[Operand._200_POS_2] = BUTTON_IDENTIFIERS[3]
	taken_identifiers_operand.append(BUTTON_IDENTIFIERS[3])
	available_shapes_operand.erase(BUTTON_IDENTIFIERS[3])
	available_colors_operand.erase(BUTTON_IDENTIFIERS[3])
	available_symbols_operand.erase(BUTTON_IDENTIFIERS[3])
	return

func assign_button_shape(button : TextureButton, identifier : ButtonIdentifier) -> void:
	button.material.set_shader_parameter("shape", ButtonShape[identifier])
	return

func assign_button_color(button : TextureButton, identifier : ButtonIdentifier) -> void:
	button.material.set_shader_parameter("color", ButtonColor[identifier])
	return

func assign_button_symbol(button_symbol : Sprite2D, identifier : ButtonIdentifier) -> void:
	button_symbol.texture = ButtonSymbol[identifier]
	return

func setup_button(button : TextureButton, button_symbol : Sprite2D, identifier : ButtonIdentifier,
		available_shape_identifiers : Array[ButtonIdentifier], available_color_identifiers : Array[ButtonIdentifier], available_symbol_identifiers : Array[ButtonIdentifier]) -> void:
	match identifier:
		ButtonIdentifier.SHAPE_CIRCLE, ButtonIdentifier.SHAPE_SQUARE, ButtonIdentifier.SHAPE_TRIANGLE, ButtonIdentifier.SHAPE_PENTAGON:
			assign_button_shape(button, identifier)
			var color_identifier : ButtonIdentifier = available_color_identifiers.pick_random()
			assign_button_color(button, color_identifier)
			available_color_identifiers.erase(color_identifier)
			var symbol_identifier : ButtonIdentifier = available_symbol_identifiers.pick_random()
			assign_button_symbol(button_symbol, symbol_identifier)
			available_symbol_identifiers.erase(symbol_identifier)
		ButtonIdentifier.COLOR_PINK, ButtonIdentifier.COLOR_ORANGE, ButtonIdentifier.COLOR_YELLOW, ButtonIdentifier.COLOR_TEAL:
			var shape_identifier : ButtonIdentifier = available_shape_identifiers.pick_random()
			assign_button_shape(button, shape_identifier)
			available_shape_identifiers.erase(shape_identifier)
			assign_button_color(button, identifier)
			var symbol_identifier : ButtonIdentifier = available_symbol_identifiers.pick_random()
			assign_button_symbol(button_symbol, symbol_identifier)
			available_symbol_identifiers.erase(symbol_identifier)
		ButtonIdentifier.SYMBOL_BETA, ButtonIdentifier.SYMBOL_GAMMA, ButtonIdentifier.SYMBOL_OMEGA, ButtonIdentifier.SYMBOL_THETA:
			var shape_identifier : ButtonIdentifier = available_shape_identifiers.pick_random()
			assign_button_shape(button, shape_identifier)
			available_shape_identifiers.erase(shape_identifier)
			var color_identifier : ButtonIdentifier = available_color_identifiers.pick_random()
			assign_button_color(button, color_identifier)
			available_color_identifiers.erase(color_identifier)
			assign_button_symbol(button_symbol, identifier)
	return

func setup_operator_buttons() -> void:
	taken_identifiers_operator.shuffle()
	var available_shape_identifiers : Array[ButtonIdentifier] = available_shapes_operator.duplicate()
	var available_color_identifiers : Array[ButtonIdentifier] = available_colors_operator.duplicate()
	var available_symbol_identifiers : Array[ButtonIdentifier] = available_symbols_operator.duplicate()

	setup_button(texture_button_operator_0, button_symbol_operator_0, taken_identifiers_operator[0],
			available_shape_identifiers, available_color_identifiers, available_symbol_identifiers)
	setup_button(texture_button_operator_1, button_symbol_operator_1, taken_identifiers_operator[1],
			available_shape_identifiers, available_color_identifiers, available_symbol_identifiers)
	setup_button(texture_button_operator_2, button_symbol_operator_2, taken_identifiers_operator[2],
			available_shape_identifiers, available_color_identifiers, available_symbol_identifiers)
	setup_button(texture_button_operator_3, button_symbol_operator_3, taken_identifiers_operator[3],
			available_shape_identifiers, available_color_identifiers, available_symbol_identifiers)
	return

func setup_operand_buttons() -> void:
	taken_identifiers_operand.shuffle()
	var available_shape_identifiers : Array[ButtonIdentifier] = available_shapes_operand.duplicate()
	var available_color_identifiers : Array[ButtonIdentifier] = available_colors_operand.duplicate()
	var available_symbol_identifiers : Array[ButtonIdentifier] = available_symbols_operand.duplicate()

	setup_button(texture_button_operand_0, button_symbol_operand_0, taken_identifiers_operand[0],
			available_shape_identifiers, available_color_identifiers, available_symbol_identifiers)
	setup_button(texture_button_operand_1, button_symbol_operand_1, taken_identifiers_operand[1],
			available_shape_identifiers, available_color_identifiers, available_symbol_identifiers)
	setup_button(texture_button_operand_2, button_symbol_operand_2, taken_identifiers_operand[2],
			available_shape_identifiers, available_color_identifiers, available_symbol_identifiers)
	setup_button(texture_button_operand_3, button_symbol_operand_3, taken_identifiers_operand[3],
			available_shape_identifiers, available_color_identifiers, available_symbol_identifiers)
	return

func get_operator_from_button(texture_button : TextureButton, button_symbol : Sprite2D) -> Operator:
	var shape : int = texture_button.material.get_shader_parameter("shape")
	var shape_identifier : ButtonIdentifier = ButtonShape.find_key(shape)
	if(OPERATOR_IDENTIFIERS.find_key(shape_identifier) != null):
		return OPERATOR_IDENTIFIERS.find_key(shape_identifier)
	var color : Color = texture_button.material.get_shader_parameter("color")
	var color_identifier : ButtonIdentifier = ButtonColor.find_key(color)
	if(OPERATOR_IDENTIFIERS.find_key(color_identifier) != null):
		return OPERATOR_IDENTIFIERS.find_key(color_identifier)
	var symbol : Texture2D = button_symbol.texture
	var symbol_identifier : ButtonIdentifier = ButtonSymbol.find_key(symbol)
	if(OPERATOR_IDENTIFIERS.find_key(symbol_identifier) != null):
		return OPERATOR_IDENTIFIERS.find_key(symbol_identifier)
	return Operator.NONE

func get_operand_from_button(texture_button : TextureButton, button_symbol : Sprite2D) -> Operand:
	var shape : int = texture_button.material.get_shader_parameter("shape")
	var shape_identifier : ButtonIdentifier = ButtonShape.find_key(shape)
	if(OPERAND_IDENTIFIERS.find_key(shape_identifier) != null):
		return OPERAND_IDENTIFIERS.find_key(shape_identifier)
	var color : Color = texture_button.material.get_shader_parameter("color")
	var color_identifier : ButtonIdentifier = ButtonColor.find_key(color)
	if(OPERAND_IDENTIFIERS.find_key(color_identifier) != null):
		return OPERAND_IDENTIFIERS.find_key(color_identifier)
	var symbol : Texture2D = button_symbol.texture
	var symbol_identifier : ButtonIdentifier = ButtonSymbol.find_key(symbol)
	if(OPERAND_IDENTIFIERS.find_key(symbol_identifier) != null):
		return OPERAND_IDENTIFIERS.find_key(symbol_identifier)
	return Operand.NONE

func apply_operator(texture_button_operator : TextureButton, texture_button_operand : TextureButton,
		button_symbol_operator : Sprite2D, button_symbol_operand : Sprite2D) -> void:
	var operator : Operator = get_operator_from_button(texture_button_operator, button_symbol_operator)
	var operand : Operand = get_operand_from_button(texture_button_operand, button_symbol_operand)
	
	match operator:
		Operator.ADD_COLOR_RECT:
			match operand:
				Operand._025_NEG_2:
					add_color_rect(-2)
				Operand._050_NEG_1:
					add_color_rect(-1)
				Operand._150_POS_1:
					add_color_rect(1)
				Operand._200_POS_2:
					add_color_rect(2)
		Operator.MULT_HORIZONTAL_SIZE:
			match operand:
				Operand._025_NEG_2:
					mult_horizontal_size(0.25)
				Operand._050_NEG_1:
					mult_horizontal_size(0.50)
				Operand._150_POS_1:
					mult_horizontal_size(1.50)
				Operand._200_POS_2:
					mult_horizontal_size(2.00)
		Operator.MULT_SPEED:
			match operand:
				Operand._025_NEG_2:
					mult_speed(0.25)
				Operand._050_NEG_1:
					mult_speed(0.50)
				Operand._150_POS_1:
					mult_speed(1.50)
				Operand._200_POS_2:
					mult_speed(2.00)
		Operator.NONE:
			pass
	
	selected_texture_button_operator = null
	selected_texture_button_operand = null
	selected_button_symbol_operator = null
	selected_button_symbol_operand = null
	
	if(difficulty == Difficulty.HARD):
		setup_operator_buttons()
		setup_operand_buttons()
	return

func start_game() -> void:
	if(difficulty == Difficulty.EASY):
		label_difficulty.text = "EASY"
		timer_game.wait_time = 60
	else:
		label_difficulty.text = "HARD"
		timer_game.wait_time = 180
	label_time.text = str(int(timer_game.wait_time))
	button_blocker.hide()
	for index_color_rect : int in range(color_rect_count):
		var color_rect : ColorRect = ColorRect.new()
		color_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		color_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
		color_rects.append(color_rect)
		vbox_container_color_rects.add_child(color_rect)
	update_color_rects()
	timer_update.start()
	
	timer_game.start()
	started = true
	return

func game_over() -> void:
	started = false
	var time_left : float = timer_game.time_left
	if(time_left > 59.0):
		# timer timed out and reset back to 60
		time_left = 0.0
	timer_update.stop()
	timer_game.stop()
	button_blocker.show()
	delete_color_rects()
	texture_rect_game_over.show()
	
	var score_start : float = loop_value
	print(loop_value, " ", time_left, " ", LOOP_VALUE_MAX * (time_left) / 60.0)
	var score_end : float = loop_value + (LOOP_VALUE_MAX * (time_left) / 60.0)
	var tween : Tween = get_tree().create_tween()
	tween.tween_method(update_score, score_start, score_end, 3.0)
	
	loop_value = 0.0
	loop_value_increment = 1.0
	color_rect_width = 20.0
	color_rect_count = 10
	color_rect_change_progress = 0.0
	color_rect_change_threshold = 1.0
	
	var game_over_timer : SceneTreeTimer = get_tree().create_timer(5.0)
	game_over_timer.timeout.connect(_on_game_over_timeout)
	return

func disconnect_all_callables(signal_to_disconnect : Signal) -> void:
	for connection : Dictionary in signal_to_disconnect.get_connections():
		signal_to_disconnect.disconnect(connection.callable)
	return

func reset_buttons() -> void:
	button_halo_operator_0.hide()
	button_halo_operator_1.hide()
	button_halo_operator_2.hide()
	button_halo_operator_3.hide()
	texture_button_operator_0.button_pressed = false
	texture_button_operator_1.button_pressed = false
	texture_button_operator_2.button_pressed = false
	texture_button_operator_3.button_pressed = false
	button_halo_operand_0.hide()
	button_halo_operand_1.hide()
	button_halo_operand_2.hide()
	button_halo_operand_3.hide()
	texture_button_operand_0.button_pressed = false
	texture_button_operand_1.button_pressed = false
	texture_button_operand_2.button_pressed = false
	texture_button_operand_3.button_pressed = false
	return

#region Gameplay Button Callbacks
func _on_texture_button_operator_0_pressed() -> void:
	button_halo_operator_0.show()
	button_halo_operator_1.hide()
	button_halo_operator_2.hide()
	button_halo_operator_3.hide()
	texture_button_operator_1.button_pressed = false
	texture_button_operator_2.button_pressed = false
	texture_button_operator_3.button_pressed = false
	selected_texture_button_operator = texture_button_operator_0
	selected_button_symbol_operator = button_symbol_operator_0
	if(selected_texture_button_operand != null):
		apply_operator(selected_texture_button_operator, selected_texture_button_operand, selected_button_symbol_operator, selected_button_symbol_operand)
		reset_buttons()
	return

func _on_texture_button_operator_1_pressed() -> void:
	button_halo_operator_0.hide()
	button_halo_operator_1.show()
	button_halo_operator_2.hide()
	button_halo_operator_3.hide()
	texture_button_operator_0.button_pressed = false
	texture_button_operator_2.button_pressed = false
	texture_button_operator_3.button_pressed = false
	selected_texture_button_operator = texture_button_operator_1
	selected_button_symbol_operator = button_symbol_operator_1
	if(selected_texture_button_operand != null):
		apply_operator(selected_texture_button_operator, selected_texture_button_operand, selected_button_symbol_operator, selected_button_symbol_operand)
		reset_buttons()
	return

func _on_texture_button_operator_2_pressed() -> void:
	button_halo_operator_0.hide()
	button_halo_operator_1.hide()
	button_halo_operator_2.show()
	button_halo_operator_3.hide()
	texture_button_operator_0.button_pressed = false
	texture_button_operator_1.button_pressed = false
	texture_button_operator_3.button_pressed = false
	selected_texture_button_operator = texture_button_operator_2
	selected_button_symbol_operator = button_symbol_operator_2
	if(selected_texture_button_operand != null):
		apply_operator(selected_texture_button_operator, selected_texture_button_operand, selected_button_symbol_operator, selected_button_symbol_operand)
		reset_buttons()
	return

func _on_texture_button_operator_3_pressed() -> void:
	button_halo_operator_0.hide()
	button_halo_operator_1.hide()
	button_halo_operator_2.hide()
	button_halo_operator_3.show()
	texture_button_operator_0.button_pressed = false
	texture_button_operator_1.button_pressed = false
	texture_button_operator_2.button_pressed = false
	selected_texture_button_operator = texture_button_operator_3
	selected_button_symbol_operator = button_symbol_operator_3
	if(selected_texture_button_operand != null):
		apply_operator(selected_texture_button_operator, selected_texture_button_operand, selected_button_symbol_operator, selected_button_symbol_operand)
		reset_buttons()
	return

func _on_texture_button_operand_0_pressed() -> void:
	button_halo_operand_0.show()
	button_halo_operand_1.hide()
	button_halo_operand_2.hide()
	button_halo_operand_3.hide()
	texture_button_operand_1.button_pressed = false
	texture_button_operand_2.button_pressed = false
	texture_button_operand_3.button_pressed = false
	selected_texture_button_operand = texture_button_operand_0
	selected_button_symbol_operand = button_symbol_operand_0
	if(selected_texture_button_operator != null):
		apply_operator(selected_texture_button_operator, selected_texture_button_operand, selected_button_symbol_operator, selected_button_symbol_operand)
		reset_buttons()
	return

func _on_texture_button_operand_1_pressed() -> void:
	button_halo_operand_0.hide()
	button_halo_operand_1.show()
	button_halo_operand_2.hide()
	button_halo_operand_3.hide()
	texture_button_operand_0.button_pressed = false
	texture_button_operand_2.button_pressed = false
	texture_button_operand_3.button_pressed = false
	selected_texture_button_operand = texture_button_operand_1
	selected_button_symbol_operand = button_symbol_operand_1
	if(selected_texture_button_operator != null):
		apply_operator(selected_texture_button_operator, selected_texture_button_operand, selected_button_symbol_operator, selected_button_symbol_operand)
		reset_buttons()
	return

func _on_texture_button_operand_2_pressed() -> void:
	button_halo_operand_0.hide()
	button_halo_operand_1.hide()
	button_halo_operand_2.show()
	button_halo_operand_3.hide()
	texture_button_operand_0.button_pressed = false
	texture_button_operand_1.button_pressed = false
	texture_button_operand_3.button_pressed = false
	selected_texture_button_operand = texture_button_operand_2
	selected_button_symbol_operand = button_symbol_operand_2
	if(selected_texture_button_operator != null):
		apply_operator(selected_texture_button_operator, selected_texture_button_operand, selected_button_symbol_operator, selected_button_symbol_operand)
		reset_buttons()
	return

func _on_texture_button_operand_3_pressed() -> void:
	button_halo_operand_0.hide()
	button_halo_operand_1.hide()
	button_halo_operand_2.hide()
	button_halo_operand_3.show()
	texture_button_operand_0.button_pressed = false
	texture_button_operand_1.button_pressed = false
	texture_button_operand_2.button_pressed = false
	selected_texture_button_operand = texture_button_operand_3
	selected_button_symbol_operand = button_symbol_operand_3
	if(selected_texture_button_operator != null):
		apply_operator(selected_texture_button_operator, selected_texture_button_operand, selected_button_symbol_operator, selected_button_symbol_operand)
		reset_buttons()
	return
#endregion

func _on_texture_button_easy_pressed() -> void:
	vbox_container_menu.hide()
	difficulty = Difficulty.EASY
	label_score.text = "0"
	label_time.text = "60"
	update_progress_bars(0)
	start_game()
	return

func _on_texture_button_hard_pressed() -> void:
	vbox_container_menu.hide()
	difficulty = Difficulty.HARD
	label_score.text = "0"
	label_time.text = "60"
	update_progress_bars(0)
	start_game()
	return

func _on_game_over_timeout() -> void:
	audio_stream_player_c.stop()
	audio_stream_player_e.stop()
	audio_stream_player_g.stop()
	button_blocker.show()
	texture_rect_game_over.hide()
	vbox_container_menu.show()
	return

func _on_timer_game_timeout() -> void:
	game_over()
	return

func _on_timer_update_timeout() -> void:
	label_time.text = str(int(timer_game.time_left))
	return
