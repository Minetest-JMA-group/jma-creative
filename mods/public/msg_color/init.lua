local colors = {"#E4FF00", "#17FF00", "#06E5CE", "#0617E5", "#005A28"}
local i = 0
local moderators = {"milicap", "Teaa"}
local builders = {"JR25"}

local function get_color(name)
	local player = minetest.get_player_by_name(name)
	local pmeta = player:get_meta()
	local color = pmeta:get_string("msg_color:color")
	return color
end

local function isStringInList(target, stringList)
	for _, str in ipairs(stringList) do
		if str == target then
			return true
		end
	end
	return false
end

minetest.register_on_joinplayer(
	function(player)
		local pmeta = player:get_meta()
		-- Players with roles don't get random colors
		if player:get_player_name() == "mpplayer" then
			pmeta:set_string("msg_color:color", "#AD0000")
			return
		end
		if player:get_player_name() == "milicap" then
			pmeta:set_string("msg_color:color", "#EE8500")
			return
		end
		if player:get_player_name() == "Teaa" then
			pmeta:set_string("msg_color:color", "#FF00F7")
			return
		end
		if player:get_player_name() == "JR25" then
			pmeta:set_string("msg_color:color", "#1900EF")
			return
		end
		-- Continue for normal players
		i = i + 1
		if i > 5 then
			i = 1
		end
		
		pmeta:set_string("msg_color:color", colors[i])
	end
)

minetest.register_on_chat_message(
	function(name, msg)
		-- Handle admin
		if name == "mpplayer" then
			minetest.chat_send_all(minetest.colorize("#FF0000", "[Admin]") .. minetest.colorize("#AD0000", " <mpplayer> ") .. msg)
			return true
		end
		
		local color = get_color(name)
		local tag = ""
		if isStringInList(name, moderators) then
			tag = minetest.colorize("#13FF00", "[Moderator]")
		end
		if isStringInList(name, builders) then
			tag = minetest.colorize("#0DCC00", "[Builder]")
		end
				
		minetest.chat_send_all(tag .. minetest.colorize(color, '<' .. name .. '> ') .. msg)
		return true -- we return true to mark this chat message as handled
	end
)

