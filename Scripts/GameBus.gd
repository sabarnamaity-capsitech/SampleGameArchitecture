extends Node
# Central signal hub. Kono script direct reference chara ei signal gula
# emit/listen korte pare.

signal level_started(level_id: int)
signal level_won(level_id: int, time_taken: float)
signal level_lost(level_id: int)
signal level_restarted(level_id: int)

signal panel_open_requested(panel_name: String)
signal panel_close_requested(panel_name: String)

signal save_data_changed()
signal settings_changed(key: String, value: Variant)