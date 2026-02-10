package main

import rl "vendor:raylib"

assets: Assets

Assets :: struct {
	font: rl.Font,
}

init_assets :: proc() {
	assets.font = rl.LoadFont("assets/font/dungeon-mode.ttf")
}

cleanup_assets :: proc() {
	rl.UnloadFont(assets.font)
}
