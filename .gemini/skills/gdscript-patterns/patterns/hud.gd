## HUD (Heads-Up Display)
## Attach to a CanvasLayer > Control node.
## Shows health bar, score, and other in-game info.
## Connects to the Events signal bus for updates.

extends Control

@onready var health_bar: ProgressBar = %HealthBar
@onready var score_label: Label = %ScoreLabel
@onready var notification_label: Label = %NotificationLabel

var _notification_tween: Tween = null


func _ready() -> void:
	# Connect to signal bus if it exists
	if has_node("/root/Events"):
		var events: Node = get_node("/root/Events")
		if events.has_signal("player_health_changed"):
			events.player_health_changed.connect(_on_health_changed)
		if events.has_signal("score_changed"):
			events.score_changed.connect(_on_score_changed)
		if events.has_signal("notification_requested"):
			events.notification_requested.connect(_on_notification)

	# Initialize
	notification_label.modulate.a = 0.0


func _on_health_changed(current: float, maximum: float) -> void:
	health_bar.max_value = maximum
	health_bar.value = current

	# Flash red when damaged
	var tween := create_tween()
	tween.tween_property(health_bar, "modulate", Color.RED, 0.1)
	tween.tween_property(health_bar, "modulate", Color.WHITE, 0.2)


func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score

	# Bounce animation
	var tween := create_tween()
	tween.tween_property(score_label, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(score_label, "scale", Vector2.ONE, 0.15)


func _on_notification(message: String, duration: float = 2.0) -> void:
	notification_label.text = message

	if _notification_tween:
		_notification_tween.kill()

	_notification_tween = create_tween()
	_notification_tween.tween_property(notification_label, "modulate:a", 1.0, 0.2)
	_notification_tween.tween_interval(duration)
	_notification_tween.tween_property(notification_label, "modulate:a", 0.0, 0.5)


func update_health(current: float, maximum: float) -> void:
	"""Direct setter if not using signal bus."""
	_on_health_changed(current, maximum)


func update_score(score: int) -> void:
	"""Direct setter if not using signal bus."""
	_on_score_changed(score)
