dofile(minetest.get_modpath('laptop_extend_pack_2')..'/craftrecipes.lua')

laptop.register_hardware("laptop_extend_pack_2:fruit_type_1", {
	description = "Fruit Type 1",
	infotext = "Fruit Type 1",
	sequence = { "off", "on"},
	custom_theme = "Green Shell",
	custom_launcher = "cs-bos_launcher",
	os_version = "3.31",
	hw_capabilities = { "hdd", "floppy", "net", "liveboot" },
	node_defs = {
		["on"] = {
			hw_state = "power_on",
			light_source = 4,
			tiles = {
				"fruit_type_1_front_top.png",
				"fruit_type_1_cover.png",
				"fruit_type_1_cover.png",
				"fruit_type_1_cover.png",
				"fruit_type_1_back.png",
				"fruit_type_1_front_on.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.3125, -0.0625, 0.5, 0.5, 0.5}, -- monitor
					{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}, -- keyboard
				}
			}
		},
		["off"] = {
			hw_state = "power_off",
			tiles = {
				"fruit_type_1_front_top.png",
				"fruit_type_1_cover.png",
				"fruit_type_1_cover.png",
				"fruit_type_1_cover.png",
				"fruit_type_1_back.png",
				"fruit_type_1_front_off.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.3125, -0.0625, 0.5, 0.5, 0.5}, -- monitor
					{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}, -- keyboard
				}
			}
		}
	}
})

laptop.register_hardware("laptop_extend_pack_2:war8000", {
	description = "WAR 8000",
	infotext = "WAR 8000",
	sequence = { "off", "on"},
	custom_theme = "Green Shell",
	custom_launcher = "cs-bos_launcher",
	os_version = "3.31",
	hw_capabilities = { "hdd", "floppy", "net", "liveboot" },
	node_defs = {
		["on"] = {
			hw_state = "power_on",
			light_source = 4,
			tiles = {
				"war_8000_top.png",
				"war_8000_cover.png",
				"war_8000_cover.png",
				"war_8000_cover.png",
				"war_8000_back.png",
				"war_8000_on.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, 0, 0.5, 0.0625, 0.5}, -- system
					{-0.5, -0.5, -0.5, 0.5, -0.375, -0.0625}, -- keyboard
				}
			}
		},
		["off"] = {
			hw_state = "power_off",
			tiles = {
				"war_8000_top.png",
				"war_8000_cover.png",
				"war_8000_cover.png",
				"war_8000_cover.png",
				"war_8000_back.png",
				"war_8000_off.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, 0, 0.5, 0.0625, 0.5}, -- system
					{-0.5, -0.5, -0.5, 0.5, -0.375, -0.0625}, -- keyboard
				}
			}
		}
	}
})

laptop.register_hardware("laptop_extend_pack_2:gamingbox_90", {
	description = "GamingBOX 90",
	infotext = "GamingBOX 90",
	sequence = { "off", "on"},
	os_version = '5.02',
	custom_theme = "Boing!",
	hw_capabilities = { "hdd", "floppy", "liveboot" },
	node_defs = {
		["on"] = {
			hw_state = "power_on",
			light_source = 4,
			tiles = {
				"gamingbox90_top.png",
				"gamingbox90_cover.png",
				"gamingbox90_cover.png",
				"gamingbox90_cover.png",
				"gamingbox90_back.png",
				"gamingbox90_on.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.5}, -- system
					{-0.5, -0.5, -0.5, -0.0625, -0.375, -0.25}, -- joypad_1
					{0.0625, -0.5, -0.5, 0.5, -0.375, -0.25}, -- joypad_2
				}
			}
		},
		["off"] = {
			hw_state = "power_off",
			tiles = {
				"gamingbox90_top.png",
				"gamingbox90_cover.png",
				"gamingbox90_cover.png",
				"gamingbox90_cover.png",
				"gamingbox90_back.png",
				"gamingbox90_off.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.5}, -- system
					{-0.5, -0.5, -0.5, -0.0625, -0.375, -0.25}, -- joypad_1
					{0.0625, -0.5, -0.5, 0.5, -0.375, -0.25}, -- joypad_2
				}
			}
		}
	}
})

laptop.register_hardware("laptop_extend_pack_2:bell_sprint", {
	description = "Bell Sprint",
	infotext = "Bell Sprint",
	sequence = { "off", "on"},
	custom_theme = "Snow Pines",
	node_defs = {
		["on"] = {
			hw_state = "power_on",
			light_source = 4,
			tiles = {
				"sprint_top.png",
				"sprint_cover.png",
				"sprint_cover.png",
				"sprint_cover.png",
				"sprint_back.png",
				"sprint_front_on.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.3125, 0, 0.5, 0.5, 0.125}, -- system
					{-0.125, 0, 0.125, 0.0625, 0.1875, 0.3125}, -- AIO_holder_1
					{-0.125, -0.5, 0.25, 0.0625, 0.1875, 0.3125}, -- AIO_holder_2
					{-0.5, -0.5, 0, 0.5, -0.4375, 0.4375}, -- AIO_holder_3
					{-0.5, -0.5, -0.4375, 0.25, -0.4375, -0.125}, -- keyboard
					{0.3125, -0.5, -0.4375, 0.5, -0.4375, -0.125}, -- mouse
				}
			}
		},
		["off"] = {
			hw_state = "power_off",
			tiles = {
				"sprint_top.png",
				"sprint_cover.png",
				"sprint_cover.png",
				"sprint_cover.png",
				"sprint_back.png",
				"sprint_front_off.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.3125, 0, 0.5, 0.5, 0.125}, -- system
					{-0.125, 0, 0.125, 0.0625, 0.1875, 0.3125}, -- AIO_holder_1
					{-0.125, -0.5, 0.25, 0.0625, 0.1875, 0.3125}, -- AIO_holder_2
					{-0.5, -0.5, 0, 0.5, -0.4375, 0.4375}, -- AIO_holder_3
					{-0.5, -0.5, -0.4375, 0.25, -0.4375, -0.125}, -- keyboard
					{0.3125, -0.5, -0.4375, 0.5, -0.4375, -0.125}, -- mouse
				}
			}
		}
	}
})

laptop.register_theme("Sunset", {
	desktop_background = "sunset_wallpaper.png",
	app_background = "sunset_app_background.png",
	major_button = "sunset_major_button.png",
	major_textcolor = "#FFFFFF",
	minor_button = "sunset_minor_button.png",
	minor_textcolor = "#FFFFFF",
	back_button = "sunset_back_button.png",	
	back_textcolor = "#000000",
	exit_button = "sunset_exit_button.png",
	exit_textcolor = "#000000",
	contrast_background = "sunset_major_button.png",
	taskbar_clock_position_and_size = "11,-.31;4,0.7",
	table_bgcolor="#FFFFFF",
	table_highlight_bgcolor='#888888',
	muted_textcolor = "#444444",
	table_border = 'true',
	os_min_version = '7.00',
})
