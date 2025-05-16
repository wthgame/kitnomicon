local fs = require("@lune/fs")
local process = require("@lune/process")

local delimiter = if process.os == "windows" then "\\" else "/"

local function path(...: string)
	return table.concat({ ... }, delimiter)
end

local function cwdPath(...: string)
	return table.concat({ process.cwd, ... }, delimiter)
end

return setmetatable({
	delimiter = delimiter,
	path = path,
	cwdPath = cwdPath,
}, {
	__index = fs,
})
