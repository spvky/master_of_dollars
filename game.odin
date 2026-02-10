package main

import "core:log"
import rl "vendor:raylib"

game_init :: proc() {
	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Kick man")
}

game_update :: proc() {
}

game_cleanup :: proc() {
	cleanup_assets()
}
