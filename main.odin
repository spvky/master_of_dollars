package main

import rl "vendor:raylib"

SCREEN_WIDTH :: 1920
SCREEN_HEIGHT :: 1080

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Master of Dollars")
	rl.DisableCursor()
	defer rl.CloseWindow()

	game_init()
	for !rl.WindowShouldClose() {
		game_update()
		game_render()
		free_all(context.temp_allocator)
	}
}
