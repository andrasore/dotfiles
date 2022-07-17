local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function ()
    use 'wbthomason/packer.nvim'
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use 'godlygeek/tabular'
    use 'neovim/nvim-lspconfig'
    use 'google/vim-searchindex'
    use 'jiangmiao/auto-pairs'
    use 'ahmedkhalf/project.nvim'
    use 'elihunter173/dirbuf.nvim'
    use 'tpope/vim-repeat'
    use 'sbdchd/neoformat'
    use 'rebelot/heirline.nvim'
    use { 'ms-jpq/coq_nvim', branch = 'coq' }
    use { 'ms-jpq/coq.artifacts', branch = 'artifacts' }
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'tpope/vim-fugitive'
end)
