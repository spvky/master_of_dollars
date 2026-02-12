package main

Idx :: distinct u16

Entity :: struct {
	pos:          Vec2,
	velo:         Vec2,
	m_delta:      Vec2,
	rotation:     f32,
	traits:       bit_set[Entity_Trait;u64],
	state:        bit_set[Entity_State],
	kind:         Entity_Kind,
	allignment:   Entity_Allignment,
	target:       Idx,
	prev_idx:     Idx,
	curr_idx:     Idx,
	parent_idx:   Idx,
	child_idx:    Idx,
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
	Dead,
	Stunned,
	Burning,
	Wet,
}

Entity_Allignment :: enum {
	Neutral,
	Friendly,
	Hostile,
}

Entity_Kind :: enum {
	Player,
	NPC,
	Object,
}
