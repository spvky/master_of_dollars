package main

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1920, 1080, "Master of Dollars")
	defer rl.CloseWindow()

	game_init()
	for !rl.WindowShouldClose() {
		game_update()
		game_render()
		free_all(context.temp_allocator)
	}
}
