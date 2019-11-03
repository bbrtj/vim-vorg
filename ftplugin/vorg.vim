" vorg.vim - Vim ORG mode. Your stuff in plain text.
" Maintainer:   Ithai Levi <http://github.org/L3V3L9/>
" Version:      0.3
" GetLatestVimScripts: 2842 1 :AutoInstall: vorg.vim

" Indentation settings based on the vorg specification
setlocal smartindent
setlocal softtabstop=2
setlocal tabstop=2
setlocal shiftwidth=2
setlocal noexpandtab

" use TAB in normal mode to fold and unfold patern items
nmap <buffer> <TAB> za
nmap <buffer> <S-TAB> zA

" insert mode shortcuts to add items and tasks
ab <buffer> -- <TAB>-
ab <buffer> -= - [ ]
ab <buffer> == [ ]

" normal mode shortcuts to check and uncheck tasks
nmap <buffer> <silent> = :call vorg#ToggleCheckbox()<CR>
vmap <buffer> <silent> = :call vorg#ToggleCheckbox()<CR>

" shortcut for adding tags at the end of an item
imap <buffer> ` <right><right><space><><left>

" Shift lines up and down
nnoremap <buffer> <C-j> mz:m+<CR>`z
nnoremap <buffer> <C-k> mz:m-2<CR>`z
inoremap <buffer> <C-j> <Esc>:m+<CR>gi
inoremap <buffer> <C-k> <Esc>:m-2<CR>gi
vnoremap <buffer> <C-j> :m'>+<CR>gv=`<my`>mzgv`yo`z
vnoremap <buffer> <C-k> :m'<-2<CR>gv=`>my`<mzgv`yo`z

" shortcut to find tags
nnoremap <buffer> <C-t> :/-.*\<.*.*\><LEFT><LEFT><LEFT>
nnoremap <buffer> <C-o> :/[-\*]\ *\[\ \].*@

" shortcuts for date entry
ab <buffer> dd <C-R>=strftime("%Y-%m-%d")<CR>
ab <buffer> dt <C-R>=strftime("%Y-%m-%d @ %H:%M")<CR>
ab <buffer> -0 - <C-R>=strftime("%Y-%m-%d @ %H:%M")<CR> \|

" add next weekday date shortcuts
ab <buffer> dn1 <C-R>=vorg#DateFollowing(1)<CR>
ab <buffer> dn2 <C-R>=vorg#DateFollowing(2)<CR>
ab <buffer> dn3 <C-R>=vorg#DateFollowing(3)<CR>
ab <buffer> dn4 <C-R>=vorg#DateFollowing(4)<CR>
ab <buffer> dn5 <C-R>=vorg#DateFollowing(5)<CR>
ab <buffer> dn6 <C-R>=vorg#DateFollowing(6)<CR>
ab <buffer> dn7 <C-R>=vorg#DateFollowing(7)<CR>

" add previous weekday date shortcuts
ab <buffer> dp1 <C-R>=vorg#DateFollowing(-1)<CR>
ab <buffer> dp2 <C-R>=vorg#DateFollowing(-2)<CR>
ab <buffer> dp3 <C-R>=vorg#DateFollowing(-3)<CR>
ab <buffer> dp4 <C-R>=vorg#DateFollowing(-4)<CR>
ab <buffer> dp5 <C-R>=vorg#DateFollowing(-5)<CR>
ab <buffer> dp6 <C-R>=vorg#DateFollowing(-6)<CR>
ab <buffer> dp7 <C-R>=vorg#DateFollowing(-7)<CR>
