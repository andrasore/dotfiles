local conditions = require('heirline.conditions')
local utils = require('heirline.utils')

local Column = { provider = '|' }
local Space = { provider = ' ' }
local Align = { provider = "%=" }
local Ruler = { provider = "%3P %2c,%2l" }
local Fileencoding = { provider = "%{strlen(&fenc)?&fenc:'none'}" }

local Filetype = {
    provider = function(self)
        if vim.bo.filetype == '' then
           return 'none'
        end
        return vim.bo.filetype
    end
}

local FileName = {
    provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
        if filename == "" then return "[No Name]" end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename
    end,
}

local FileFormat = {
    provider = function()
        return vim.bo.fileformat
    end
}

-- TODO - refactor using heirline child elems

local function UseDelimiter(items)
    local delimited = { Space, items[1], Space }
    for i = 2, #items do
        table.insert(delimited, Column)
        table.insert(delimited, Space)
        table.insert(delimited, items[i])
        table.insert(delimited, Space)
    end
    return delimited
end

local VimMode = {
    init = function(self)
        self.mode = vim.fn.mode()
    end,

    static = {
        mode_names = {
            n = "Normal",
            v = "Visual",
            i = "Insert",
            R = "Replace",
            s = "Select",
            t = "Terminal",
            c = "Command",
            ['!'] = "Shell",
        }
    },

    provider = function(self)
        return self.mode_names[self.mode]
    end
}

return {
    UseDelimiter({ VimMode, FileName }),
    Align,
    UseDelimiter({ FileFormat, Fileencoding, Filetype, Ruler })
}
