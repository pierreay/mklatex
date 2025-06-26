" See:
" `:help write-compiler-plugin`
" https://ejmastnak.com/tutorials/vim-latex/compilation/#compiler

" Header
" ==============================================================================

" Do not load twice.
if exists("current_compiler")
	finish
endif
let current_compiler = "mklatex"

" Definitions
" ==============================================================================

" Define command for `makeprg`.
let s:mklatex_cmd  = 'mklatex %:p'

" Sets correct value of `makeprg`.
function! s:TexSetMakePrg() abort
  let &l:makeprg = expand(s:mklatex_cmd)
endfunction

" Script
" ==============================================================================

" Set Vim's `makeprg` options.
call s:TexSetMakePrg()  " set value of Vim's `makeprg` option

" Set Vim's `errorformat` options.
" `errorformat` assumes the TeX source file is compiled with `-file-line-error` option enabled.
setlocal errorformat=%-P**%f
setlocal errorformat+=%-P**\"%f\"
" Match errors
setlocal errorformat+=%E!\ LaTeX\ %trror:\ %m
setlocal errorformat+=%E%f:%l:\ %m
setlocal errorformat+=%E!\ %m
" More info for undefined control sequences
setlocal errorformat+=%Z<argument>\ %m
" More info for some errors
setlocal errorformat+=%Cl.%l\ %m
" Ignore unmatched lines
setlocal errorformat+=%-G%.%#
