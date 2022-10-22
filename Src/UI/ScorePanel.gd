extends ColorRect

onready var RankingLabel := $Polygon2D/Polygon2D2/HBoxContainer/RankingLabel
onready var NameLabel := $Polygon2D/Polygon2D2/HBoxContainer/NameLabel
onready var TimeLabel := $Polygon2D/Polygon2D2/HBoxContainer/TimeLabel

var ranking := "1"
var racerName := ""
var time := "--:--.---"

func _ready():
	RankingLabel.text = ranking
	NameLabel.text = racerName
	TimeLabel.text = time
