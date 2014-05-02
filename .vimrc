" Not running Vi
set nocompatible

" pathogen to manage paths and plugins
execute pathogen#infect()

" Highlight scheme to emphasize trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

" Syntax highlighting
syntax on

" Highlight search
set hlsearch

" Command history
set history=1000

" If using a dark background within the editing area and syntax highlighting
set background=dark

" Jump to the last position when reopening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" Load indentation rules according to the detected filetype
filetype plugin indent on

" F2 to toggle pasting
" nnoremap <F2> :set invpaste paste?<CR>
" set pastetoggle=<F2>

au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> O1;2P :HdevtoolsClear<CR>
au FileType haskell nnoremap <buffer> <silent> <F3> :HdevtoolsInfo<CR>

" Show (partial) command in status line
set showcmd

" Show matching brackets.
set showmatch

" Do case insensitive matching
set ignorecase

" Do smart case matching
set smartcase

" Incremental search
set incsearch

" Automatically save before commands like :next and :make
set autowrite

" Hide buffers when they are abandoned
set hidden

" Enable mouse usage (all modes) in terminals
"set mouse=a

" Backspace behaving as in other editors
set backspace=indent,eol,start

" Press F2 before pasting text to avoid crazy indentation
set pastetoggle=<F2>

" Indentation/tabs
set tabstop=4
set shiftwidth=4
set expandtab
autocmd FileType ruby,eruby,yaml
            \ set autoindent shiftwidth=2 softtabstop=2 expandtab
autocmd FileType c set autoindent shiftwidth=4 softtabstop=4 noexpandtab

" Switch between tabs and spaces for indentation
nmap <silent> <S-t> :set expandtab! | if &expandtab | retab |
            \ echo 'spaces' | else | retab! | echo 'tabs' | endif<CR>

" Highlight trailing whitespace characters or tabs
autocmd BufWinEnter * match ExtraWhitespace /\t/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Replace CR with LF
noremap <C-n> :%s/\r/\r/g <CR>

" Reformat current paragraph
noremap <C-f> gwap

" Sort words
command! -nargs=0 -range SortWords call VisualSortWords()

function! VisualSortWords()
    let rv = @"
    let rt = getregtype('"')
    try
        norm! gvy
        call setreg('"', join(sort(split(@")), ' '), visualmode()[0])
        norm! `>pgvd
    finally
        call setreg('"', rv, rt)
    endtry
endfunction

" Unicode
set encoding=utf-8

" Temporary files
set backupdir=~/.vimtmp,.
set directory=~/.vimtmp,.

" Load plugins
runtime plugin/adjust-tabstop.vim

" Highlight starting with 80th column as oversize warning
highlight OverLength ctermfg=red guibg=#592929
match OverLength /\%80v.\+/

" Map Ctrl-J to insert linefeed after and Ctrl-K - before.
" Leaves cursor in position through ` mark
nnoremap <C-k> m`O<Esc>``
nnoremap <C-j> m`o<Esc>``

" Map Ctrl-L to split the line at current position
nnoremap <C-L> m`i<CR><Esc>``
" nnoremap <C-L> m`ciW<CR><Esc>:if match( @", "^\\s*$") < 0<Bar>
"            \ exec "norm P-$diw+"<Bar>endif<CR>``

let g:haddock_browser="/usr/bin/links2"
let g:neocomplcache_enable_at_startup = 1
let g:necoghc_enable_detailed_browse = 1

setlocal omnifunc=necoghc#omnifunc
autocmd BufEnter *.hs set formatprg=pointfree.wrap.sh

let g:haskell_conceal_wide = 1
