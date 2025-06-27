" Compiler support.
" ==============================================================================
" See: `:help compiler`

" Supports:
" - :make  -- Compile
" - :copen -- Open populated QuickFix List

" Use `../compiler/mklatex.vim` for `ft=tex` files.
compiler mklatex

" VimTeX support.
" ==============================================================================
" See: `:help vimtex`

" Supports:
" - :VimtexCompile       -- Run the compiler (and populate QuickFix List
"                           according to `g:vimtex_quickfix_*` variables).
" - :VimtexCompileOutput -- Show the compiler output.
" - :VimtexView          -- Forward Synctex search (open viewer if not opened).

" Use the compiler defined by the `g:vimtex_compiler_generic` variable.
let g:vimtex_compiler_method = 'generic'

" Define how VimTeX will interface with MKLaTeX.
" commands:
"   Needs to `cd` at first otherwise command is run from `src/tex`
"   containing the main TeX file.
" out_dir:
"   Allows the :VimtexView command to find PDF (will use the basename of the
"   `.tex` file). Relative to `root` key displayed by `VimtexInfo` command.
" continuous: 
"   MKLaTeX does not support a special option to make it running
"   continuous.
let g:vimtex_compiler_generic = {
            \   'command' : 'cd $MKLATEX_ROOT && mklatex -l @tex',
            \   'out_dir' : '../../build/tex',
            \   'continuous' : 0,
            \   'hooks' : [],
            \}

" Reload VimTeX such that modified variable are effectively used.
VimtexReloadState
