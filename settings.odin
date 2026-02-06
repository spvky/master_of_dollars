package main

Gameplay_Settings :: struct {
	look_sensitivity:    f32,
	lock_on_sensitivity: f32,
}

settings: Gameplay_Settings

init_settings :: proc() {
	settings.look_sensitivity = 0.75
	settings.lock_on_sensitivity = 0.75
}

look_speed :: proc() -> f32 {
	return settings.look_sensitivity * (TAU * 10)
}

lockon_sensitivity :: proc() -> f32 {
	return settings.look_sensitivity * f32(SCREEN_WIDTH) * 2
}
