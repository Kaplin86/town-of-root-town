extends Node

var currentSpeed = 1

func _ready() -> void:
	Engine.time_scale = currentSpeed

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1speed"):
		currentSpeed = 1
		Engine.time_scale = currentSpeed
		get_tree().paused = false
	if Input.is_action_just_pressed("2speed"):
		currentSpeed = 2
		Engine.time_scale = currentSpeed
		get_tree().paused = false
	if Input.is_action_just_pressed("3speed"):
		currentSpeed = 3
		Engine.time_scale = currentSpeed
		get_tree().paused = false
	if Input.is_action_just_pressed("pause"):
		pause()
		#Engine.time_scale = currentSpeed

func pause():
	currentSpeed = 0
	get_tree().paused = true
