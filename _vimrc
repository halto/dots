" vim:set ts=2 sts=2 sw=2 tw=0:

if 0 | endif

set encoding=utf-8
scriptencoding utf-8

if has('vim_starting')
  set nocompatible
  set runtimepath+=$HOME/vimfiles/bundle/neobundle.vim
endif

call neobundle#begin(expand('$HOME/vimfiles/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle      'Shougo/unite.vim'
NeoBundle      'ujihisa/unite-colorscheme'

NeoBundle      'tomasr/molokai'
NeoBundle      'cocopon/iceberg.vim'
NeoBundle      'nanotech/jellybeans.vim'
NeoBundle      'itchyny/lightline.vim'

NeoBundle      'vim-scripts/taglist.vim'
""NeoBundle      'vim-scripts/vcscommand.vim.git'
NeoBundle      'szw/vim-tags'

NeoBundle      'scrooloose/nerdtree'

NeoBundle      'Shougo/neocomplcache'
let g:neocomplcache_enable_at_startup = 1

NeoBundle      'AndrewRadev/linediff.vim'

NeoBundle      'kana/vim-textobj-user'
NeoBundle      'tkhren/vim-textobj-numeral'

NeoBundle      'pboettch/vim-cmake-syntax'

NeoBundle      'mopp/next-alter.vim'

call neobundle#end()

filetype plugin indent on
syntax   on

NeoBundleCheck


"set enc=cp932
set fileencodings=utf-8,cp932,euc-jp,sjis
set runtimepath+=$HOME/vimfiles


if has('gui_running') && argc()
  let s:running_vim_list = filter(
		\ split(serverlist(), '\n'),
		\ 'v:val !=? v:servername'
		\ )
  if !empty(s:running_vim_list)
	silent execute '!start gvim'
		\ ' --servername' s:running_vim_list[0]
		\ ' --remote-tab-silent' join(argv(), ' ')
	qa!
  endif
  unlet s:running_vim_list
endif


" - filetype
autocmd BufNewFile,BufRead *.md        :set      filetype=markdown
autocmd BufNewFile,BufRead *.src       :set      filetype=asm

" - auto linefeed off
set tw=0
autocmd BufRead *.c    setlocal tw=0
" - auto linefeed on
autocmd BufRead *.md   setlocal tw=0
autocmd BufRead *.txt  setlocal tw=0
""execute "set colorcolumn=" . join(range(75,9999),',')

" - cursorline
autocmd VimEnter,ColorScheme * hi CursorLine cterm=underline
autocmd InsertEnter * hi CursorLine cterm=bold
autocmd InsertLeave * hi CursorLine cterm=underline

" - quickfix
autocmd QuickFixCmdPost *grep* cwindow

set clipboard+=autoselect
set clipboard+=unnamed
set backspace=indent,eol,start

" - possible to switch buffer with no saving
set hidden
" - input completion
set wildmenu
set wildmode=list:longest
" - do not switch on IME when insert mode with new file
set iminsert=0
set imsearch=0

" - directories
set directory=$HOME/vimfiles/_swaps
set viewdir=$HOME/vimfiles/_views

" - undo
set undofile
set undodir=$HOME/vimfiles/_undos

" - backup
set backup
set writebackup
" set patchmode=.orig
" set backupdir=.
set backupdir=$HOME/vimfiles/_backups

" - ctags
set tags=./tags,tags

" - convert windows backslash to slash
set shellslash

" - wait time to complete keycode and mapping key
set timeoutlen=3500
set history=100

set showmode
set shortmess-=n
set shortmess+=I
set nrformats-=octal
set formatoptions+=mMt
set nowrap
set whichwrap=b,s,[,],<,>
set iskeyword=a-z,A-Z,48-57,_,.,-,>

set incsearch
set ignorecase
set smartcase
set wrapscan

function! BufGrepAdd(word)
  cexpr ''
  silent exec ':bufdo | try | vimgrepadd /' . a:word . '/j % | catch | endtry'
  silent cwin
endfunction

command! -nargs=1 BufGrepAdd :call BufGrepAdd(<f-args>)

nmap g/ :exec        ':vimgrep /'          . getreg('/') . '/j %\|cwin'<CR>
nmap G/ :silent exec ':bufdo vimgrepadd /' . getreg('/') . '/j %'<CR> \|:silent cwin<CR>

" internal grep
nnoremap <expr> <Space>g ':vimgrep /\<' . expand('<cword>') . '\>/j **/*.' . expand('%:e')
" external grep
set grepprg=findstr\ /n
nnoremap <expr> <Space>G ':sil grep! /S /N /R ' . expand('<cword>') . ' *.c *.h '

cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\/' : '?'

set expandtab
set tabstop=4
set softtabstop=4
set smarttab
set shiftwidth=4
set autoindent
set copyindent
set preserveindent
set smartindent

set cmdheight=2
set laststatus=2
set list
set listchars=tab:.\ ,trail:_,extends:<

" echo exists("+autochdir")
" if 1, :set autochdir is enable
" if 0, :cd %:h
" set autochdir

function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:MyTabLine()
  let s = ''
  for i in range(1, tabpagenr('$'))
  	let bufnrs = tabpagebuflist(i)
  	let bufnr  = bufnrs[tabpagewinnr(i) -1]
  	let no     = i
  	let mod    = getbufvar(bufnr, '&modified') ? '+' : ' '
  	let title  = fnamemodify(bufname(bufnr), ':t')
  	let title  = title is '' ? 'No title' : title
  	let title  = '[' . title . ']' 
  	let s     .= '%' . i . 'T'
  	let s     .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
  	let s     .= ' ' . no . ':' . title
  	let s     .= mod
  	let s     .= '%#TabLineFill# '
  endfor
  let s     .= '%#TabLineFill#%T%=%#TabLine#'
"  let s     .= '%#TabLineFill#%T%#TabLine#'
  return s
endfunction

let &tabline = '%!' . s:SID_PREFIX() . 'MyTabLine()'
set showtabline=1

nnoremap [Tag] <Nop>
nmap     t     [Tag]

for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]' .n ':<C-u>tabnext' .n. '<CR>'
endfor

map <silent> [Tag]c :tablast  <bar> tabnew<CR>
map <silent> [Tag]x :tabclose<CR>
map <silent> [Tag]n :tabnext<CR>
map <silent> [Tag]p :tabprevious<CR>
map <silent> [Tag]e :tab split<CR>


set number
set showcmd
set showmatch matchtime=1

set hlsearch
nnoremap <silent> gh :let @/=''<CR>

set display=lastline
set diffopt=filler,vertical

set foldmethod=marker

if has('win32') || has('win64')
  set diffexpr=MyDiff()
  function! MyDiff()
  	let opt = '-a --binary '
  	if &diffopt =~ 'icase'  | let opt = opt . '-i ' | endif
  	if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  	let arg1 = v:fname_in
  	if  arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  	let arg2 = v:fname_new
  	if  arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  	let arg3 = v:fname_out
  	if  arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  	silent execute '!diff ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  endfunction
  command! MyDiff call MyDiff()
endif

" view diff with current buffer
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" view diff with file or buffer#
command! -nargs=? -complete=file Diff if '<args>' == '' | browse vertical diffsplit | else | vertical diffsplit <args> | endif

" patch
set patchexpr=MyPatch()
function! MyPatch()
  :call system($VIM."\\'.'patch -o " . v:fname_out . " " . v:fname_in . " < " . v:fname_diff)
endfunction

" calendar
let g:calendar_holidayfile='~/vimfiles/ftplugins/Sche-Hd-0000-00-00-000000.utf8'

" textobj-numeral
function! Increment(motion, step)
  let inc_key = a:step > 0 ? "<C-a>" : "\<C-x>"
  let @z = '"zyad' . a:motion . 'vad"zp' . abs(a:step) . inc_key
  return '@z'
endfunction

nmap <expr> + Increment('gNx',  4)
nmap <expr> - Increment('gNx', -1)
nmap <expr> ) Increment('gNx',  1)
nmap <expr> ( Increment('gNx', -1)


" cscope
" how to create a cscope database file (cscope.out)
" $dir/s /b > cscope.files
" $cscope
if has('cscope')

  set csprg=D:/App/Bin/cscope.exe

  " use both cscope and ctag for 'ctrl-]', ':ta' and 'vim -t'
  set cscopetag

  " check cscope for definition of a symbol before checking ctags: set to 1
  " if you want the reverse search order.
  set csto=0

  " add any cscope database in current directory
  if filereadable("cscope.out")
  	cs add cscope.out
  elseif $CSCOPE_DB != ""
  	cs add $CSCOPE_DB
  endif

  " show msg when any other cscope db added
  set cscopeverbose

  set cscopequickfix=s-,c-,d-,i-,t-,e-

  " hit 'CTRL-\', followed by one of the cscope search types (s,g,c,t,e,f,i,d).
  nmap <C-\>s :cs find s  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>g :cs find g  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>c :cs find c  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>t :cs find t  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>e :cs find e  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>f :cs find f  <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-\>d :cs find d  <C-R>=expand("<cword>")<CR><CR>

  " hit 'CTRL-space' (interpreted as CTRL-@ by vim) then a search type makes the vim
  " window split horizontally, with search result displayed in the new window
  nmap <C-@>s :scs find s  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@>g :scs find g  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@>c :scs find c  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@>t :scs find t  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@>e :scs find e  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@>f :scs find f  <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-@>d :scs find d  <C-R>=expand("<cword>")<CR><CR>

  " hit 'CTRL-space' *twice* before the search type does a vertical split instead of a 
  " horizontal one (vim 6 and up only)
  nmap <C-@><C-@>s :vert scs find s  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>g :vert scs find g  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>c :vert scs find c  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>t :vert scs find t  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>e :vert scs find e  <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>f :vert scs find f  <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-@><C-@>d :vert scs find d  <C-R>=expand("<cword>")<CR><CR>

  " By default Vim will only wait 1 second for each keystroke in a mapping. You may find
  " that too short with the above typemaps. if so, you should either turn off mapping timeouts
  " via 'notimeout'
  " set notimeout

  " Or, you can keep timeouts, by uncommenting the timeoutlen line below, with your own personal
  " favorite value (in milliseconds):
  " set timeoutlen=4000

  " set ttimeout
  " set ttimeoutlen=100
endif


" unite
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable=1
"let g:unite_source_file_mru_limit=200
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>


" Tlist
set tags=./tags,tags
let Tlist_Ctags_Cmd = "ctags.exe"
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 0
let Tlist_Exit_OnlyWindow = 1
map <silent> <Leader>l :TlistToggle<CR>

"" VCSCommand
"augroup VCSCommand
"  autocmd!
"  autocmd User VCSBufferCreated call s:vcscommand_buffer_settings()
"augroup END
"
"function! s:vcscommand_buffer_settings()
"  if !exists('b:VCSCommandCommand') | return | endif
"  if b:VCSCommandCommand !=# 'commitlog' | setlocal readonly     | endif
"  if b:VCSCommandCommand !=# 'vimdiff'   | setlocal nofoldenable | endif
"  if &filetype ==# 'gitlog'              | setlocal syntax=git   | endif
"  nmap <unique> <buffer> <silent> q :bwipeout<CR>
"  if &filetype =~# '^\(svnlog\|gitlog\|hglog\)$'
"    nnoremap <silent> <buffer> <CR> :<C-u>call <SID>vcscommand_filetype('log', 'VCSDiff')<CR>gg
"    nnoremap <silent> <buffer> v    :<C-u>call <SID>vcscommand_filetype('log', 'VCSVimDiff')<CR>gg
"    nnoremap <silent> <buffer> r    :<C-u>call <SID>vcscommand_filetype('log', 'VCSReview')<CR>gg
"    nnoremap <silent> <buffer> i    :<C-u>call <SID>vcscommand_filetype('log', 'VCSInfo')<CR>gg
"  elseif b:VCSCommandCommand =~# '.*annotate'
"    nnoremap <silent> <buffer> <CR> :<C-u>call <SID>vcscommand_filetype('annotate', 'VCSDiff')<CR>gg
"    nnoremap <silent> <buffer> v    :<C-u>call <SID>vcscommand_filetype('annotate', 'VCSVimDiff')<CR>gg
"    nnoremap <silent> <buffer> r    :<C-u>call <SID>vcscommand_filetype('annotate', 'VCSReview')<CR>gg
"    nnoremap <silent> <buffer> l    :<C-u>call <SID>vcscommand_filetype('annotate', 'VCSLog')<CR>gg
"    nnoremap <silent> <buffer> i    :<C-u>call <SID>vcscommand_filetype('annotate', 'VCSInfo')<CR>gg
"  endif
"endfunction
"
"function! s:vcscommand_exec(command, option)
"  if a:command =~# '^\(VCSDiff\|VCSLog\)$'
"    let g:VCSCommandSplit = winnr('$') == 1 ? 'vertical' : 'horizontal'
"  endif
"  execute a:command a:option
"  unlet! g:VCSCommandSplit
"endfunction
"
"function! s:vcscommand_log(...)
"  let option = join(a:000)
"  if exists('b:VCSCommandVCSType')
"    if exists('b:VCSCommandCommand')
"      if b:VCSCommandCommand ==# 'log'
"        echo "Sorry, you cannot open vcslog on vcslog buffer"
"        unlet option
"      elseif b:VCSCommandCommand =~# 'diff\|review'
"        if !exists('b:VCSCommandStatusText')
"          echo "Sorry, you are on a working buffer"
"          unlet option
"        else
"          " Shows only the target revision/commit
"          if b:VCSCommandVCSType ==# 'SVN'
"            let matched = matchlist(b:VCSCommandStatusText, '(\d\+ : \(\d\+\))')
"            if len(matched) | let option = matched[1] | endif
"          elseif b:VCSCommandVCSType ==# 'git'
"            let matched = matchlist(b:VCSCommandStatusText, '\S\+ \(\w\+\)')
"            if len(matched) | let option = '-n 1 ' . matched[1] | endif
"          elseif b:VCSCommandVCSType ==# 'HG'
"            let matched = matchlist(b:VCSCommandStatusText, '(\(\d\+\) : \w\+)')
"            if len(matched) | let option = matched[1] | endif
"          endif
"        endif
"      endif
"    elseif v:count
"      if b:VCSCommandVCSType ==# 'SVN'
"        let limit_option = '-l'
"      elseif b:VCSCommandVCSType ==# 'git'
"        let limit_option = '-n'
"      elseif b:VCSCommandVCSType ==# 'HG'
"        let limit_option = '-l'
"      endif
"      let option = limit_option . ' ' . v:count
"    endif
"  endif
"  if exists('option')
"    call s:vcscommand_exec('VCSLog', option)
"  endif
"endfunction
"
"function! s:vcscommand_filetype(filetype, command)
"  let given_count1 = v:count1
"  let revision = s:vcscommand_get_revision_on_cursor_line(a:filetype)
"  if strlen(revision)
"    let option = s:vcscommand_make_vcs_option(a:command, revision, given_count1)
"    call s:vcscommand_exec(a:command, option)
"  endif
"endfunction
"
"function! s:vcscommand_get_revision_on_cursor_line(filetype)
"  let save_cursor = getpos('.')
"  let save_yank_register = getreg('"')
"  if a:filetype ==# 'log'
"    if &filetype ==# 'svnlog'
"      normal! j
"      ?^r\d\+\ |
"      normal! 0lye
"    elseif &filetype ==# 'gitlog'
"      normal! j
"      ?^commit\ \w\+$
"      normal! 0wy7l
"    elseif b:VCSCommandVCSType ==# 'HG'
"      normal! j
"      ?^changeset:\ \+\d\+:\w\+$
"      normal! Wyw
"    endif
"  elseif a:filetype ==# 'annotate'
"    if b:VCSCommandVCSType ==# 'SVN'
"      normal! 0wye
"    elseif b:VCSCommandVCSType ==# 'git'
"      normal! 0t yb
"    elseif b:VCSCommandVCSType ==# 'HG'
"      normal! 0f:yb
"    endif
"  endif
"  let revision = @"
"  call setpos('.', save_cursor)
"  call setreg('"', save_yank_register)
"  return revision
"endfunction
"
"function! s:vcscommand_make_vcs_option(command, revision, given_count1)
"  let option = a:revision
"  if b:VCSCommandVCSType ==# 'SVN'
"    if a:command ==# 'VCSLog'
"      let older = a:given_count1 == 1 ? '' : a:given_count1 . ':'
"      let option = '-r ' . older . a:revision
"    elseif a:command ==# 'VCSInfo'
"      let option = '-r ' . a:revision
"    elseif a:command =~# 'VCSDiff\|VCSVimDiff'
"      let older = a:given_count1 == 1 ? str2nr(a:revision) - 1 : a:given_count1
"      let option = older . ' ' . a:revision
"    endif
"  elseif b:VCSCommandVCSType ==# 'git'
"    if a:command ==# 'VCSLog'
"      let option = '-n ' . a:given_count1 . ' ' . a:revision
"    elseif a:command =~# 'VCSDiff\|VCSVimDiff'
"      let older = a:revision . '~' . a:given_count1
"      let option = older . ' ' . a:revision
"    endif
"  elseif b:VCSCommandVCSType ==# 'HG'
"    if a:command ==# 'VCSLog'
"      let option = '-l ' . a:given_count1 . ' -r ' . a:revision
"    elseif a:command =~# 'VCSDiff\|VCSVimDiff'
"      let older = a:given_count1 == 1 ? str2nr(a:revision) - 1 : a:given_count1
"      "let option = '-r ' . older . ' -r ' . a:revision
"      let option = a:revision
"    endif
"  endif
"  return option
"endfunction

" Calendar
map <Leader>ch :CalendarH<CR>
map <Leader>cc :Calendar<CR>


" Keybind
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>

nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>

nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

nnoremap J gJ
nnoremap gJ J

map gb :ls<CR>:buf
map db :ls<CR>:bdel

nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz


nnoremap <C-]> g<C-]>

runtime macros/matchit.vim

imap <c-x> <DEL>

imap <c-e> <END>
imap <c-a> <HOME>
imap <c-h> <LEFT>
imap <c-j> <DOWN>
imap <c-k> <UP>
imap <c-l> <RIGHT>

imap {} {}<LEFT>
imap () ()<LEFT>
imap [] []<LEFT>
imap <> <><LEFT>
imap "" ""<LEFT>
imap '' ''<LEFT>

noremap <silent> <SPACE>e :<C-u>e ~/_vimrc<CR>
noremap <silent> <SPACE>d :<C-u>bdel ~/_vimrc<CR>

"{
" 'mopp/next-alter.vim'
  nmap <Leader>ano <Plug>(next-alter-open)
  let g:next_alter#pair_extension = {
              \  'c'   : [ 'h', 'H' ],
              \  'C'   : [ 'h', 'H' ],
              \  'cc'  : [ 'h', 'H' ],
              \  'CC'  : [ 'h', 'H' ],
              \  'cpp' : [ 'h', 'H', 'hpp', 'HPP' ],
              \  'CPP' : [ 'h', 'H', 'hpp', 'HPP' ],
              \  'cxx' : [ 'h', 'H', 'hpp', 'HPP' ],
              \  'CXX' : [ 'h', 'H', 'hpp', 'HPP' ],
              \  'h'   : [ 'c', 'C', 'cpp', 'CPP', 'cxx', 'CXX' ],
              \  'H'   : [ 'c', 'C', 'cpp', 'CPP', 'cxx', 'CXX' ],
              \  'hpp' : [ 'c', 'C', 'cpp', 'CPP', 'cxx', 'CXX' ],
              \  'HPP' : [ 'c', 'C', 'cpp', 'CPP', 'cxx', 'CXX' ],
              \}
  let g:next_alter#search_dir = [ '.', '..', './include', './inc', '../include', '../inc' ]
  let g:next_alter#open_option = 'vertical topleft'
"}


"set verbosefile=~/vim.log
"set verbose=20
