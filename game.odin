package main

import "core:log"
import rl "vendor:raylib"

Vec2 :: [2]f32

game_init :: proc() {
	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Kick man")
	init_world()
	init_assets()
}

game_update :: proc() {
	render()
}

game_cleanup :: proc() {
	cleanup_assets()
}
