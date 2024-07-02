---@class Paper
---@field current_buf number?
---@field notes_location string?
local M = {}

M.current_buf = nil
M.notes_location = ""
local notes_win = nil

function M.open_notes()
    local curr_win = vim.api.nvim_get_current_win()
    local curr_size = {
        width = vim.api.nvim_win_get_width(curr_win),
        height = vim.api.nvim_win_get_height(curr_win)
    }
    M.current_buf = M.current_buf or vim.api.nvim_create_buf(true, false)
    local config = {
        title = "Paper",
        relative = "win",
        width = 50,
        height = 20,
        border = "single",
        style = "minimal"
    }
    config.col = curr_size.width / 2 - config.width / 2
    config.row = curr_size.height / 2 - config.height / 2
    notes_win = vim.api.nvim_open_win(M.current_buf, true, config)
end

---saves notes file lol
---@param lines string[]
---@param filename string
local function save_file(lines, filename)
    if M.notes_location == "" or M.notes_location == " " then
        M.notes_location = nil
    else
        if M.notes_location[#M.notes_location] ~= "/" then
            M.notes_location = M.notes_location .. "/"
        end
    end
    local dir = M.notes_location or "/tmp/"
    local file, err = io.open(dir .. filename, "w")
    if not file then
        print("\n" .. err)
        return
    end
    for _, line in ipairs(lines) do
        file:write(line)
    end
    file:close()
    M.current_buf = nil
end

function M.save_notes()
    local lines = vim.api.nvim_buf_get_lines(M.current_buf, 0, -1, true)
    local buf_is_empty = true
    --- @type number, string
    for _, line in ipairs(lines) do
        if string.len(line) ~= 0 then
            buf_is_empty = false
            break
        end
    end
    if not buf_is_empty then
        local filename = vim.fn.input("Enter the notes name: ")
        if filename == "" then
            print("No filename enetered")
        else
            save_file(lines, filename)
        end
    end
end

return M
