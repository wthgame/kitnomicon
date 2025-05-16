--!nolint LocalShadow

local process = require("@lune/process")

type ExecOptions = process.ExecOptions

local function execute(command: { string }, options: ExecOptions?)
	local bin = command[1]
	local args = table.clone(command)
	table.remove(args, 1)

	local options: ExecOptions = options and table.clone(options) or {}
	options.shell = if options.shell == nil or options.shell == true then true else nil

	local result = table.clone(process.exec(bin, args, options))
	if not result.ok then
		print(`Command failed:\n{result.stderr}\n{result.stdout}`)
	end
	return result
end

return execute
