package main

Vec2 :: [2]f32

Entity :: struct {
	position:     Vec2,
	velocity:     Vec2,
	traits:       bit_set[Entity_Trait;u64],
	state:        bit_set[Entity_State],
	rotation:     f32,
	prev_idx:     Idx,
	curr_idx:     Idx,
	child_idx:    Idx,
	parent_idx:   Idx,
	prev_sib_idx: Idx,
	next_sib_idx: Idx,
}

Entity_Trait :: enum u64 {
	Character,
	Auto_Pickup,
	Grabable,
	Pocketable,
	Throwable,
}

Entity_State :: enum u16 {
	Stunned,
	Burning,
	Wet,
}
