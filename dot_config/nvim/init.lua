--------------------------------------------------------------------------------
--  => General                                                                --
--------------------------------------------------------------------------------
--  Sane defaults for all platforms
vim.opt.fileformat = 'unix'

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Fast saving
vim.api.nvim_set_keymap('n', '<leader>w', ':w<cr>', { noremap = true })

-- Quitting easily
vim.api.nvim_set_keymap('n', '<leader>q', ':q<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>Q', ':q!<cr>', { noremap = true })


-- Command for sudo mode write

-- command! Suw w !sudo tee % > /dev/null

--------------------------------------------------------------------------------
-- => VIM user interface                                                      --
--------------------------------------------------------------------------------

-- Do not colorscheme me
vim.cmd.colorscheme('vim')

-- Set 10 lines to the cursor - when moving vertically using j/k
vim.opt.scrolloff = 4

-- Turn on the WiLd menu
vim.opt.wildignorecase = true
vim.opt.wildignore = '*.o,*~,*.pyc'

vim.opt.cmdheight = 1

-- Searching options
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

-- Don't redraw while executing macros (good performance config)
vim.opt.lazyredraw = true

-- For regular expressions turn magic on
vim.opt.magic = true

-- Show matching brackets when text indicator is over them
vim.opt.showmatch = true
-- How many tenths of a second to blink when matching brackets
vim.opt.matchtime = 2

-- No annoying sound on errors
vim.opt.errorbells = false

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- this merges the sign column and the number column
vim.opt.signcolumn = 'number'

-- Use Unix as the standard file type
vim.opt.fileformats = 'unix,dos,mac'

--------------------------------------------------------------------------------
-- => Files, backups and undo                                                 --
--------------------------------------------------------------------------------
-- Turn backup off, since most stuff is in SVN, git et.c anyway...
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.undofile = true

--------------------------------------------------------------------------------
-- => Text, tab and indent related                                            --
--------------------------------------------------------------------------------
-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Be smart when using tabs
vim.opt.smarttab = true

-- 1 tab == 4 spaces
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.smartindent = true

--------------------------------------------------------------------------------
-- => Moving around, tabs, windows and buffers                                --
--------------------------------------------------------------------------------

-- Smart way to move between windows
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true })

-- Switch CWD
vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:p:h<cr>:pwd<cr>', { noremap = true })

-- Return to last edit position when opening files
vim.cmd([[
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif
]])

-- Remember info about open buffers on close
table.insert(vim.opt.viminfo, '%')

-- Folding
-- fold based on indent
vim.opt.foldmethod = 'indent'
-- deepest fold is 2 levels
vim.opt.foldnestmax = 2
-- don't fold by default
vim.opt.foldenable = false

-- Handle tabs

vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnew<Cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tq', ':tabclose<Cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tl', ':tabnext<Cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>th', ':tabprevious<Cr>', { noremap = true })

-- Handle terminal

vim.api.nvim_set_keymap('n', '<leader>x', ':terminal<Cr>', { noremap = true })

vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

-- Terminal should start in insert mode
vim.cmd([[
autocmd TermOpen * startinsert
]])


-- No line numbers in terminal
vim.cmd([[
autocmd TermOpen * setlocal nonumber norelativenumber
]])


--------------------------------------------------------------------------------
-- => Status line - TODO - port to lua                                        --
--------------------------------------------------------------------------------

-- Always show the status line
vim.opt.laststatus = 2

vim.cmd([[
set statusline=\ %{StatuslineMode()}
set statusline+=\ \|
set statusline+=\ %m
set statusline+=%=
set statusline+=\ %{&ff}
set statusline+=\ \|
set statusline+=\ %{strlen(&fenc)?&fenc:'none'}
set statusline+=\ \|
set statusline+=\ %y
set statusline+=\ \|
set statusline+=\ %P
set statusline+=\ %c,%l\ "

function! StatuslineMode()
    let l:mode=mode()
    if l:mode==#"n"
        return "Normal"
    elseif l:mode==?"v"
        return "Visual"
    elseif l:mode==#"i"
        return "Insert"
    elseif l:mode==#"R"
        return "Replace"
    elseif l:mode==?"s"
        return "Select"
    elseif l:mode==#"t"
        return "Terminal"
    elseif l:mode==#"c"
        return "Command"
    elseif l:mode==#"!"
        return "Shell"
    endif
endfunction
]])

--------------------------------------------------------------------------------
-- => Editing mappings                                                        --
--------------------------------------------------------------------------------

--command for removing trailing whitespaces
vim.cmd([[
function! TrimWhiteSpace()
  %s/\s\s*$//
  ''
:endfunction

command! RemoveTrailing call TrimWhiteSpace()
]])

--------------------------------------------------------------------------------
-- => Plugin config                                                           --
--------------------------------------------------------------------------------
---
require("config.lazy")

-- Telescope

vim.api.nvim_set_keymap('n', '<leader>p', ':Telescope find_files<Cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>b', ':Telescope buffers<Cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>r', ':Telescope oldfiles<Cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope live_grep<Cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>*', ':Telescope grep_string<Cr>', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>gc', ':Telescope git_commits<Cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gb', ':Telescope git_branches<Cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gs', ':Telescope git_status<Cr>', { noremap = true })

require('telescope').setup({
    defaults = {
        layout_strategy = 'bottom_pane',
        border = false,
        preview = false,
        layout_config = {
            prompt_position = 'bottom'
        },
    }
})

require('telescope').load_extension('fzf')

-- Project.nvim

-- require('project_nvim').setup({}) 

-- require('telescope').load_extension('projects')

-- vim.api.nvim_set_keymap('n', '<leader>o', ':Telescope projects<Cr>', { noremap = true })

-- Fugitive

vim.api.nvim_set_keymap('n', '<leader>gg', ':Git<Cr>', { noremap = true })
