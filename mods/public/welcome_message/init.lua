JoinMessageOverride = true
Hide = {
	mpplayer = true,
}

function core.send_join_message(player_name)
	if not JoinMessageOverride and not core.is_singleplayer() then
		core.chat_send_all("*** " .. player_name .. " joined the game.")
	end
end

function core.send_leave_message(player_name, timed_out)
	if Hide[player_name] then
		return
	end
	local announcement = "*** " .. player_name .." left the game."
	if timed_out then
		announcement = "*** " .. player_name .. " left the game (timed out)."
	end
	core.chat_send_all(announcement)
end

local function get_color(player)
	local pmeta = player:get_meta()
	local color = pmeta:get_string("msg_color:color")
	return color
end

local function checkPlural(timeNum, timeStr)
	if timeNum == 1 then
		return timeStr
	end
	return timeStr .. "s"
end

minetest.register_on_joinplayer(
	function(player, last_login)
		local name = player:get_player_name()
		if name ~= "mpplayer" then
			if last_login == nil then
				minetest.chat_send_all(minetest.colorize(get_color(player), "[" .. name .. "]") .. minetest.colorize("#3B633D", " has joined the game for the first time! Welcome!"))
			else
				local current_time_unix = os.time()
				
				local sec = current_time_unix - last_login
				local min = math.floor(sec / 60)
				sec = sec % 60
				
				local hour = math.floor(min / 60)
				min = min % 60
				
				local day = math.floor(hour / 24)
				hour = hour % 24
				
				local month = math.floor(day / 30)
				day = day % 30
				
				local year = math.floor(month / 12)
				month = month % 12
				
				local last_login_msg = tostring(sec) .. " " .. checkPlural(sec, "second") .. " ago"
				
				if min > 0 then
					last_login_msg = tostring(min) .. " " .. checkPlural(min, "minute") .. " ago"
				end
				if hour > 0 then
					last_login_msg = tostring(hour) .. " " .. checkPlural(hour, "hour") .. " ago"
				end
				if day > 0 then
					last_login_msg = tostring(day) .. " " .. checkPlural(day, "day") .. " ago"
				end
				if month > 0 then
					last_login_msg = tostring(month) .. " " .. checkPlural(month, "month") .. " ago"
				end
				if year > 0 then
					last_login_msg = "more than a year ago"
				end
				
				minetest.chat_send_all(minetest.colorize("#3B633D", "Welcome back, ") .. minetest.colorize(get_color(player), "[" .. name .. "]") .. minetest.colorize("#3B633D", "! Last login: " .. last_login_msg))
			end
		end
		
		return true	-- Prevent regular welcome message from being displayed
	end
)
