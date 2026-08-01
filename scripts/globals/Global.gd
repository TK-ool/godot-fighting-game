extends Node

#Player Farbe für Outlines wird derzeit nur direkt in dem bullet script benutzt
var P1_Color: Color = Color(211, 0.0, 203, 1.0)
var P2_Color: Color = Color(0.0, 0.0, 203, 1.0)

#setzt standartskins hier
var P1_Skin: Texture2D = preload("uid://b11n0r23f36ry")
var P2_Skin: Texture2D = preload("uid://b11n0r23f36ry")

#Punkte zum gewinnen
var Win_points_amount := 3

#Gesamt Pubnktzahl
var Score_P1 := 0
var Score_P2 := 0

#Punkte innerhalb der Rundew
var Round_points_P1 := 0
var Round_points_P2 := 0

var menu = "uid://bi2nmmbvx00ww"

var all_level = [
	"uid://dlr1yhmdr3wkh",
	"uid://cnieqsgkay365"
]

func load_menu():
	Score_reset()
	round_points_reset()
	queue_free_bullets()
	load(menu)
	get_tree().change_scene_to_file(menu)

func random_level():
	round_points_reset()
	queue_free_bullets()
	var x = randi() % all_level.size()
	var selected_scene = all_level[x]
	load(selected_scene)
	get_tree().change_scene_to_file(selected_scene)
	
func round_points_reset():
	Round_points_P1 = 0
	Round_points_P2 = 0
	
func Score_reset():
	Score_P1 = 0
	Score_P2 = 0
	
func queue_free_bullets():
	var rest_bullets = get_tree().get_nodes_in_group("bullet")
	for b in rest_bullets:
		b.queue_free()
