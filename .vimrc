" Not running Vi
set nocompatible

filetype plugin on

" pathogen to manage paths and plugins
execute pathogen#infect()
Helptags

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

" Show numbers, relative
set number
set relativenumber

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

" Highlight starting with 80th column as oversize warning
autocmd BufWinEnter,BufRead,InsertLeave * 2match OverLength /\%81v.\+/
set colorcolumn=80

" Highlight trailing whitespace characters or tabs
autocmd BufWinEnter * match ExtraWhitespace /\t/
autocmd BufWinEnter,InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Open split to the right side
set splitright

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

" Map Ctrl-J to insert linefeed after and Ctrl-K - before.
" Leaves cursor in position through ` mark
nnoremap <C-k> m`O<Esc>``
nnoremap <C-j> m`o<Esc>``

" Map Ctrl-L to split the line at current position
nnoremap <C-L> m`i<CR><Esc>``
" nnoremap <C-L> m`ciW<CR><Esc>:if match( @", "^\\s*$") < 0<Bar>
"            \ exec "norm P-$diw+"<Bar>endif<CR>``

" Syntastic setup
let g:syntastic_check_on_wq=0

" airline setup
set ttimeoutlen=50
let g:airline_left_sep  = ''
let g:airline_right_sep = ''
let g:airline_section_c = '%<%F%h%m%r'
let g:airline_section_b = '%{fugitive#statusline()} %{strftime("%H:%M")}'

" Statusline setup
set noshowmode
set laststatus=2

" Colorscheme and its tweaks to ensure better look
if &t_Co==256
    colorscheme industry
    let g:airline_theme = 'molokai'
else
    colorscheme solarized
    let g:airline_theme = 'jellybeans'
endif
highlight Folded cterm=underline term=underline ctermbg=none
highlight Conceal cterm=bold ctermbg=none
highlight ColorColumn ctermbg=darkgrey
highlight OverLength  ctermbg=darkblue

funct! Exec(command)
    redir =>output
    silent exec a:command
    redir END
    return output
endfunct!

" Neocomplcache setup
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" Enable omni completion.
au FileType css setlocal omnifunc=csscomplete#CompleteCSS
au FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
au FileType haskell setlocal omnifunc=necoghc#omnifunc
au FileType haskell setlocal completefunc=neocomplcache#completefunc
au FileType python setlocal omnifunc=pythoncomplete#Complete
au FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

set backspace=2
