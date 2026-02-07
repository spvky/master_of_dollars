package main

import "core:fmt"
import "core:math"
import l "core:math/linalg"
import rl "vendor:raylib"

Rune_Wheel :: struct {
	runes:       [10]rune,
	rune_count:  int,
	using spell: Spell,
}

Spell :: struct {
	spell_indices: [10]int,
	spell_count:   int,
	spell_closed:  bool,
}

init_runes :: proc() {
	world.rune_wheel = Rune_Wheel {
		runes      = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'},
		rune_count = 10,
	}
}

draw_spell :: proc() {
	wheel := &world.rune_wheel
	spell_color := wheel.spell_closed ? rl.PURPLE : rl.YELLOW
	if wheel.spell_count > 1 {
		for i in 0 ..< wheel.spell_count - 1 {
			a := calculate_rune_position(wheel.spell_indices[i])
			b := calculate_rune_position(wheel.spell_indices[i + 1])
			rl.DrawLineEx(a, b, 10, spell_color)
		}
	}

	if wheel.spell_closed {
		a := calculate_rune_position(wheel.spell_indices[0])
		b := calculate_rune_position(wheel.spell_indices[wheel.spell_count - 1])
		rl.DrawLineEx(a, b, 10, spell_color)
	}
}

detect_rune_collision :: proc() {
	wheel := &world.rune_wheel
	pos := world.camera.cursor_pos
	for i in 0 ..< world.rune_wheel.rune_count {
		if !is_rune_in_spell(i) && !wheel.spell_closed {
			rune_pos := calculate_rune_position(i)
			if l.distance(pos, rune_pos) < 100 {
				wheel.spell_indices[wheel.spell_count] = i
				wheel.spell_count += 1
				fmt.printfln("%v was added to spell", wheel.runes[i])
			}
		}
	}
}

reset_spell :: proc() {
	if rl.IsMouseButtonPressed(.LEFT) {
		if !world.rune_wheel.spell_closed {
			if world.rune_wheel.spell_count > 1 {
				world.rune_wheel.spell_closed = true
			}
		} else {
			world.rune_wheel.spell_count = 0
			world.rune_wheel.spell_closed = false
		}
	}
}

is_rune_in_spell :: proc(index: int) -> (in_spell: bool) {
	if world.rune_wheel.spell_count > 0 {
		for i in 0 ..< world.rune_wheel.spell_count {
			if world.rune_wheel.spell_indices[i] == index {
				in_spell = true
				return
			}
		}
	}
	return
}

calculate_rune_position :: proc(index: int) -> Vec2 {
	wheel := &world.rune_wheel
	center := Vec2{f32(SCREEN_WIDTH) / 2, f32(SCREEN_HEIGHT) / 2}
	angle_diff := TAU / f32(wheel.rune_count)
	rune_theta := f32(index) * angle_diff
	radius := f32(SCREEN_HEIGHT) / 2
	return Vec2{math.sin(rune_theta) * radius, math.cos(rune_theta) * radius} + center //- Vec2{32, 32} \

}


draw_rune_wheel :: proc() {
	wheel := &world.rune_wheel
	center := Vec2{f32(SCREEN_WIDTH) / 2, f32(SCREEN_HEIGHT) / 2}
	angle_diff := TAU / f32(wheel.rune_count)
	start_radius := f32(SCREEN_HEIGHT) / 2.2
	end_radius := f32(SCREEN_HEIGHT) / 2
	rl.DrawCircleLinesV(center, f32(SCREEN_HEIGHT) / 2, rl.BLUE)
	rl.DrawCircleLinesV(center, f32(SCREEN_HEIGHT) / 2.2, rl.BLUE)

	for i in 0 ..< wheel.rune_count {
		theta := f32(i) * angle_diff + (PI / f32(wheel.rune_count))
		start := Vec2{math.sin(theta) * start_radius, math.cos(theta) * start_radius} + center
		end := Vec2{math.sin(theta) * end_radius, math.cos(theta) * end_radius} + center
		rune_pos := calculate_rune_position(i)

		rl.DrawTextCodepoint(
			assets.font,
			wheel.runes[i],
			rune_pos,
			32,
			is_rune_in_spell(i) ? rl.YELLOW : rl.WHITE,
		)

		rl.DrawLineEx(start, end, 4, rl.WHITE)
	}
}

handle_rune_wheel :: proc() {
	detect_rune_collision()
	reset_spell()
}
