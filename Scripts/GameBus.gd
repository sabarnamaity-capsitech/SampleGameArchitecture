extends Node
# Central signal hub. Kono script direct reference chara ei signal gula
# emit/listen korte pare.

signal level_started(level_number: int)
signal level_won(level_number: int, time_taken: float)
signal game_paused(level_number: int)
signal level_lost(level_number: int)
signal level_restarted(level_number: int)

signal panel_open_requested(panel_name: String)
signal panel_close_requested(panel_name: String)

signal save_data_changed()
signal settings_changed(key: String, value: Variant)
signal level_selected(level_number: int)
signal level_completed(level_number: int)