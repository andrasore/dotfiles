local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function ()
    use 'wbthomason/packer.nvim'
    use {
      'nvim-telescope/telescope.nvim',
      requires = { {'nvim-lua/plenary.nvim'} }
    }
    -- use 'freitass/todo.txt-vim'
    use 'godlygeek/tabular'
    use 'google/vim-searchindex'
    use 'jiangmiao/auto-pairs'
    -- use 'justinmk/vim-dirvish'
    use 'elihunter173/dirbuf.nvim'
    -- use 'maralla/completor.vim'
    use 'tpope/vim-repeat'
    -- use 'tpope/vim-surround'
    -- use 'ziglang/zig.vim'
end)
