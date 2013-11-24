" VIMRC OF SKOOBIE
"
" Drop Backups Into ~/.vim/tmp and ~/.vim/backup 
" REQUIRES mkdir -p ~/.vim/tmp ~/.vim/backup {
set nobackup
"set backupdir=~/.vim/backup
set directory=.,/tmp
" }
"
" Play Nice With Configs 
set softtabstop=2
set tabstop=2
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

if has("autocmd")
  filetype on
  autocmd filetype python set ts=4 sts=4 sw=4 et
  autocmd filetype bash set ts=4 sts=4 sw=4 et
  autocmd filetype puppet set ts=2 sts=2 sw=2 et
endif
" }
"
" METHODS {
function Pie ()
  setlocal sts=4 ts=4 sw=4 et 
endfunction

function Ppt ()
  setlocal sts=2 ts=2 sw=2 et
endfunction
     
command Pie call Pie()
command Ppt call Ppt()
" }
"
" EOF
