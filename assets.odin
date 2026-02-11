package main

import rl "vendor:raylib"

assets: Assets

Assets :: struct {
	font:             rl.Font,
	gameplay_texture: rl.RenderTexture,
	ui_texture:       rl.RenderTexture,
}

init_assets :: proc() {
	assets.font = rl.LoadFont("assets/font/dungeon-mode.ttf")
	assets.gameplay_texture = rl.LoadRenderTexture(WINDOW_WIDTH, WINDOW_HEIGHT)
	assets.ui_texture = rl.LoadRenderTexture(WINDOW_WIDTH, WINDOW_HEIGHT)
}

cleanup_assets :: proc() {
	rl.UnloadFont(assets.font)
	rl.UnloadRenderTexture(assets.gameplay_texture)
	rl.UnloadRenderTexture(assets.ui_texture)
}
