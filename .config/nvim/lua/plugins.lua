vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer can manage itself

  use 'Mofiqul/dracula.nvim'

  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
end)
