minetest.register_craft({
	output = 'laptop_extend_pack_2:fruit_type_1_off',
	recipe = {
	{'', 'laptop:crt_green', '', },
	{'laptop:HDD', 'laptop:motherboard', 'laptop:cpu_c6', },
	{'', 'laptop:case', 'laptop:psu', },
	}
})

minetest.register_craft({
	output = 'laptop_extend_pack_2:war8000_off',
	recipe = {
	{'', 'laptop:crt_green', 'dye:dark_grey', },
	{'laptop:case', '', 'laptop:psu', },
	{'laptop:HDD', 'laptop:motherboard', 'laptop:cpu_c6', },
	}
})

minetest.register_craft({
	output = 'laptop_extend_pack_2:gamingbox_90_off',
	recipe = {
		{'dye:dark_grey', 'laptop:crt', 'dye:dark_grey', },
		{'laptop:HDD', 'laptop:motherboard', 'laptop:psu', },
		{'laptop:cpu_65536', 'laptop:case', '', },
	}
})

minetest.register_craft({
	output = 'laptop_extend_pack_2:bell_sprint_off',
	recipe = {
		{'dye:dark_grey', 'laptop:lcd', 'dye:dark_grey', },
		{'laptop:gpu', 'laptop:motherboard', 'laptop:HDD', },
		{'laptop:cpu_jetcore', 'laptop:case', 'laptop:psu', },
	}
})