" Haskell setup
nnoremap <buffer> <F1> :HdevtoolsType<CR>
nnoremap <buffer> <silent> O1;2P :HdevtoolsClear<CR>
nnoremap <buffer> <silent> <F3> :HdevtoolsInfo<CR>
compiler ghc

" Neco-ghc setup
let g:haddock_browser="/usr/bin/lynx"
let g:necoghc_enable_detailed_browse = 1

" haskellmod setup
let g:ghc_symbolcache=1

set formatprg=pointfree.wrap.sh

" Vim2hs wide range concealing settings
let g:haskell_conceal_wide = 1
let g:haskell_conceal_bad  = 1

setlocal omnifunc=necoghc#omnifunc
let g:ycm_semantic_triggers = {'haskell' : ['.']}

let s:width = 80

function! HaskellModuleSection(...)
    let name = 0 < a:0 ? a:1 : inputdialog("Section name: ")

    return  repeat('-', s:width) . "\n"
    \       . "--  " . name . "\n"
    \       . "\n"
endfunction
nmap <silent> --s "=HaskellModuleSection()<CR>:put =<CR>

function! HaskellModuleHeader(...)
    let short = 0 < a:0 ? a:1 : inputdialog("Short description: ")
    let description = 1 < a:0 ? a:2 : inputdialog("Full description: ")

    return    "{- |\n"
    \       . "Module      : $Header$\n"
    \       . "Description : " . short . "\n"
    \       . "Copyright   : (c) Sukhmel Vladislav\n"
    \       . "License     : MIT\n"
    \       . "\n"
    \       . "Maintainer  : sukhmel.v@gmail.com\n"
    \       . "Stability   : unstable\n"
    \       . "Portability : portabile\n"
    \       . "\n"
    \       . description . "\n"
    \       . "-}\n"
    \       . "\n"
endfunction

nmap <silent> --h "=HaskellModuleHeader()<CR>:0put =<CR>

nmap <silent> --<Bar> O--<Space><Bar><Space>

function! SetToCabalBuild()
  if glob("*.cabal") != ''
    let a = system( 'grep "/\* package .* \*/"  dist/build/autogen/cabal_macros.h' )
    let b = system( 'sed -e "s/\/\* /-/" -e "s/\*\///"', a )
    let pkgs = "-hide-all-packages " .  system( 'xargs echo -n', b )
    let hs = "import Distribution.Dev.Interactive\n"
    let hs .= "import Data.List\n"
    let hs .= 'main = withOpts [""] error return >>= putStr . intercalate " "'
    let opts = system( 'runhaskell', hs )
    let b:ghc_staticoptions = opts . ' ' . pkgs
  else
    let b:ghc_staticoptions = '-Wall -fno-warn-name-shadowing'
  endif
  execute 'setlocal makeprg=' . g:ghc . '\ ' . escape(b:ghc_staticoptions,' ') .'\ -e\ :q\ %'
  let b:my_changedtick -=1
endfunction

" autocmd BufEnter *.hs,*.lhs :call SetToCabalBuild()
set textwidth=80
