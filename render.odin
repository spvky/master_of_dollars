package main

import rl "vendor:raylib"

render :: proc() {
	rl.BeginDrawing()
	render_scene_to_texture()
	render_to_screen()
	rl.EndDrawing()
}

render_scene_to_texture :: proc() {
	rl.BeginTextureMode(assets.gameplay_texture)
	rl.BeginMode2D(world.camera)
	bg_color: rl.Color = {33, 38, 63, 255}
	rl.ClearBackground(bg_color)
	render_entities()
	rl.EndMode2D()
	rl.EndTextureMode()
}

render_ui_to_texture :: proc() {
	rl.BeginTextureMode(assets.ui_texture)
	rl.ClearBackground({0, 0, 0, 0})
	rl.EndTextureMode()
}

render_to_screen :: proc() {
	render_scene_to_texture()
	render_ui_to_texture()
	WINDOW_HEIGHT = rl.GetScreenWidth()
	WINDOW_HEIGHT = rl.GetScreenHeight()
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	source := rl.Rectangle {
		x      = 0,
		y      = f32(WINDOW_HEIGHT - SCREEN_HEIGHT),
		width  = f32(SCREEN_WIDTH),
		height = -f32(SCREEN_HEIGHT),
	}
	dest := rl.Rectangle {
		x      = 0,
		y      = 0,
		width  = f32(WINDOW_WIDTH),
		height = f32(WINDOW_HEIGHT),
	}
	origin := Vec2{0, 0}
	rotation: f32 = 0
	// Gameplay Texture
	rl.DrawTexturePro(assets.gameplay_texture.texture, source, dest, origin, rotation, rl.WHITE)
	// UI Texture
	rl.DrawTexturePro(assets.ui_texture.texture, source, dest, origin, rotation, rl.WHITE)
	rl.DrawFPS(0, 0)
	if ODIN_DEBUG {
	}
	rl.EndDrawing()
}
