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


func set_label_time(var value : int) -> void:
	var milisecond := value%1000
	var second := (value/1000)%60
	var minute := (value/60000)%60
	TimeLabel.text = "%02d:%02d.%03d" % [minute, second, milisecond]


