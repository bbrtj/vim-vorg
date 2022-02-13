" insert mode shortcuts
ab <buffer> -[ - [ ]
ab <buffer> *[ * [ ]
ab <buffer> +[ + [ ]

" normal mode shortcuts
nnoremap <buffer> <silent> cx :call vorgmd#tasks#toggleCheckbox()<CR>
vnoremap <buffer> <silent> cx :call vorgmd#tasks#toggleCheckbox()<CR>

nnoremap <buffer> <silent> ?? :call vorgmd#agenda#show()<CR>

" Plug maps

noremap <buffer> <Plug>VorgmdDeleteInColumn dt\|dT\|=
\:silent! call repeat#set("\<Plug>VorgmdDeleteInColumn", v:count)<CR>

noremap <buffer> <Plug>VorgmdChangeInColumn dT\|ct\|
"\:auto InsertLeave <buffer> ++once :silent! call repeat#set("\<Plug>VorgmdChangeInColumn", v:count)<CR>

noremap <buffer> <Plug>VorgmdYankInColumn T\|yt\|

noremap <buffer> <Plug>VorgmdDeleteAColumn df\|dT\|=
\:silent! call repeat#set("\<Plug>VorgmdDeleteAColumn", v:count)<CR>

noremap <buffer> <Plug>VorgmdChangeAColumn dT\|cf\|
"\:auto InsertLeave <buffer> ++once :silent! call repeat#set("\<Plug>VorgmdChangeAColumn", v:count)<CR>

noremap <buffer> <Plug>VorgmdYankAColumn T\|yf\|

" table key maps
nmap <buffer> <silent> = :call vorgmd#table#align()<CR>
nmap <buffer> dic <Plug>VorgmdDeleteInColumn
nmap <buffer> cic <Plug>VorgmdChangeInColumn
nmap <buffer> yic <Plug>VorgmdYankInColumn
nmap <buffer> dac <Plug>VorgmdDeleteAColumn
nmap <buffer> cac <Plug>VorgmdChangeAColumn
nmap <buffer> yac <Plug>VorgmdYankAColumn
vmap <buffer> ic T\|vvt\|
vmap <buffer> ac T\|vvf\|

nmap <buffer> <silent> <Tab> :call vorgmd#table#jumpCell(1)<CR>
nmap <buffer> <silent> <S-Tab> :call vorgmd#table#jumpCell(-1)<CR>

" shortcuts for date entry
ab <buffer> dd <C-R>=strftime("%Y-%m-%d")<CR>
ab <buffer> dt <C-R>=strftime("%Y-%m-%d @ %H:%M")<CR>

" add next weekday date shortcuts
ab <buffer> dn1 <C-R>=vorgmd#dates#nextWeekday(1)<CR>
ab <buffer> dn2 <C-R>=vorgmd#dates#nextWeekday(2)<CR>
ab <buffer> dn3 <C-R>=vorgmd#dates#nextWeekday(3)<CR>
ab <buffer> dn4 <C-R>=vorgmd#dates#nextWeekday(4)<CR>
ab <buffer> dn5 <C-R>=vorgmd#dates#nextWeekday(5)<CR>
ab <buffer> dn6 <C-R>=vorgmd#dates#nextWeekday(6)<CR>
ab <buffer> dn7 <C-R>=vorgmd#dates#nextWeekday(7)<CR>

" add previous weekday date shortcuts
ab <buffer> dp1 <C-R>=vorgmd#dates#nextWeekday(-1)<CR>
ab <buffer> dp2 <C-R>=vorgmd#dates#nextWeekday(-2)<CR>
ab <buffer> dp3 <C-R>=vorgmd#dates#nextWeekday(-3)<CR>
ab <buffer> dp4 <C-R>=vorgmd#dates#nextWeekday(-4)<CR>
ab <buffer> dp5 <C-R>=vorgmd#dates#nextWeekday(-5)<CR>
ab <buffer> dp6 <C-R>=vorgmd#dates#nextWeekday(-6)<CR>
ab <buffer> dp7 <C-R>=vorgmd#dates#nextWeekday(-7)<CR>

setlocal foldmethod=expr
setlocal foldexpr=vorgmd#folding#foldExpr(v:lnum)
setlocal foldtext=vorgmd#folding#foldText()

