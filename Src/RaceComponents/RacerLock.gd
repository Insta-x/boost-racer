extends Polygon2D


func _ready() -> void:
	GlobalSignal.connect("game_start", self, "hide")
