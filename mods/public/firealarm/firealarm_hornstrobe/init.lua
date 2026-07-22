minetest.register_node(":firealarm:hornstrobe_off",{
	description = "Fire Alarm",
	groups = { oddly_breakable_by_hand = 1 },
	tiles = {
		"firealarm_hornstrobe_top.png",
		"firealarm_hornstrobe_top.png",
		"firealarm_hornstrobe_side.png",
		"firealarm_hornstrobe_side.png",
		"firealarm_hornstrobe_back.png",
		"firealarm_hornstrobe_front_off.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.15,-0.02,0.4,0.18,0.37,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("notification",pos,{strobeActive = false,hornActive = false})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("notification",pos,nil)
	end,
})

local hornstrobeOnFrontTexture = "[combine:32x320"..
                                 ":0,0=firealarm_hornstrobe_front_on.png"..
                                 ":0,32=firealarm_hornstrobe_front_off.png"..
                                 ":0,64=firealarm_hornstrobe_front_off.png"..
                                 ":0,96=firealarm_hornstrobe_front_off.png"..
                                 ":0,128=firealarm_hornstrobe_front_off.png"..
                                 ":0,160=firealarm_hornstrobe_front_off.png"..
                                 ":0,192=firealarm_hornstrobe_front_off.png"..
                                 ":0,224=firealarm_hornstrobe_front_off.png"..
                                 ":0,256=firealarm_hornstrobe_front_off.png"..
                                 ":0,288=firealarm_hornstrobe_front_off.png"

minetest.register_node(":firealarm:hornstrobe_on",{
	drop = "firealarm:hornstrobe_off",
	description = "Fire Alarm (wait, why do you have this?)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
	tiles = {
		"firealarm_hornstrobe_top.png",
		"firealarm_hornstrobe_top.png",
		"firealarm_hornstrobe_side.png",
		"firealarm_hornstrobe_side.png",
		"firealarm_hornstrobe_back.png",
		{
			name = hornstrobeOnFrontTexture,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 1,
			},
		}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	use_texture_alpha = "blend",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,0.4,0.5,0.5,0.401},
			{-0.15,-0.02,0.4,0.18,0.37,0.5},
		},
	},
})

minetest.register_node(":firealarm:remotestrobe_off",{
	description = "Fire Alarm (Lights only)",
	groups = { oddly_breakable_by_hand = 1 },
	tiles = {
		"firealarm_hornstrobe_top.png",
		"firealarm_hornstrobe_top.png",
		"firealarm_hornstrobe_side.png",
		"firealarm_hornstrobe_side.png",
		"firealarm_hornstrobe_back.png",
		"firealarm_hornstrobe_remotestrobe_front_off.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.15,-0.02,0.4,0.18,0.37,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("notification",pos,{strobeActive = false,hornActive = false})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("notification",pos,nil)
	end,
})

local remoteStrobeOnFrontTexture = "[combine:32x320"..
                                 ":0,0=firealarm_hornstrobe_front_on.png"..
                                 ":0,32=firealarm_hornstrobe_remotestrobe_front_off.png"..
                                 ":0,64=firealarm_hornstrobe_remotestrobe_front_off.png"..
                                 ":0,96=firealarm_hornstrobe_remotestrobe_front_off.png"..
                                 ":0,128=firealarm_hornstrobe_remotestrobe_front_off.png"..
                                 ":0,160=firealarm_hornstrobe_remotestrobe_front_off.png"..
                                 ":0,192=firealarm_hornstrobe_remotestrobe_front_off.png"..
                                 ":0,224=firealarm_hornstrobe_remotestrobe_front_off.png"..
                                 ":0,256=firealarm_hornstrobe_remotestrobe_front_off.png"..
                                 ":0,288=firealarm_hornstrobe_remotestrobe_front_off.png"

minetest.register_node(":firealarm:remotestrobe_on",{
	drop = "firealarm:remotestrobe_off",
	description = "Fire Alarm (Lights only) (on state - you hacker you!)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
	tiles = {
		"firealarm_hornstrobe_top.png",
		"firealarm_hornstrobe_top.png",
		"firealarm_hornstrobe_side.png",
		"firealarm_hornstrobe_side.png",
		"firealarm_hornstrobe_back.png",
		{
			name = remoteStrobeOnFrontTexture,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 1,
			},
		}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	use_texture_alpha = "blend",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,0.4,0.5,0.5,0.401},
			{-0.15,-0.02,0.4,0.18,0.37,0.5},
		},
	},
})

minetest.register_node(":firealarm:hornstrobe_old_off",{
	description = "Buzzer Fire Alarm",
	groups = { oddly_breakable_by_hand = 1 },
	tiles = {
		"firealarm_hornstrobe_top.png",
		"firealarm_hornstrobe_top.png",
		"firealarm_hornstrobe_side.png",
		"firealarm_hornstrobe_side.png",
		"firealarm_hornstrobe_back.png",
		"firealarm_hornstrobe_old_front_off.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.15,-0.02,0.4,0.18,0.37,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("notification",pos,{strobeActive = false,hornActive = false})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("notification",pos,nil)
	end,
})

local oldHornStrobeOnFrontTexture = "[combine:64x128"..
                                 ":0,0=firealarm_hornstrobe_old_front_on.png"..
                                 ":0,64=firealarm_hornstrobe_old_front_off.png"

minetest.register_node(":firealarm:hornstrobe_old_on",{
	drop = "firealarm:hornstrobe_old_off",
	description = "Buzzer Fire Alarm (on state - you hacker you!)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
	tiles = {
		"firealarm_hornstrobe_top.png",
		"firealarm_hornstrobe_top.png",
		"firealarm_hornstrobe_side.png",
		"firealarm_hornstrobe_side.png",
		"firealarm_hornstrobe_back.png",
		{
			name = oldHornStrobeOnFrontTexture,
			animation = {
				type = "vertical_frames",
				aspect_w = 64,
				aspect_h = 64,
				length = 0.6,
			},
		}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.15,-0.02,0.4,0.18,0.37,0.5},
		},
	},
})

minetest.register_node(":firealarm:hornstrobe_german_red_off",{
	description = "German Fire Alarm (red)",
	groups = { oddly_breakable_by_hand = 1 },
        tiles = {
                "firealarm_hornstrobe_german_side_red.png",
                "firealarm_hornstrobe_german_side_red.png",
                "firealarm_hornstrobe_german_side_red.png",
                "firealarm_hornstrobe_german_side_red.png",
                "firealarm_hornstrobe_german_side_red.png",
                "firealarm_hornstrobe_german_front_red.png",
        },
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                        {-0.175,-0.175,0.375,0.175,0.175,0.5}, --box

                        {-0.175,-0.175,0.25,-0.159090909091,0.175,0.375}, --wall left
                        {0.159090909091,-0.175,0.25,0.175,0.175,0.375}, --wall right
                        {-0.175,-0.175,0.25,0.175,-0.159090909091,0.375}, --wall down
                        {-0.175,0.159090909091,0.25,0.175,0.175,0.375}, --wall up

                        {-0.175,-0.03125,0.25,0.175,0.03125,0.3}, --connect h
                        {-0.03125,-0.175,0.25,0.03125,0.175,0.3}, --connect v

                        {-0.1,-0.1,0.2,0.1,0.1,0.375}, --lamp
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("notification",pos,{strobeActive = false,hornActive = false})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("notification",pos,nil)
	end,
})

local germanRedHornstrobeOnFrontTexture = "[combine:92x920"..
                                      ":0,0=firealarm_hornstrobe_german_front_on.png"..
                                      ":0,92=firealarm_hornstrobe_german_front_red.png"..
                                      ":0,184=firealarm_hornstrobe_german_front_red.png"..
                                      ":0,276=firealarm_hornstrobe_german_front_red.png"..
                                      ":0,368=firealarm_hornstrobe_german_front_red.png"..
                                      ":0,460=firealarm_hornstrobe_german_front_red.png"..
                                      ":0,552=firealarm_hornstrobe_german_front_red.png"..
                                      ":0,736=firealarm_hornstrobe_german_front_red.png"..
                                      ":0,828=firealarm_hornstrobe_german_front_red.png"

minetest.register_node(":firealarm:hornstrobe_german_red_on",{
	drop = "firealarm:hornstrobe_german_red_off",
	description = "German Fire Alarm (red) (wait, why do you have this?)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
        tiles = {
                "firealarm_hornstrobe_german_side_red.png",
                "firealarm_hornstrobe_german_side_red.png",
                "firealarm_hornstrobe_german_side_red.png",
                "firealarm_hornstrobe_german_side_red.png",
                "firealarm_hornstrobe_german_side_red.png",
                {
                	name = germanRedHornstrobeOnFrontTexture,
                        animation = {
                                type = "vertical_frames",
                                aspect_w = 92,
                                aspect_h = 92,
                                length = 1,
                        },
                },
        },
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	use_texture_alpha = "blend",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                        {-0.175,-0.175,0.375,0.175,0.175,0.5}, --box

                        {-0.175,-0.175,0.25,-0.159090909091,0.175,0.375}, --wall left
                        {0.159090909091,-0.175,0.25,0.175,0.175,0.375}, --wall right
                        {-0.175,-0.175,0.25,0.175,-0.159090909091,0.375}, --wall down
                        {-0.175,0.159090909091,0.25,0.175,0.175,0.375}, --wall up

                        {-0.175,-0.03125,0.25,0.175,0.03125,0.3}, --connect h
                        {-0.03125,-0.175,0.25,0.03125,0.175,0.3}, --connect v

                        {-0.1,-0.1,0.2,0.1,0.1,0.375}, --lamp
		},
	},
})

minetest.register_node(":firealarm:hornstrobe_german_white_off",{
	description = "German Fire Alarm (white)",
	groups = { oddly_breakable_by_hand = 1 },
        tiles = {
                "firealarm_hornstrobe_german_side_white.png",
                "firealarm_hornstrobe_german_side_white.png",
                "firealarm_hornstrobe_german_side_white.png",
                "firealarm_hornstrobe_german_side_white.png",
                "firealarm_hornstrobe_german_side_white.png",
                "firealarm_hornstrobe_german_front_white.png",
        },
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                        {-0.175,-0.175,0.375,0.175,0.175,0.5}, --box

                        {-0.175,-0.175,0.25,-0.159090909091,0.175,0.375}, --wall left
                        {0.159090909091,-0.175,0.25,0.175,0.175,0.375}, --wall right
                        {-0.175,-0.175,0.25,0.175,-0.159090909091,0.375}, --wall down
                        {-0.175,0.159090909091,0.25,0.175,0.175,0.375}, --wall up

                        {-0.175,-0.03125,0.25,0.175,0.03125,0.3}, --connect h
                        {-0.03125,-0.175,0.25,0.03125,0.175,0.3}, --connect v

                        {-0.1,-0.1,0.2,0.1,0.1,0.375}, --lamp
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("notification",pos,{strobeActive = false,hornActive = false})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("notification",pos,nil)
	end,
})

local germanWhiteHornstrobeOnFrontTexture = "[combine:92x920"..
                                      ":0,0=firealarm_hornstrobe_german_front_on.png"..
                                      ":0,92=firealarm_hornstrobe_german_front_white.png"..
                                      ":0,184=firealarm_hornstrobe_german_front_white.png"..
                                      ":0,276=firealarm_hornstrobe_german_front_white.png"..
                                      ":0,368=firealarm_hornstrobe_german_front_white.png"..
                                      ":0,460=firealarm_hornstrobe_german_front_white.png"..
                                      ":0,552=firealarm_hornstrobe_german_front_white.png"..
                                      ":0,736=firealarm_hornstrobe_german_front_white.png"..
                                      ":0,828=firealarm_hornstrobe_german_front_white.png"

minetest.register_node(":firealarm:hornstrobe_german_white_on",{
	drop = "firealarm:hornstrobe_german_white_off",
	description = "German Fire Alarm (white) (wait, why do you have this?)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
        tiles = {
                "firealarm_hornstrobe_german_side_white.png",
                "firealarm_hornstrobe_german_side_white.png",
                "firealarm_hornstrobe_german_side_white.png",
                "firealarm_hornstrobe_german_side_white.png",
                "firealarm_hornstrobe_german_side_white.png",
                {
                	name = germanWhiteHornstrobeOnFrontTexture,
                        animation = {
                                type = "vertical_frames",
                                aspect_w = 92,
                                aspect_h = 92,
                                length = 1,
                        },
                },
        },
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	use_texture_alpha = "blend",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                        {-0.175,-0.175,0.375,0.175,0.175,0.5}, --box

                        {-0.175,-0.175,0.25,-0.159090909091,0.175,0.375}, --wall left
                        {0.159090909091,-0.175,0.25,0.175,0.175,0.375}, --wall right
                        {-0.175,-0.175,0.25,0.175,-0.159090909091,0.375}, --wall down
                        {-0.175,0.159090909091,0.25,0.175,0.175,0.375}, --wall up

                        {-0.175,-0.03125,0.25,0.175,0.03125,0.3}, --connect h
                        {-0.03125,-0.175,0.25,0.03125,0.175,0.3}, --connect v

                        {-0.1,-0.1,0.2,0.1,0.1,0.375}, --lamp
		},
	},
})

minetest.register_node(":firealarm:hornstrobe_uk_red_off",{
	description = "UK Fire Alarm (red)",
	groups = { oddly_breakable_by_hand = 1 },
        tiles = {
                "firealarm_hornstrobe_uk_side_red.png",
                "firealarm_hornstrobe_uk_side_red.png",
                "firealarm_hornstrobe_uk_side_red.png",
                "firealarm_hornstrobe_uk_side_red.png",
                "firealarm_hornstrobe_uk_side_red.png",
                "firealarm_hornstrobe_uk_front_red.png",
        },
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                        {-0.175,-0.175,0.375,0.175,0.175,0.5}, --box

                        {-0.175,-0.175,0.25,-0.159090909091,0.175,0.375}, --wall left
                        {0.159090909091,-0.175,0.25,0.175,0.175,0.375}, --wall right
                        {-0.175,-0.175,0.25,0.175,-0.159090909091,0.375}, --wall down
                        {-0.175,0.159090909091,0.25,0.175,0.175,0.375}, --wall up

                        {-0.175,-0.03125,0.25,0.175,0.03125,0.3}, --connect h
                        {-0.03125,-0.175,0.25,0.03125,0.175,0.3}, --connect v

                        {-0.1,-0.1,0.2,0.1,0.1,0.375}, --lamp
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("notification",pos,{strobeActive = false,hornActive = false})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("notification",pos,nil)
	end,
})

local ukRedHornstrobeOnFrontTexture = "[combine:92x920"..
                                      ":0,0=firealarm_hornstrobe_uk_front_on.png"..
                                      ":0,92=firealarm_hornstrobe_uk_front_red.png"..
                                      ":0,184=firealarm_hornstrobe_uk_front_red.png"..
                                      ":0,276=firealarm_hornstrobe_uk_front_red.png"..
                                      ":0,368=firealarm_hornstrobe_uk_front_red.png"..
                                      ":0,460=firealarm_hornstrobe_uk_front_red.png"..
                                      ":0,552=firealarm_hornstrobe_uk_front_red.png"..
                                      ":0,644=firealarm_hornstrobe_uk_front_red.png"..
                                      ":0,736=firealarm_hornstrobe_uk_front_red.png"..
                                      ":0,828=firealarm_hornstrobe_uk_front_red.png"

minetest.register_node(":firealarm:hornstrobe_uk_red_on",{
	drop = "firealarm:hornstrobe_uk_red_off",
	description = "UK Fire Alarm (red) (wait, why do you have this?)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
        tiles = {
                "firealarm_hornstrobe_uk_side_red.png",
                "firealarm_hornstrobe_uk_side_red.png",
                "firealarm_hornstrobe_uk_side_red.png",
                "firealarm_hornstrobe_uk_side_red.png",
                "firealarm_hornstrobe_uk_side_red.png",
                {
                	name = ukRedHornstrobeOnFrontTexture,
                        animation = {
                                type = "vertical_frames",
                                aspect_w = 92,
                                aspect_h = 92,
                                length = 1,
                        },
                },
        },
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	use_texture_alpha = "blend",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                        {-0.175,-0.175,0.375,0.175,0.175,0.5}, --box

                        {-0.175,-0.175,0.25,-0.159090909091,0.175,0.375}, --wall left
                        {0.159090909091,-0.175,0.25,0.175,0.175,0.375}, --wall right
                        {-0.175,-0.175,0.25,0.175,-0.159090909091,0.375}, --wall down
                        {-0.175,0.159090909091,0.25,0.175,0.175,0.375}, --wall up

                        {-0.175,-0.03125,0.25,0.175,0.03125,0.3}, --connect h
                        {-0.03125,-0.175,0.25,0.03125,0.175,0.3}, --connect v

                        {-0.1,-0.1,0.2,0.1,0.1,0.375}, --lamp
		},
	},
})

minetest.register_node(":firealarm:hornstrobe_uk_white_off",{
	description = "UK Fire Alarm (white)",
	groups = { oddly_breakable_by_hand = 1 },
        tiles = {
                "firealarm_hornstrobe_uk_side_white.png",
                "firealarm_hornstrobe_uk_side_white.png",
                "firealarm_hornstrobe_uk_side_white.png",
                "firealarm_hornstrobe_uk_side_white.png",
                "firealarm_hornstrobe_uk_side_white.png",
                "firealarm_hornstrobe_uk_front_white.png",
        },
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                        {-0.175,-0.175,0.375,0.175,0.175,0.5}, --box

                        {-0.175,-0.175,0.25,-0.159090909091,0.175,0.375}, --wall left
                        {0.159090909091,-0.175,0.25,0.175,0.175,0.375}, --wall right
                        {-0.175,-0.175,0.25,0.175,-0.159090909091,0.375}, --wall down
                        {-0.175,0.159090909091,0.25,0.175,0.175,0.375}, --wall up

                        {-0.175,-0.03125,0.25,0.175,0.03125,0.3}, --connect h
                        {-0.03125,-0.175,0.25,0.03125,0.175,0.3}, --connect v

                        {-0.1,-0.1,0.2,0.1,0.1,0.375}, --lamp
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("notification",pos,{strobeActive = false,hornActive = false})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("notification",pos,nil)
	end,
})

local ukWhiteHornstrobeOnFrontTexture = "[combine:92x920"..
                                      ":0,0=firealarm_hornstrobe_uk_front_on.png"..
                                      ":0,92=firealarm_hornstrobe_uk_front_white.png"..
                                      ":0,184=firealarm_hornstrobe_uk_front_white.png"..
                                      ":0,276=firealarm_hornstrobe_uk_front_white.png"..
                                      ":0,368=firealarm_hornstrobe_uk_front_white.png"..
                                      ":0,460=firealarm_hornstrobe_uk_front_white.png"..
                                      ":0,552=firealarm_hornstrobe_uk_front_white.png"..
                                      ":0,644=firealarm_hornstrobe_uk_front_white.png"..
                                      ":0,736=firealarm_hornstrobe_uk_front_white.png"..
                                      ":0,828=firealarm_hornstrobe_uk_front_white.png"

minetest.register_node(":firealarm:hornstrobe_uk_white_on",{
	drop = "firealarm:hornstrobe_uk_white_off",
	description = "UK Fire Alarm (white) (wait, why do you have this?)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
        tiles = {
                "firealarm_hornstrobe_uk_side_white.png",
                "firealarm_hornstrobe_uk_side_white.png",
                "firealarm_hornstrobe_uk_side_white.png",
                "firealarm_hornstrobe_uk_side_white.png",
                "firealarm_hornstrobe_uk_side_white.png",
                {
                	name = ukWhiteHornstrobeOnFrontTexture,
                        animation = {
                                type = "vertical_frames",
                                aspect_w = 92,
                                aspect_h = 92,
                                length = 1,
                        },
                },
        },
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	use_texture_alpha = "blend",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                        {-0.175,-0.175,0.375,0.175,0.175,0.5}, --box

                        {-0.175,-0.175,0.25,-0.159090909091,0.175,0.375}, --wall left
                        {0.159090909091,-0.175,0.25,0.175,0.175,0.375}, --wall right
                        {-0.175,-0.175,0.25,0.175,-0.159090909091,0.375}, --wall down
                        {-0.175,0.159090909091,0.25,0.175,0.175,0.375}, --wall up

                        {-0.175,-0.03125,0.25,0.175,0.03125,0.3}, --connect h
                        {-0.03125,-0.175,0.25,0.03125,0.175,0.3}, --connect v

                        {-0.1,-0.1,0.2,0.1,0.1,0.375}, --lamp
		},
	},
})

minetest.register_node(":firealarm:flashlight_red_off",{
	description = "Flashlight (red)",
	groups = { oddly_breakable_by_hand = 1 },
        tiles = {
                "firealarm_flashlight_red_side.png",
                "firealarm_flashlight_red_side.png",
                "firealarm_flashlight_red_side.png",
                "firealarm_flashlight_red_side.png",
                "firealarm_flashlight_red_side.png",
                "firealarm_flashlight_red_front.png",
        },
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                        {-0.175,-0.175,0.375,0.175,0.175,0.5}, --box
                        {-0.159090909091,-0.159090909091,0.35,0.159090909091,0.159090909091,0.375}, --lamp
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("notification",pos,{strobeActive = false,hornActive = false})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("notification",pos,nil)
	end,
})

local flashlightRedOnFrontTexture = "[combine:92x920"..
                                      ":0,0=firealarm_flashlight_front_on.png"..
                                      ":0,92=firealarm_flashlight_red_front.png"..
                                      ":0,184=firealarm_flashlight_red_front.png"..
                                      ":0,276=firealarm_flashlight_red_front.png"..
                                      ":0,368=firealarm_flashlight_red_front.png"..
                                      ":0,460=firealarm_flashlight_red_front.png"..
                                      ":0,552=firealarm_flashlight_red_front.png"..
                                      ":0,644=firealarm_flashlight_red_front.png"..
                                      ":0,736=firealarm_flashlight_red_front.png"..
                                      ":0,828=firealarm_flashlight_red_front.png"

minetest.register_node(":firealarm:flashlight_red_on",{
	drop = "firealarm:flashlight_red_off",
	description = "Flashlight (red) (wait, why do you have this?)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
        tiles = {
                "firealarm_flashlight_red_side.png",
                "firealarm_flashlight_red_side.png",
                "firealarm_flashlight_red_side.png",
                "firealarm_flashlight_red_side.png",
                "firealarm_flashlight_red_side.png",
                {
                	name = flashlightRedOnFrontTexture,
                        animation = {
                                type = "vertical_frames",
                                aspect_w = 92,
                                aspect_h = 92,
                                length = 1,
                        },
                },
        },
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	use_texture_alpha = "blend",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                        {-0.175,-0.175,0.375,0.175,0.175,0.5}, --box
                        {-0.159090909091,-0.159090909091,0.35,0.159090909091,0.159090909091,0.375}, --lamp
		},
	},
})

minetest.register_node(":firealarm:flashlight_white_off",{
	description = "Flashlight (white)",
	groups = { oddly_breakable_by_hand = 1 },
        tiles = {
                "firealarm_flashlight_white_side.png",
                "firealarm_flashlight_white_side.png",
                "firealarm_flashlight_white_side.png",
                "firealarm_flashlight_white_side.png",
                "firealarm_flashlight_white_side.png",
                "firealarm_flashlight_white_front.png",
        },
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                        {-0.175,-0.175,0.375,0.175,0.175,0.5}, --box
                        {-0.159090909091,-0.159090909091,0.35,0.159090909091,0.159090909091,0.375}, --lamp
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("notification",pos,{strobeActive = false,hornActive = false})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("notification",pos,nil)
	end,
})

local flashlightWhiteOnFrontTexture = "[combine:92x920"..
                                      ":0,0=firealarm_flashlight_front_on.png"..
                                      ":0,92=firealarm_flashlight_white_front.png"..
                                      ":0,184=firealarm_flashlight_white_front.png"..
                                      ":0,276=firealarm_flashlight_white_front.png"..
                                      ":0,368=firealarm_flashlight_white_front.png"..
                                      ":0,460=firealarm_flashlight_white_front.png"..
                                      ":0,552=firealarm_flashlight_white_front.png"..
                                      ":0,644=firealarm_flashlight_white_front.png"..
                                      ":0,736=firealarm_flashlight_white_front.png"..
                                      ":0,828=firealarm_flashlight_white_front.png"

minetest.register_node(":firealarm:flashlight_white_on",{
	drop = "firealarm:flashlight_white_off",
	description = "Flashlight (white) (wait, why do you have this?)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
        tiles = {
                "firealarm_flashlight_white_side.png",
                "firealarm_flashlight_white_side.png",
                "firealarm_flashlight_white_side.png",
                "firealarm_flashlight_white_side.png",
                "firealarm_flashlight_white_side.png",
                {
                	name = flashlightWhiteOnFrontTexture,
                        animation = {
                                type = "vertical_frames",
                                aspect_w = 92,
                                aspect_h = 92,
                                length = 1,
                        },
                },
        },
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	use_texture_alpha = "blend",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                        {-0.175,-0.175,0.375,0.175,0.175,0.5}, --box
                        {-0.159090909091,-0.159090909091,0.35,0.159090909091,0.159090909091,0.375}, --lamp
		},
	},
})

minetest.register_abm({
	label = "Update horn/strobe state",
	nodenames = {"firealarm:hornstrobe_off","firealarm:hornstrobe_on"},
	interval = 14,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("notification",pos)
		if not devInfo then return end
		if node.name == "firealarm:hornstrobe_off" and devInfo.strobeActive then
			node.name = "firealarm:hornstrobe_on"
			minetest.set_node(pos,node)
		elseif node.name == "firealarm:hornstrobe_on" and not devInfo.strobeActive then
			node.name = "firealarm:hornstrobe_off"
			minetest.set_node(pos,node)
		end
		if devInfo.hornActive then
			minetest.sound_play("firealarm_horn",{pos=pos})
		end
	end,
})

minetest.register_abm({
	label = "Update remote strobe state",
	nodenames = {"firealarm:remotestrobe_off","firealarm:remotestrobe_on"},
	interval = 1,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("notification",pos)
		if not devInfo then return end
		if node.name == "firealarm:remotestrobe_off" and devInfo.strobeActive then
			node.name = "firealarm:remotestrobe_on"
			minetest.set_node(pos,node)
		elseif node.name == "firealarm:remotestrobe_on" and not devInfo.strobeActive then
			node.name = "firealarm:remotestrobe_off"
			minetest.set_node(pos,node)
		end
	end,
})

minetest.register_abm({
	label = "Update horn/light plate state",
	nodenames = {"firealarm:hornstrobe_old_off","firealarm:hornstrobe_old_on"},
	interval = 3,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("notification",pos)
		if not devInfo then return end
		if node.name == "firealarm:hornstrobe_old_off" and devInfo.strobeActive then
			node.name = "firealarm:hornstrobe_old_on"
			minetest.set_node(pos,node)
		elseif node.name == "firealarm:hornstrobe_old_on" and not devInfo.strobeActive then
			node.name = "firealarm:hornstrobe_old_off"
			minetest.set_node(pos,node)
		end
		if devInfo.hornActive then
			minetest.sound_play("firealarm_horn_old",{pos=pos})
		end
	end,
})

minetest.register_abm({
	label = "Update horn/strobe state",
	nodenames = {"firealarm:hornstrobe_german_red_off","firealarm:hornstrobe_german_red_on"},
	interval = 1.075,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("notification",pos)
		if not devInfo then return end
		if node.name == "firealarm:hornstrobe_german_red_off" and devInfo.strobeActive then
			node.name = "firealarm:hornstrobe_german_red_on"
			minetest.set_node(pos,node)
		elseif node.name == "firealarm:hornstrobe_german_red_on" and not devInfo.strobeActive then
			node.name = "firealarm:hornstrobe_german_red_off"
			minetest.set_node(pos,node)
		end
		if devInfo.hornActive then
			minetest.sound_play("firealarm_horn_german",{pos=pos})
		end
	end,
})

minetest.register_abm({
	label = "Update horn/strobe state",
	nodenames = {"firealarm:hornstrobe_german_white_off","firealarm:hornstrobe_german_white_on"},
	interval = 1.075,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("notification",pos)
		if not devInfo then return end
		if node.name == "firealarm:hornstrobe_german_white_off" and devInfo.strobeActive then
			node.name = "firealarm:hornstrobe_german_white_on"
			minetest.set_node(pos,node)
		elseif node.name == "firealarm:hornstrobe_german_white_on" and not devInfo.strobeActive then
			node.name = "firealarm:hornstrobe_german_white_off"
			minetest.set_node(pos,node)
		end
		if devInfo.hornActive then
			minetest.sound_play("firealarm_horn_german",{pos=pos})
		end
	end,
})

minetest.register_abm({
	label = "Update horn/strobe state",
	nodenames = {"firealarm:hornstrobe_uk_red_off","firealarm:hornstrobe_uk_red_on"},
	interval = 3,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("notification",pos)
		if not devInfo then return end
		if node.name == "firealarm:hornstrobe_uk_red_off" and devInfo.strobeActive then
			node.name = "firealarm:hornstrobe_uk_red_on"
			minetest.set_node(pos,node)
		elseif node.name == "firealarm:hornstrobe_uk_red_on" and not devInfo.strobeActive then
			node.name = "firealarm:hornstrobe_uk_red_off"
			minetest.set_node(pos,node)
		end
		if devInfo.hornActive then
			minetest.sound_play("firealarm_horn_uk",{pos=pos})
		end
	end,
})

minetest.register_abm({
	label = "Update horn/strobe state",
	nodenames = {"firealarm:hornstrobe_uk_white_off","firealarm:hornstrobe_uk_white_on"},
	interval = 3,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("notification",pos)
		if not devInfo then return end
		if node.name == "firealarm:hornstrobe_uk_white_off" and devInfo.strobeActive then
			node.name = "firealarm:hornstrobe_uk_white_on"
			minetest.set_node(pos,node)
		elseif node.name == "firealarm:hornstrobe_uk_white_on" and not devInfo.strobeActive then
			node.name = "firealarm:hornstrobe_uk_white_off"
			minetest.set_node(pos,node)
		end
		if devInfo.hornActive then
			minetest.sound_play("firealarm_horn_uk",{pos=pos})
		end
	end,
})

minetest.register_abm({
	label = "Update horn/strobe state",
	nodenames = {"firealarm:flashlight_red_off","firealarm:flashlight_red_on"},
	interval = 1,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("notification",pos)
		if not devInfo then return end
		if node.name == "firealarm:flashlight_red_off" and devInfo.strobeActive then
			node.name = "firealarm:flashlight_red_on"
			minetest.set_node(pos,node)
		elseif node.name == "firealarm:flashlight_red_on" and not devInfo.strobeActive then
			node.name = "firealarm:flashlight_red_off"
			minetest.set_node(pos,node)
		end
	end,
})

minetest.register_abm({
	label = "Update horn/strobe state",
	nodenames = {"firealarm:flashlight_white_off","firealarm:flashlight_white_on"},
	interval = 1,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("notification",pos)
		if not devInfo then return end
		if node.name == "firealarm:flashlight_white_off" and devInfo.strobeActive then
			node.name = "firealarm:flashlight_white_on"
			minetest.set_node(pos,node)
		elseif node.name == "firealarm:flashlight_white_on" and not devInfo.strobeActive then
			node.name = "firealarm:flashlight_white_off"
			minetest.set_node(pos,node)
		end
	end,
})

minetest.register_craft({
	output = "firealarm:hornstrobe_off",
	recipe = {
		{"","mesecons_lightstone:lightstone_white_off","",},
		{"dye:white","homedecor:speaker_driver","dye:white",},
		{"","plasticbox:plasticbox","homedecor:ic",},
	}
})

minetest.register_craft({
	output = "firealarm:remotestrobe_off",
	recipe = {
		{"","mesecons_lightstone:lightstone_white_off","",},
		{"dye:white","","dye:white",},
		{"","plasticbox:plasticbox","homedecor:ic",},
	}
})

minetest.register_craft({
	output = "firealarm:hornstrobe_old_off",
	recipe = {
		{"","ilights:light","",},
		{"dye:white","homedecor:speaker_driver","dye:white",},
		{"","plasticbox:plasticbox","",},
	}
})

minetest.register_craft({
	output = "firealarm:hornstrobe_german_red_off",
	recipe = {
		{"","mesecons_lightstone:lightstone_red_off","",},
		{"dye:red","homedecor:speaker_driver","dye:red",},
		{"","plasticbox:plasticbox","homedecor:ic",},
	}
})

minetest.register_craft({
	output = "firealarm:hornstrobe_german_white_off",
	recipe = {
		{"","mesecons_lightstone:lightstone_red_off","",},
		{"dye:white","homedecor:speaker_driver","dye:white",},
		{"","plasticbox:plasticbox","homedecor:ic",},
	}
})

minetest.register_craft({
	output = "firealarm:hornstrobe_uk_red_off",
	recipe = {
		{"","mesecons_lightstone:lightstone_red_off","",},
		{"dye:red","homedecor:speaker_driver","dye:red",},
		{"homedecor:ic","plasticbox:plasticbox","",},
	}
})

minetest.register_craft({
	output = "firealarm:hornstrobe_uk_white_off",
	recipe = {
		{"","mesecons_lightstone:lightstone_red_off","",},
		{"dye:white","homedecor:speaker_driver","dye:white",},
		{"homedecor:ic","plasticbox:plasticbox","",},
	}
})

minetest.register_craft({
	output = "firealarm:flashlight_red_off",
	recipe = {
		{"","plasticbox:plasticbox","",},
		{"dye:red","mesecons_lightstone:lightstone_red_off","dye:red",},
		{"homedecor:ic","plasticbox:plasticbox","",},
	}
})

minetest.register_craft({
	output = "firealarm:flashlight_white_off",
	recipe = {
		{"","plasticbox:plasticbox","",},
		{"dye:white","mesecons_lightstone:lightstone_red_off","dye:white",},
		{"homedecor:ic","plasticbox:plasticbox","",},
	}
})