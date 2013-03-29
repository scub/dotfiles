" VIMRC OF SKOOBIE
"
" Drop Backups Into ~/.vim/tmp and ~/.vim/backup 
" REQUIRES mkdir -p ~/.vim/tmp ~/.vim/backup {
set nobackup
"set backupdir=~/.vim/backup
set directory=.,/tmp
" }
"
" Play Nice With Python 3, expand all tabs to 8 spaces {
set softtabstop=8
set tabstop=8
set expandtab
retab
" }
"
" STFU {
set noerrorbells
set visualbell
set nohlsearch
set t_vb=
" }
"
" SYNTAX HIGHLIGHTS {
syntax enable
filetype on
" }
"
" ETC {
set nowrap              " No Line Wrapping (:set wrap to enable)
set incsearch           " Search While Typing 
set shell=bash
set backspace=indent,eol,start " Fix Pesky Backspace Issue, To Function As Expected


map <C-F> :set hls! <bar> set hls?<CR> " Toggle hilights on ctrl+f 
" }
"
" EOF
