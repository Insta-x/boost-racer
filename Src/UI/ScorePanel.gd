extends TextureRect

onready var RankingLabel := $HBoxContainer/RankingLabel
onready var NameLabel := $HBoxContainer/NameLabel
onready var TimeLabel := $HBoxContainer/TimeLabel

var ranking := "1"
var racerName := "name"
var time := "00:00.000"

func _ready():
	RankingLabel.text = ranking
	NameLabel.text = racerName
	TimeLabel.text = time
