## Audio Manager (Autoload/Singleton)
## Add this as an autoload named "AudioManager" in project settings.
## Plays SFX and music with volume control and cross-fading.

extends Node

@export var sfx_bus: StringName = &"SFX"
@export var music_bus: StringName = &"Music"
@export var max_sfx_players: int = 16

var _music_player: AudioStreamPlayer
var _sfx_pool: Array[AudioStreamPlayer] = []
var _current_sfx_index: int = 0
var _music_tween: Tween = null


func _ready() -> void:
	# Create music player
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = music_bus
	add_child(_music_player)

	# Create SFX pool
	for i in max_sfx_players:
		var player := AudioStreamPlayer.new()
		player.bus = sfx_bus
		add_child(player)
		_sfx_pool.append(player)


func play_sfx(stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if not stream:
		push_warning("AudioManager: Tried to play null SFX stream.")
		return

	var player: AudioStreamPlayer = _sfx_pool[_current_sfx_index]
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	player.play()

	_current_sfx_index = (_current_sfx_index + 1) % max_sfx_players


func play_sfx_at(stream: AudioStream, position: Vector2, volume_db: float = 0.0) -> void:
	"""Play a positional SFX in 2D. Creates a temporary AudioStreamPlayer2D."""
	if not stream:
		return
	var player := AudioStreamPlayer2D.new()
	player.stream = stream
	player.volume_db = volume_db
	player.bus = sfx_bus
	player.position = position
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)


func play_sfx_random_pitch(stream: AudioStream, min_pitch: float = 0.9, max_pitch: float = 1.1) -> void:
	"""Play SFX with a randomized pitch for variety."""
	play_sfx(stream, 0.0, randf_range(min_pitch, max_pitch))


func play_music(stream: AudioStream, fade_duration: float = 1.0, volume_db: float = 0.0) -> void:
	if not stream:
		return

	if _music_player.stream == stream and _music_player.playing:
		return  # Already playing this track

	if _music_tween:
		_music_tween.kill()

	if _music_player.playing and fade_duration > 0:
		# Cross-fade
		_music_tween = create_tween()
		_music_tween.tween_property(_music_player, "volume_db", -40.0, fade_duration * 0.5)
		await _music_tween.finished

	_music_player.stream = stream
	_music_player.volume_db = -40.0 if fade_duration > 0 else volume_db
	_music_player.play()

	if fade_duration > 0:
		_music_tween = create_tween()
		_music_tween.tween_property(_music_player, "volume_db", volume_db, fade_duration * 0.5)


func stop_music(fade_duration: float = 1.0) -> void:
	if not _music_player.playing:
		return

	if _music_tween:
		_music_tween.kill()

	if fade_duration > 0:
		_music_tween = create_tween()
		_music_tween.tween_property(_music_player, "volume_db", -40.0, fade_duration)
		await _music_tween.finished

	_music_player.stop()


func set_sfx_volume(volume_db: float) -> void:
	var bus_idx: int = AudioServer.get_bus_index(sfx_bus)
	if bus_idx >= 0:
		AudioServer.set_bus_volume_db(bus_idx, volume_db)


func set_music_volume(volume_db: float) -> void:
	var bus_idx: int = AudioServer.get_bus_index(music_bus)
	if bus_idx >= 0:
		AudioServer.set_bus_volume_db(bus_idx, volume_db)
