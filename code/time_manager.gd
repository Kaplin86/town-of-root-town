extends Node

var currentSpeed = 1

func _ready() -> void:
	Engine.time_scale = currentSpeed
	clear()
	speed1()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1speed"):
		clear()
		speed1()
	if Input.is_action_just_pressed("2speed"):
		clear()
		speed2()
	if Input.is_action_just_pressed("3speed"):
		clear()
		speed3()
	if Input.is_action_just_pressed("pause"):
		clear()
		pause()
		#Engine.time_scale = currentSpeed

func clear():
	%"0speed".set_pressed_no_signal(false)
	%"1speed".set_pressed_no_signal(false)
	%"2speed".set_pressed_no_signal(false)
	%"3speed".set_pressed_no_signal(false)

func pause():
	clear()
	currentSpeed = 0
	get_tree().paused = true
	%"0speed".set_pressed_no_signal(true)

func speed1():
	currentSpeed = 1
	Engine.time_scale = currentSpeed
	get_tree().paused = false
	%"1speed".set_pressed_no_signal(true)

func speed2():
	currentSpeed = 2
	Engine.time_scale = currentSpeed
	get_tree().paused = false
	%"2speed".set_pressed_no_signal(true)

func speed3():
	currentSpeed = 3
	Engine.time_scale = currentSpeed
	get_tree().paused = false
	%"3speed".set_pressed_no_signal(true)

func _on_0_pressed() -> void: pause()
func _on_1_pressed() -> void: speed1()
func _on_2_pressed() -> void: speed2()
func _on_x_pressed() -> void: speed3()
