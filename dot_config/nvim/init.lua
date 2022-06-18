--------------------------------------------------------------------------------
--  => General                                                                --
--------------------------------------------------------------------------------
--  Sane defaults for all platforms
vim.opt.fileformat = "unix"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Fast saving
vim.api.nvim_set_keymap("n", "<leader>w", ":w<cr>", { noremap = true })

-- Quitting easily
vim.api.nvim_set_keymap("n", "<leader>q", ":q<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>Q", ":q!<cr>", { noremap = true })

-- Command for sudo mode write

-- command! Suw w !sudo tee % > /dev/null

--------------------------------------------------------------------------------
-- => VIM user interface                                                      --
--------------------------------------------------------------------------------
-- Set 10 lines to the cursor - when moving vertically using j/k
vim.opt.scrolloff = 4

-- Turn on the WiLd menu
vim.opt.wildignorecase = true
vim.opt.wildignore = "*.o,*~,*.pyc"

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

-- Latex
vim.g.tex_flavor = "latex"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Workaround for keycodes beginning with esc
vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 0

--------------------------------------------------------------------------------
-- => Colors and Fonts                                                        --
--------------------------------------------------------------------------------
-- Enable syntax highlighting
vim.cmd([[
syntax enable
]])

-- Use Unix as the standard file type
vim.opt.fileformats = "unix,dos,mac"

--------------------------------------------------------------------------------
-- => Files, backups and undo                                                 --
--------------------------------------------------------------------------------
-- Turn backup off, since most stuff is in SVN, git et.c anyway...
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.undofile = true

-- "Enable filetype plugin loading
vim.cmd([[
filetype plugin on
]])


-- Normal python tab width
vim.cmd([[
autocmd FileType python setlocal tabstop=2
]])

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
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true })

-- Switch CWD
vim.api.nvim_set_keymap("n", "<leader>cd", ":cd %:p:h<cr>:pwd<cr>", { noremap = true })

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

--------------------------------------------------------------------------------
-- => Status line - TODO - port to lua                                        --
--------------------------------------------------------------------------------
-- Always show the status line
vim.cmd([[
set laststatus=2

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

require("plugins")

-- Telescope

vim.api.nvim_set_keymap("n", "<leader>p", ":Telescope find_files<Cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>b", ":Telescope buffers<Cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>r", ":Telescope oldfiles<Cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>x", ":Telescope commands<Cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>f", ":Telescope grep_string<Cr>", { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>gc", ":Telescope git_commits<Cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>gb", ":Telescope git_branches<Cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>gs", ":Telescope git_status<Cr>", { noremap = true })

-- Dirbuf

require("dirbuf").setup({
    write_cmd = "DirbufSync -confirm"
})
