extends Node2D

var round_ending_var:= false

var round_start_timer : float = 3.0
var round_started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_round()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Countdown(delta)

func start_round():
	get_tree().paused = true
	await ScreenTransition.on_normal_transistion_finished
	round_started = true


	#Engine.set_time_scale(0.3)

func Countdown(delta):
	if round_started == true:
		if round_start_timer >= 0:
			round_start_timer -= delta
	if round_start_timer <= 1:
		get_tree().paused = false
		
		
func round_ending():
	ScreenTransition.transition()
	await ScreenTransition.on_transition_finished
	if round_ending_var == !true: # damit bei doublekill nicht die scene entladen und dann versucht wird zu laden die nicht da ist
		round_ending_var = true
		if Global.Score_P1 >= Global.Win_points_amount or Global.Score_P2 >= Global.Win_points_amount:
			Global.load_menu() # get to main_menu
			
		elif Global.Round_points_P1 >= 2 or Global.Round_points_P2 >= 2:
			Global.random_level() # winner decided
		else:
			Global.queue_free_bullets()
			get_tree().reload_current_scene() #round ending
			
		
	

	
