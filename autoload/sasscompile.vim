"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/sass-compile.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:sass_compile_cdloop")
    let g:sass_compile_cdloop = 5
endif
if !exists("g:sass_compile_sassdir")
    let g:sass_compile_sassdir = ['scss', 'sass']
endif
if !exists("g:sass_compile_cssdir")
    let g:sass_compile_cssdir = ['css', 'css']
endif
if !exists("g:sass_compile_sourcemap")
    let g:sass_compile_sourcemap = 1
endif
if !exists("g:sass_compile_beforecmd")
    let g:sass_compile_beforecmd = ''
endif
if !exists("g:sass_compile_aftercmd")
    let g:sass_compile_aftercmd = ''
endif

function! sasscompile#CompassCheck()
    if filereadable('config.rb')
        return 1
    endif
    return 0
endfunction

function! sasscompile#SassCheck()
    let css = ''
    for e in g:sass_compile_cssdir
        if isdirectory(e)
            let css = e
            break
        endif
    endfor
    return css
endfunction

function! sasscompile#CompassConfig()
    let confile = searchparent#File('config.rb')
    if confile != ''
        exec 'e '.confile
    else
        echomsg "sass config not found."
    endif
endfunction

function! sasscompile#SassCompile()
    let cdir = getcwd()
    let fdir = expand('%:p:h')
    let compassconf = searchparent#File('config.rb')
    let cmd = ''
    let compassFlg = 0

    if compassconf != ''
        if readfile(compassconf)[0] != '# auto-compile stopped.'
            let dir = fnamemodify(compassconf, ':h')
            exec 'silent cd '.dir
            let cmd = 'compass compile '.(g:sass_compile_sourcemap ? '--sourcemap' : '--no-sourcemap').' &'
        endif
    else
        let dir = searchparent#Dir(g:sass_compile_cssdir)
        if dir != ''
            let cmd = 'sass --update --sourcemap='.((g:sass_compile_sourcemap ? 'auto' : 'none')).' '.fdir.':'.dir . ' &'
        endif
    endif

    if cmd != ''
        if g:sass_compile_beforecmd != ''
            call system(g:sass_compile_beforecmd)
        endif
        if g:sass_compile_aftercmd != ''
            let cmd = "sasscompileresult=$(".cmd."|sed s/'\[[0-9]*m'/''/g|tr '\\n' '__'|tr ' ' '_')\n ".g:sass_compile_aftercmd
        endif

        redir @a
            echomsg cmd
            call system(cmd)
        redir END

        " cgetexpr @a
        " copen
    endif

    exec 'silent cd '.cdir
endfunction

let &cpo = s:save_cpo
