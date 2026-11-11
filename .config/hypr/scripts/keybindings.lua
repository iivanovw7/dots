-- Keybinding helpers and Fuzzel index generator

local HOME = os.getenv("HOME") or ""
local index_path = HOME .. "/.config/hypr/keybindings.tsv"
local index = io.open(index_path, "w")

local function clean_field(value)
	return tostring(value or ""):gsub("[\t\r\n]", " ")
end

-- Read the comment from the calling line in hyprland.lua
local function get_comment()
	local info = debug.getinfo(3, "Sl")
	if not info or not info.source then
		return ""
	end

	local source = info.source:gsub("^@", "")
	local file = io.open(source, "r")
	if not file then
		return ""
	end

	local line
	for i = 1, info.currentline do
		line = file:read("*l")
		if not line then
			break
		end
	end
	file:close()

	if not line then
		return ""
	end
	return line:match("%-%-%s*(.-)%s*$") or ""
end

local function bind(key, dispatcher, opts, command, description)
	hl.bind(key, dispatcher, opts)

	if index then
		description = description or get_comment()

		if description == "" then
			description = "Hyprland action"
		end

		index:write(clean_field(key) .. " -- " .. clean_field(description) .. "\t" .. clean_field(command) .. "\n")
	end
end

local function exec(key, command, opts)
	local description = get_comment()
	bind(key, hl.dsp.exec_cmd(command), opts, command, description)
end

local function close()
	if index then
		index:close()
		index = nil
	end
end

return {
	bind = bind,
	exec = exec,
	close = close,
}
