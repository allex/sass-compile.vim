"
" AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"          Allex Wang <allex.wxn@gmail.com>
" WEBSITE:  https://github.com/AtsushiM/sass-compile.vim
" VERSION:  0.9
" LICENSE:  MIT
" Last Modified: Thu Nov 26, 2015 04:23PM
"

if exists("g:loaded_sass_compile")
    finish
endif
let g:loaded_sass_compile = 1

if !executable('sass')
    echohl ErrorMsg
    echo 'requires sass.'
    echohl None
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:sass_compile_file")
    let g:sass_compile_file = ['scss', 'sass']
endif
if !exists("g:sass_compile_auto")
    let g:sass_compile_auto = 0
endif

command! CompassCreate call sasscompile#CompassCreate()
command! CompassConfig call sasscompile#CompassConfig()
command! SassCompile call sasscompile#SassCompile()

" sass auto compile
if g:sass_compile_auto == 1
    augroup sass
        au!
        for e in g:sass_compile_file
            exec 'au BufWritePost *.'.e.' :silent! call sasscompile#SassCompile()'
        endfor
    augroup END
endif

let &cpo = s:save_cpo
