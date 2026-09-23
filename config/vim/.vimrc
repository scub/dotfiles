set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle')

Plugin 'VundleVim/Vundle.vim'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'altercation/vim-colors-solarized'
Plugin 'hashivim/vim-terraform'
Plugin 'preservim/vim-indent-guides'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'marshallward/vim-restructuredtext'
Plugin 'stephpy/vim-yaml'
Plugin 'mg979/vim-visual-multi'

call vundle#end()

filetype plugin indent on

syntax enable
set background=dark
set encoding=utf8
set number
set rnu

set sts=2 sw=2 ts=2 et

" Enable plugin stuff
let g:ycm_clangd_binary_path = trim(system('brew --prefix llvm')).'/bin/clangd'
let g:better_whitespace_enabled=1
let g:indent_guides_enable_on_vim_startup = 1
