extends ColorRect

onready var RankingLabel := $Polygon2D/Polygon2D2/HBoxContainer/RankingLabel
onready var NameLabel := $Polygon2D/Polygon2D2/HBoxContainer/NameLabel
onready var TimeLabel := $Polygon2D/Polygon2D2/HBoxContainer/TimeLabel

var ranking := ""
var racerName := ""
var time := "--:--.---"

func _ready() -> void:
	RankingLabel.text = ranking
	NameLabel.text = racerName
	TimeLabel.text = time

func set_label_ranking(var value : int) -> void:
	RankingLabel.text = String(value)


func set_label_name(var value : String) -> void:
	NameLabel.text = value

func set_label_time(var value : String) -> void:
	TimeLabel.text = value


